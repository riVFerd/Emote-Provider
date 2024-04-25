import 'emoji.dart';

class EmojiPack {
  String id;
  String name;
  String emojiPath;
  final List<Emoji> emojis;

  EmojiPack({required this.id, required this.name, required this.emojiPath, required this.emojis});
}
