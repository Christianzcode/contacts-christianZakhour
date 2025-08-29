// lib/presentation/blocs/contacts/contacts_event.dart
part of 'contacts_bloc.dart';

abstract class ContactsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactsStarted extends ContactsEvent {}
class ContactsRefresh extends ContactsEvent {}
class ContactsSearch extends ContactsEvent {
  final String query;
  ContactsSearch(this.query);
  @override
  List<Object?> get props => [query];
}
