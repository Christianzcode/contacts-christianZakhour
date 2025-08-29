// lib/data/local/contacts_dao.dart
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/contact.dart';
import 'data_base_scheme.dart';

class ContactsDao {
  Future<Database> get _db async => AppDb.instance();

  Future<List<Contact>> getAll() async {
    final db = await _db;
    final rows = await db.query('contacts', where: 'deleted=0', orderBy: 'name ASC');
    return rows.map((r) => Contact.fromJson({
      ...r,
      'updatedAt': DateTime.fromMillisecondsSinceEpoch(r['updatedAt'] as int).toIso8601String(),
      'deletedAt': r['deletedAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(r['deletedAt'] as int).toIso8601String(),
      'pendingSync': (r['pendingSync'] as int) == 1,
      'deleted': (r['deleted'] as int) == 1,
    })).toList();
  }

  Future<void> upsert(Contact c) async {
    final db = await _db;
    await db.insert('contacts', {
      ...c.toJson(),
      'updatedAt': c.updatedAt.millisecondsSinceEpoch,
      'deletedAt': c.deletedAt?.millisecondsSinceEpoch,
      'pendingSync': c.pendingSync ? 1 : 0,
      'deleted': c.deleted ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> softDelete(Contact c) async {
    final db = await _db;
    await db.update('contacts', {
      'deleted': 1,
      'deletedAt': DateTime.now().millisecondsSinceEpoch,
      'pendingSync': 1,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    }, where: 'id=?', whereArgs: [c.id]);
  }
}
