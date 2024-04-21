import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class StickerPackProvider with ChangeNotifier {
  int _selectedStickerPackIndex = 0;
  final scrollController = AutoScrollController();

  int get selectedStickerPackIndex => _selectedStickerPackIndex;

  void setSelectedStickerPackIndex(int index) {
    _selectedStickerPackIndex = index;
    scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    notifyListeners();
  }
}
