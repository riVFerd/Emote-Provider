import '../entities/emoji_pack.dart';

abstract class EmojiPackRepository {
  Future<List<EmojiPack>> getAllEmojiPack();
  Future<void> addEmojiPack(EmojiPack emojiPack);
  Future<void> deleteAllEmojiPack();
  Future<void> deleteEmojiPack(EmojiPack emojiPack);
  Future<EmojiPack> getEmojiByName(String emojiName);
  Future<void> updateEmojiPack(EmojiPack emojiPack);
  Future<EmojiPack> getEmojiPackById(String id);
}
