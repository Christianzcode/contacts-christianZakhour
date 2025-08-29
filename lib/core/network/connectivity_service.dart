import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((_) async {
      _controller.add(await isOnline());
    });
  }

  Future<bool> isOnline() async {
    final res = await _connectivity.checkConnectivity();
    return !res.contains(ConnectivityResult.none);
  }

  Stream<bool> get onStatusChange => _controller.stream;
}