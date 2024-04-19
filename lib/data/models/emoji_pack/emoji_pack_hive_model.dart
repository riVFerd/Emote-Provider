import 'package:dc_universal_emot/data/models/emoji/emoji_hive_model.dart';
import 'package:dc_universal_emot/domain/entities/emoji_pack.dart';
import 'package:hive/hive.dart';

part 'emoji_pack_hive_model.g.dart';

@HiveType(typeId: 1)
class EmojiPackHiveModel extends HiveObject implements EmojiPack {
  @override
  @HiveField(0)
  String name;

  @override
  @HiveField(1)
  String emojiPath;

  @override
  @HiveField(2)
  final List<EmojiHiveModel> emojis;

  EmojiPackHiveModel({required this.name, required this.emojiPath, required this.emojis});

  factory EmojiPackHiveModel.fromEmojiPack(EmojiPack emojiPack) {
    return EmojiPackHiveModel(
      name: emojiPack.name,
      emojiPath: emojiPack.emojiPath,
      emojis: emojiPack.emojis.map((emoji) => EmojiHiveModel.fromEmoji(emoji)).toList(),
    );
  }
}
