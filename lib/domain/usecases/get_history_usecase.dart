import '../entities/change_record.dart';
import '../repositories/contacts_repository.dart';

class GetHistoryUsecase {
  final ContactsRepository repo;
  GetHistoryUsecase(this.repo);
  Future<List<ChangeRecord>> call(String id) => repo.historyFor(id);
}
