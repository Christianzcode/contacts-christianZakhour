import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injector.initDependencies(); // 👈 init DI first
  runApp(const ContactsApp());
}
