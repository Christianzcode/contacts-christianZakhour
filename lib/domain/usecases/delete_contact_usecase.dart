import '../entities/contact.dart';
import '../repositories/contacts_repository.dart';

class DeleteContactUsecase {
  final ContactsRepository repo;
  DeleteContactUsecase(this.repo);
  Future<void> call(Contact c, {bool offline = false}) => repo.delete(c, offline: offline);
}