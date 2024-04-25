import 'package:dc_universal_emot/domain/entities/sticker.dart';
import 'package:hive/hive.dart';

part 'sticker_hive_model.g.dart';

@HiveType(typeId: 2)
class StickerHiveModel extends HiveObject implements Sticker {
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
  String originalPath;

  StickerHiveModel(
      {required this.id,
      required this.name,
      required this.stickerPath,
      required this.originalPath});

  factory StickerHiveModel.fromSticker(Sticker sticker) {
    return StickerHiveModel(
      id: sticker.id,
      name: sticker.name,
      stickerPath: sticker.stickerPath,
      originalPath: sticker.originalPath,
    );
  }
}
