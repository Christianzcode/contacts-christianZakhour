import '../entities/contact.dart';
import '../repositories/contacts_repository.dart';

class GetContactsUsecase {
  final ContactsRepository repo;
  GetContactsUsecase(this.repo);
  Future<List<Contact>> call() => repo.getLocal();
}