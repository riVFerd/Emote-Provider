import 'package:flutter/material.dart';

extension WidgetExtention on List<Widget> {
  List<Widget> addSeparator({required Widget separator}) {
    return List<Widget>.generate(length * 2 - 1, (int index) {
      if (index.isEven) {
        return this[index ~/ 2];
      } else {
        return separator;
      }
    });
  }
}
