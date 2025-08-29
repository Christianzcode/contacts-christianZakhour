import '../../data/repository/contacts_repository_impl.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../network/connectivity_service.dart';

class Injector {
  Injector._();
  static final Injector instance = Injector._();

  late final ContactsRepository repo;
  late final ConnectivityService connectivity;

  static Future<void> initDependencies() async {
    instance.connectivity = ConnectivityService();
    instance.repo = ContactsRepositoryImpl(
      connectivity: instance.connectivity,
    );
  }
}
