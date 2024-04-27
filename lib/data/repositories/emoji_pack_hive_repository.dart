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

  @override
  Future<void> deleteEmojiPack(EmojiPack emojiPack) {
    final keyToDelete = _emojiPackBox.keys.firstWhere((key) => _emojiPackBox.get(key) == emojiPack);
    final emojiPackToDelete = _emojiPackBox.get(keyToDelete);
    final fileService = FileService();
    fileService.deleteImage(emojiPackToDelete!.emojiPath);
    for (var emoji in emojiPackToDelete.emojis) {
      fileService.deleteImage(emoji.emojiPath);
    }
    return _emojiPackBox.delete(keyToDelete);
  }

  @override
  Future<EmojiPack> getEmojiByName(String emojiName) async {
    final searchedEmojis = _emojiPackBox.values
        .map(
          (emojiPack) => emojiPack.emojis.where(
            (emoji) => emoji.name.toLowerCase().contains(emojiName.toLowerCase()),
          ),
        )
        .expand((emoji) => emoji);
    return EmojiPack(
      id: '',
      name: 'Search Result',
      emojiPath: '',
      emojis: searchedEmojis.toList(),
    );
  }

  @override
  Future<void> updateEmojiPack(EmojiPack emojiPack) async {
    final keyToUpdate = _emojiPackBox.keys.firstWhere((key) {
      return (_emojiPackBox.get(key)?.id ?? 'no-id') == emojiPack.id;
    });
    final fileService = FileService();
    final oldEmojiPack = _emojiPackBox.get(keyToUpdate)!;
    oldEmojiPack.name = emojiPack.name;

    if (oldEmojiPack.emojiPath != emojiPack.emojiPath) {
      fileService.deleteImage(oldEmojiPack.emojiPath);
      oldEmojiPack.emojiPath = await fileService.saveImage(emojiPack.emojiPath);
    }

    // Delete old emojis that are not in the new emoji pack
    for (int i = 0; i < oldEmojiPack.emojis.length; i++) {
      final oldEmoji = oldEmojiPack.emojis[i];
      final isSameEmoji = emojiPack.emojis
          .firstWhere(
            (emoji) => emoji.emojiPath == oldEmoji.emojiPath,
            orElse: () => EmojiHiveModel(id: '', name: '', emojiPath: ''),
          )
          .id
          .isNotEmpty;
      if (!isSameEmoji) {
        fileService.deleteImage(oldEmoji.emojiPath);
        oldEmojiPack.emojis.removeAt(i);
      }
    }

    // Add new emojis that are not in the old emoji pack
    for (int i = 0; i < emojiPack.emojis.length; i++) {
      final newEmoji = emojiPack.emojis[i];
      final isSameEmoji = oldEmojiPack.emojis
          .firstWhere(
            (emoji) => emoji.emojiPath == newEmoji.emojiPath,
            orElse: () => EmojiHiveModel(id: '', name: '', emojiPath: ''),
          )
          .id
          .isNotEmpty;
      if (!isSameEmoji) {
        newEmoji.emojiPath = await fileService.saveImage(newEmoji.emojiPath);
        oldEmojiPack.emojis.add(EmojiHiveModel.fromEmoji(newEmoji));
      }
    }

    oldEmojiPack.save();
  }
}
