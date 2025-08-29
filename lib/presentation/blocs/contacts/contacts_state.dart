// lib/presentation/blocs/contacts/contacts_state.dart
part of 'contacts_bloc.dart';

abstract class ContactsState extends Equatable {
  @override
  List<Object?> get props => [];
}
class ContactsLoading extends ContactsState {}
class ContactsError extends ContactsState { final bool hasCache; ContactsError({required this.hasCache}); }
class ContactsEmpty extends ContactsState {}
class ContactsContent extends ContactsState {
  final List<Contact> list;
  ContactsContent(this.list);
  @override
  List<Object?> get props => [list];
}
