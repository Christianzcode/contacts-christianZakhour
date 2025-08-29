import 'package:contacts_app/presentation/blocs/contacts_form/contact_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injector.dart';
import 'domain/repositories/contacts_repository.dart';
import 'presentation/blocs/contacts/contacts_bloc.dart';
import 'presentation/blocs/history/history_cubit.dart';
import 'presentation/screens/contacts_list_screen.dart';

class ContactsApp extends StatelessWidget {
  const ContactsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactsRepository repo = Injector.instance.repo; // 👈 from DI
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ContactsBloc(repo)),
        BlocProvider(create: (_) => ContactFormCubit(repo)),
        BlocProvider(create: (_) => HistoryCubit(repo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ContactsListScreen(),
      ),
    );
  }
}
