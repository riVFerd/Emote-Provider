import 'package:dc_universal_emot/app.dart';
import 'package:dc_universal_emot/injections/injection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // TODO: unpredicted behavior on build release after pasting the file to clipboard
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await hotKeyManager.unregisterAll();
  await Hive.initFlutter();
  configureDependencies();
  runApp(const App());
}
