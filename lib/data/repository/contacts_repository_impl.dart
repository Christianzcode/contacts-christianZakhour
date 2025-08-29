// lib/data/repository/contacts_repository_impl.dart
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

import '../../core/network/connectivity_service.dart'; // 👈 add this
import '../../domain/entities/change_record.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../local/contacts_dao.dart';
import '../local/history_dao.dart';
import '../local/pending_ops_dao.dart';
import '../mappers/contact_mapper.dart';
import '../remote/contacts_api.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  // 👇 inject connectivity service
  final ConnectivityService connectivity;
  ContactsRepositoryImpl({required this.connectivity});

  final _contactsDao = ContactsDao();
  final _historyDao = HistoryDao();
  final _opsDao = PendingOpsDao();
  final _api = ContactsApi();
  final _uuid = const Uuid();

  @override
  Future<List<Contact>> getLocal() => _contactsDao.getAll();

  @override
  @override
  Future<List<Contact>> refreshFromRemote() async {
    final remote = await _api.fetchAll();
    final now = DateTime.now();
    final current = await _contactsDao.getAll();

    for (final dto in remote) {
      final incoming = dto.toEntity().copyWith(updatedAt: now);

      final existing = current.firstWhereOrNull((c) => c.remoteId == dto.id);

      if (existing == null) {
        // brand new remote → insert
        await _contactsDao.upsert(incoming);
      } else {
        // update only if remote is fresher
        if (existing.updatedAt.isBefore(incoming.updatedAt)) {
          await _contactsDao.upsert(
            incoming.copyWith(id: existing.id), // keep same local id
          );
        }
      }
    }

    return _contactsDao.getAll();
  }


  @override
  Future<Contact> upsert(Contact contact, {bool offline = false, Contact? previous}) async {
    final updated = contact.copyWith(
      updatedAt: DateTime.now(),
      pendingSync: offline,
    );

    await _contactsDao.upsert(updated);

    await _historyDao.insert(ChangeRecord(
      id: _uuid.v4(),
      contactId: updated.id,
      createdAt: DateTime.now(),
      op: previous == null ? 'create' : 'update',
      diff: _diffForUpsert(old: previous, now: updated),
    ));

    // 👇 USE connectivity: if we're not explicitly offline, check real online state
    final shouldTryOnline = !offline && await connectivity.isOnline();
    if (shouldTryOnline) {
      await _api.upsert(_toRemotePayload(updated), remoteId: updated.remoteId);
    } else {
      await _opsDao.push(
        _uuid.v4(),
        updated.id,
        'upsert',
        jsonEncode(updated.toJson()),
        updated.updatedAt.millisecondsSinceEpoch,
      );
    }
    return updated;
  }

  @override
  Future<void> delete(Contact contact, {bool offline = false}) async {
    await _contactsDao.softDelete(contact);

    await _historyDao.insert(ChangeRecord(
      id: _uuid.v4(),
      contactId: contact.id,
      createdAt: DateTime.now(),
      op: 'delete',
      diff: {
        'name': {'before': contact.name, 'after': null},
        'email': {'before': contact.email, 'after': null},
        'phone': {'before': contact.phone, 'after': null},
        'company': {'before': contact.company, 'after': null},
      },
    ));

    // 👇 USE connectivity here too
    final shouldTryOnline = !offline && await connectivity.isOnline();
    if (shouldTryOnline && contact.remoteId != null) {
      await _api.deleteRemote(contact.remoteId!);
    } else {
      await _opsDao.push(
        _uuid.v4(),
        contact.id,
        'delete',
        jsonEncode(contact.toJson()),
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  @override
  Future<List<ChangeRecord>> historyFor(String contactId) =>
      _historyDao.forContact(contactId);

  @override
  Future<void> trySyncPendingQueue() async {
    // 👇 USE connectivity: skip if offline
    if (!await connectivity.isOnline()) return;

    final ops = await _opsDao.all();
    for (final op in ops) {
      final payload =
      jsonDecode(op['payload'] as String) as Map<String, dynamic>;

      if (op['op'] == 'upsert') {
        final c = Contact.fromJson(payload);
        await _api.upsert(_toRemotePayload(c), remoteId: c.remoteId);
      } else if (op['op'] == 'delete') {
        final c = Contact.fromJson(payload);
        if (c.remoteId != null) {
          await _api.deleteRemote(c.remoteId!);
        }
      }
      await _opsDao.remove(op['id'] as String);
    }
  }

  Map<String, dynamic> _toRemotePayload(Contact c) => {
    'id': c.remoteId,
    'name': c.name,
    'email': c.email,
    'phone': c.phone,
    'company': {'name': c.company},
    'updatedAt': c.updatedAt.toIso8601String(),
  };

  Map<String, Map<String, dynamic>?> _diffForUpsert({
    Contact? old,
    required Contact now,
  }) {
    old ??=  Contact(
      id: '',
      name: '',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
    Map<String, Map<String, dynamic>?> f(
        String key,
        dynamic a,
        dynamic b,
        ) =>
        a == b
            ? {}
            : {
          key: {'before': a, 'after': b}
        };

    return {
      ...f('name', old.name, now.name),
      ...f('email', old.email, now.email),
      ...f('phone', old.phone, now.phone),
      ...f('company', old.company, now.company),
    };
  }
}
