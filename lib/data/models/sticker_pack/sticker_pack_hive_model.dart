import 'package:dc_universal_emot/data/models/sticker/sticker_hive_model.dart';
import 'package:dc_universal_emot/domain/entities/sticker_pack.dart';
import 'package:hive/hive.dart';

part 'sticker_pack_hive_model.g.dart';

@HiveType(typeId: 3)
class StickerPackHiveModel extends HiveObject implements StickerPack {
  @override
  @HiveField(0)
  String id;

  @override
  @HiveField(1)
  String name;

  @override
  @HiveField(2)
  String stickerPath;

  @override
  @HiveField(3)
  final List<StickerHiveModel> stickers;

  StickerPackHiveModel(
      {required this.id, required this.name, required this.stickerPath, required this.stickers});

  factory StickerPackHiveModel.fromStickerPack(StickerPack stickerPack) {
    return StickerPackHiveModel(
      id: stickerPack.id,
      name: stickerPack.name,
      stickerPath: stickerPack.stickerPath,
      stickers:
          stickerPack.stickers.map((sticker) => StickerHiveModel.fromSticker(sticker)).toList(),
    );
  }
}
