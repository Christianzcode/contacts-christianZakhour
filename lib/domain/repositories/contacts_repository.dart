// lib/domain/repositories/contacts_repository.dart
import '../entities/contact.dart';
import '../entities/change_record.dart';

abstract class ContactsRepository {
  Future<List<Contact>> getLocal();
  Future<List<Contact>> refreshFromRemote(); // returns new local snapshot after sync
  Future<Contact> upsert(Contact contact, {bool offline = false, Contact? previous}); // 👈 add previous
  Future<void> delete(Contact contact, {bool offline = false});
  Future<List<ChangeRecord>> historyFor(String contactId);
  Future<void> trySyncPendingQueue(); // call when connectivity is back
}
