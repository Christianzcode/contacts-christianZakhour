// lib/presentation/blocs/history/history_cubit.dart
import 'package:bloc/bloc.dart';
import '../../../domain/entities/change_record.dart';
import '../../../domain/repositories/contacts_repository.dart';

class HistoryCubit extends Cubit<List<ChangeRecord>> {
  final ContactsRepository repo;
  HistoryCubit(this.repo) : super([]);

  Future<void> load(String contactId) async {
    emit(await repo.historyFor(contactId));
  }
}
