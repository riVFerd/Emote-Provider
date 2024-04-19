import 'package:dc_universal_emot/domain/entities/emoji.dart';
import 'package:hive/hive.dart';

part 'emoji_hive_model.g.dart';

@HiveType(typeId: 0)
class EmojiHiveModel extends HiveObject implements Emoji {
  @override
  @HiveField(0)
  String name;

  @override
  @HiveField(1)
  String emojiPath;

  EmojiHiveModel({required this.name, required this.emojiPath});

  factory EmojiHiveModel.fromEmoji(Emoji emoji) {
    return EmojiHiveModel(
      name: emoji.name,
      emojiPath: emoji.emojiPath,
    );
  }
}
