import 'package:dc_universal_emot/data/models/emoji/emoji_hive_model.dart';
import 'package:dc_universal_emot/data/models/emoji_pack/emoji_pack_hive_model.dart';
import 'package:dc_universal_emot/domain/entities/emoji_pack.dart';
import 'package:dc_universal_emot/domain/repositories/emoji_pack_repository.dart';
import 'package:dc_universal_emot/services/file_service.dart';
import 'package:hive/hive.dart';

import '../../constants/constant.dart';

class EmojiPackHiveRepository implements EmojiPackRepository {
  static late Box<EmojiPackHiveModel> _emojiPackBox;

  /// Initialize this repository Hive box
  /// Optional [onInitialized] callback function added to be called after the box is initialized
  static Future<void> init({void Function()? onInitialized}) async {
    if (!Hive.isBoxOpen(EMOJIPACK_BOX_KEY)) {
      Hive.registerAdapter(EmojiHiveModelAdapter());
      Hive.registerAdapter(EmojiPackHiveModelAdapter());
      _emojiPackBox = await Hive.openBox<EmojiPackHiveModel>(EMOJIPACK_BOX_KEY, path: './');
      onInitialized?.call();
    }
  }

  @override
  Future<List<EmojiPack>> getAllEmojiPack() async {
    if (_emojiPackBox.isNotEmpty) {
      return _emojiPackBox.values.toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> addEmojiPack(EmojiPack emojiPack) async {
    await _emojiPackBox.add(EmojiPackHiveModel.fromEmojiPack(emojiPack));
  }

  @override
  Future<void> deleteAllEmojiPack() {
    final fileService = FileService();
    _emojiPackBox.values.toList().forEach((emojiPack) {
      fileService.deleteImage(emojiPack.emojiPath);
      for (var emoji in emojiPack.emojis) {
        fileService.deleteImage(emoji.emojiPath);
      }
    });
    return _emojiPackBox.clear();
  }
}
