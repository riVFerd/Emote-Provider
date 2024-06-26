import 'package:dc_universal_emot/data/models/sticker/sticker_hive_model.dart';
import 'package:dc_universal_emot/data/models/sticker_pack/sticker_pack_hive_model.dart';
import 'package:dc_universal_emot/domain/entities/sticker_pack.dart';
import 'package:dc_universal_emot/domain/repositories/sticker_pack_repository.dart';
import 'package:dc_universal_emot/services/file_service.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../constants/constant.dart';

@Singleton(as: StickerPackRepository)
class StickerPackHiveRepository implements StickerPackRepository {
  static late Box<StickerPackHiveModel> _stickerPackBox;

  /// Initialize this repository Hive box
  /// Optional [onInitialized] callback function added to be called after the box is initialized
  static Future<void> init({void Function()? onInitialized}) async {
    if (!Hive.isBoxOpen(STICKERPACK_BOX_KEY)) {
      Hive.registerAdapter(StickerHiveModelAdapter());
      Hive.registerAdapter(StickerPackHiveModelAdapter());
      _stickerPackBox = await Hive.openBox<StickerPackHiveModel>(STICKERPACK_BOX_KEY, path: './');
      onInitialized?.call();
    }
  }

  @override
  Future<List<StickerPack>> getAllStickerPack() async {
    if (_stickerPackBox.isNotEmpty) {
      return _stickerPackBox.values.toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> addStickerPack(StickerPack stickerPack) async {
    await _stickerPackBox.add(StickerPackHiveModel.fromStickerPack(stickerPack));
  }

  @override
  Future<void> deleteAllStickerPack() {
    final fileService = FileService();
    _stickerPackBox.values.toList().forEach((stickerPack) {
      fileService.deleteImage(stickerPack.stickerPath);
      for (var sticker in stickerPack.stickers) {
        fileService.deleteImage(sticker.stickerPath);
      }
    });
    return _stickerPackBox.clear();
  }

  @override
  Future<void> deleteStickerPack(StickerPack stickerPack) {
    final keyToDelete =
        _stickerPackBox.keys.firstWhere((key) => _stickerPackBox.get(key) == stickerPack);
    final stickerPackToDelete = _stickerPackBox.get(keyToDelete);
    final fileService = FileService();
    fileService.deleteImage(stickerPackToDelete!.stickerPath);
    for (var sticker in stickerPackToDelete.stickers) {
      fileService.deleteImage(sticker.stickerPath);
    }
    return _stickerPackBox.delete(keyToDelete);
  }

  @override
  Future<StickerPack> getStickersByName(String stickerName) async {
    final searchedStickers = _stickerPackBox.values
        .toList()
        .map((stickerPack) {
          return stickerPack.stickers;
        })
        .expand((sticker) => sticker)
        .toList()
        .where(
          (sticker) {
            return sticker.name.toLowerCase().contains(stickerName.toLowerCase());
          },
        );
    return StickerPack(
      id: '',
      name: 'Search Result',
      stickerPath: '',
      stickers: searchedStickers.toList(),
    );
  }

  @override
  Future<StickerPack> getStickerPackById(String id) async {
    final stickerPack = _stickerPackBox.values.firstWhere((stickerPack) => stickerPack.id == id);
    return stickerPack;
  }

  @override
  Future<void> updateStickerPack(StickerPack stickerPack) async {
    final keyToUpdate = _stickerPackBox.keys.firstWhere((key) {
      return (_stickerPackBox.get(key)?.id ?? 'no-id') == stickerPack.id;
    });
    await _stickerPackBox.put(keyToUpdate, StickerPackHiveModel.fromStickerPack(stickerPack));
  }
}
