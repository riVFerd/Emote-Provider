import '../entities/sticker_pack.dart';

abstract class StickerPackRepository {
  Future<List<StickerPack>> getAllStickerPack();
  Future<void> addStickerPack(StickerPack stickerPack);
  Future<void> deleteAllStickerPack();
  Future<void> deleteStickerPack(StickerPack stickerPack);
  Future<StickerPack> getStickersByName(String stickerName);
}
