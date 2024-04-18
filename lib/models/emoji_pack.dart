import 'package:hive/hive.dart';

import 'emoji.dart';

@HiveType(typeId: 1)
class EmojiPack extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<Emoji> emojis;

  EmojiPack({required this.name, required this.emojis});
}
