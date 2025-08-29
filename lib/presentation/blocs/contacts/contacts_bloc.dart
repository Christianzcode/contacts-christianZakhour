// lib/presentation/blocs/contacts/contacts_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/contact.dart';
import '../../../domain/repositories/contacts_repository.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactsRepository repo;
  List<Contact> _all = [];

  ContactsBloc(this.repo) : super(ContactsLoading()) {
    on<ContactsStarted>((e, emit) async {
      emit(ContactsLoading());
      try {
        _all = await repo.getLocal();
        if (_all.isEmpty) {
          // First launch: try API else show error with optional cached
          try {
            _all = await repo.refreshFromRemote();
            emit(_all.isEmpty ? ContactsEmpty() : ContactsContent(_all));
          } catch (_) {
            emit(ContactsError(hasCache: false));
          }
        } else {
          emit(ContactsContent(_all));
          // SWR refresh in background
          try {
            _all = await repo.refreshFromRemote();
            add(ContactsSearch('')); // re-emit
          } catch (_) {/* ignore */}
        }
      } catch (_) {
        emit(ContactsError(hasCache: _all.isNotEmpty));
      }
    });

    on<ContactsRefresh>((e, emit) async {
      try {
        _all = await repo.refreshFromRemote();
        emit(ContactsContent(_all));
      } catch (_) {
        emit(ContactsError(hasCache: _all.isNotEmpty));
      }
    });

    on<ContactsSearch>((e, emit) {
      final q = e.query.toLowerCase();
      final filtered = _all.where((c) {
        final s = '${c.name} ${c.email ?? ""}'.toLowerCase();
        return s.contains(q);
      }).toList();
      emit(filtered.isEmpty ? ContactsEmpty() : ContactsContent(filtered));
    });
  }
}
