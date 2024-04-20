import 'dart:io';

import 'package:flutter/services.dart';
import 'package:keypress_simulator/keypress_simulator.dart';
import 'package:super_clipboard/super_clipboard.dart';

class ClipboardService {
  static Future<void> writeImage(String path) async {
    final item = DataWriterItem();
    item.add(Formats.png(File(path).readAsBytesSync()));
    await ClipboardWriter.instance.write([item]);
  }

  static Future<void> simulatePaste() async {
    keyPressSimulator.simulateKeyDown(
      PhysicalKeyboardKey.keyV,
      [ModifierKey.controlModifier],
    );
    keyPressSimulator.simulateKeyUp(
      PhysicalKeyboardKey.keyV,
      [ModifierKey.controlModifier],
    );
  }
}
