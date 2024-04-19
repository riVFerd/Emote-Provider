import '../entities/emoji_pack.dart';

abstract class EmojiPackRepository {
  Future<List<EmojiPack>> getAllEmojiPack();
  Future<void> addEmojiPack(EmojiPack emojiPack);
  Future<void> deleteAllEmojiPack();
}
