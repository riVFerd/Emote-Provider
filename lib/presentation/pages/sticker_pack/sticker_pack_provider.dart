import 'package:context_menus/context_menus.dart';
import 'package:dc_universal_emot/injections/injection.dart';
import 'package:dc_universal_emot/services/clipboard_service.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:window_manager/window_manager.dart';

class StickerPackProvider with ChangeNotifier {
  int _selectedStickerPackIndex = 0;
  final scrollController = AutoScrollController();
  final clipboardService = getIt<ClipboardService>();

  int get selectedStickerPackIndex => _selectedStickerPackIndex;

  void setSelectedStickerPackIndex(int index) {
    _selectedStickerPackIndex = index;
    scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    notifyListeners();
  }

  Future<void> pasteSticker(String stickerPath, {BuildContext? context}) async {
    await clipboardService.writeImage(stickerPath);
    await windowManager.hide();
    if (context != null) {
      if (context.mounted) context.contextMenuOverlay.hide();
    }
    await clipboardService.simulatePaste();
  }
}
