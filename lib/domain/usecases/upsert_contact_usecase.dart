import '../entities/contact.dart';
import '../repositories/contacts_repository.dart';

class UpsertContactUsecase {
  final ContactsRepository repo;
  UpsertContactUsecase(this.repo);
  Future<Contact> call(Contact c, {bool offline = false, Contact? previous}) =>
      repo.upsert(c, offline: offline, previous: previous);
}