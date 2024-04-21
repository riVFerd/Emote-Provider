import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class EmojiPackProvider with ChangeNotifier {
  int _selectedEmojiPackIndex = 0;
  final scrollController = AutoScrollController();

  int get selectedEmojiPackIndex => _selectedEmojiPackIndex;

  void setSelectedEmojiPackIndex(int index) {
    _selectedEmojiPackIndex = index;
    scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    notifyListeners();
  }
}
