import 'sticker.dart';

class StickerPack {
  String id;
  String name;
  String stickerPath;
  final List<Sticker> stickers;

  StickerPack(
      {required this.id, required this.name, required this.stickerPath, required this.stickers});
}
