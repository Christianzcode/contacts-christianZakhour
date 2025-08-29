// lib/presentation/blocs/contact_form/contact_form_cubit.dart
import 'package:bloc/bloc.dart';
import '../../../domain/entities/contact.dart';
import '../../../domain/repositories/contacts_repository.dart';

class ContactFormCubit extends Cubit<Contact?> {
  final ContactsRepository repo;
  ContactFormCubit(this.repo) : super(null);

  Future<void> save(Contact contact, {required bool offline}) async {
    final saved = await repo.upsert(contact, offline: offline);
    emit(saved);
  }

  Future<void> delete(Contact contact, {required bool offline}) async {
    await repo.delete(contact, offline: offline);
    emit(null);
  }
}
