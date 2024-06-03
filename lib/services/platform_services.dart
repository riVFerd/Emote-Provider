import 'package:flutter/services.dart';

class PlatformServices {
  static const platform = MethodChannel('com.rivferd.dev/superClipboard');

  Future<void> simulatePaste() async {
    try {
      return print(await platform.invokeMethod('simulatePaste'));
    } catch (e) {
      rethrow;
    }
  }
}
