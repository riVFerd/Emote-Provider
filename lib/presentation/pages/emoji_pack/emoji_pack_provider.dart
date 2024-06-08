import 'package:dc_universal_emot/injections/injection.dart';
import 'package:dc_universal_emot/services/clipboard_service.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:window_manager/window_manager.dart';

class EmojiPackProvider with ChangeNotifier {
  int _selectedEmojiPackIndex = 0;
  final scrollController = AutoScrollController();
  final clipboardService = getIt<ClipboardService>();

  int get selectedEmojiPackIndex => _selectedEmojiPackIndex;

  void setSelectedEmojiPackIndex(int index) {
    _selectedEmojiPackIndex = index;
    scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    notifyListeners();
  }

  Future<void> pasteEmoji(String emojiPath) async {
    await clipboardService.writeImage(emojiPath);
    await windowManager.hide();
    await clipboardService.simulatePaste();
  }
}
