import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:keypress_simulator/keypress_simulator.dart';
import 'package:super_clipboard/super_clipboard.dart';

@singleton
class ClipboardService {
  final clipboardWriter = ClipboardWriter.instance;

  Future<void> writeImage(String path) async {
    final item = DataWriterItem();
    item.add(Formats.png(File(path).readAsBytesSync()));
    await clipboardWriter.write([item]);
  }

  Future<void> simulatePaste() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await keyPressSimulator.simulateKeyDown(
      PhysicalKeyboardKey.keyV,
      [ModifierKey.controlModifier],
    );
    await Future.delayed(const Duration(milliseconds: 1000));
    await keyPressSimulator.simulateKeyUp(
      PhysicalKeyboardKey.keyV,
      [ModifierKey.controlModifier],
    );
  }
}
