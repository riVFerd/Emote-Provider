import 'package:dc_universal_emot/domain/entities/sticker.dart';
import 'package:hive/hive.dart';

part 'sticker_hive_model.g.dart';

@HiveType(typeId: 2)
class StickerHiveModel extends HiveObject implements Sticker {
  @override
  @HiveField(0)
  String name;

  @override
  @HiveField(1)
  String stickerPath;

  @override
  @HiveField(2)
  String originalPath;

  StickerHiveModel({required this.name, required this.stickerPath, required this.originalPath});

  factory StickerHiveModel.fromSticker(Sticker sticker) {
    return StickerHiveModel(
      name: sticker.name,
      stickerPath: sticker.stickerPath,
      originalPath: sticker.originalPath,
    );
  }
}
