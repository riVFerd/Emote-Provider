import 'package:bloc/bloc.dart';
import 'package:dc_universal_emot/data/models/emoji/emoji_hive_model.dart';
import 'package:dc_universal_emot/domain/repositories/emoji_pack_repository.dart';
import 'package:dc_universal_emot/injections/injection.dart';
import 'package:dc_universal_emot/services/file_service.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/emoji_pack.dart';

part 'emoji_pack_event.dart';
part 'emoji_pack_state.dart';

@LazySingleton()
class EmojiPackBloc extends Bloc<EmojiPackEvent, EmojiPackState> {
  final EmojiPackRepository emojiPackRepository;
  final FileService fileServices = getIt<FileService>();

  EmojiPackBloc({required this.emojiPackRepository})
      : super(const EmojiPackInitial(emojiPacks: [])) {
    on<LoadEmojiPacks>((event, emit) async {
      emit(EmojiPackLoading(emojiPacks: state.emojiPacks, progress: 0.5));
      final emojiPacks = await emojiPackRepository.getAllEmojiPack();
      emit(EmojiPackLoaded(emojiPacks: emojiPacks));
    });

    on<AddEmojiPack>((event, emit) async {
      double progress = 0.0;
      emit(EmojiPackLoading(emojiPacks: state.emojiPacks, progress: progress));

      final newEmojiPack = event.emojiPack;
      newEmojiPack.emojiPath = await fileServices.saveImage(newEmojiPack.emojiPath);
      for (int index = 0; index < newEmojiPack.emojis.length; index++) {
        final emoji = newEmojiPack.emojis[index];
        newEmojiPack.emojis[index].emojiPath = await fileServices.saveImage(emoji.emojiPath);
        progress = (index + 1) / newEmojiPack.emojis.length;
        emit(EmojiPackLoading(emojiPacks: state.emojiPacks, progress: progress));
      }
      await emojiPackRepository.addEmojiPack(newEmojiPack);
      add(const LoadEmojiPacks());
    });

    on<DeleteAllEmojiPack>((event, emit) async {
      await emojiPackRepository.deleteAllEmojiPack();
      add(const LoadEmojiPacks());
    });

    on<DeleteEmojiPack>((event, emit) async {
      await emojiPackRepository.deleteEmojiPack(event.emojiPack);
      add(const LoadEmojiPacks());
    });

    on<SearchEmojis>((event, emit) async {
      if (event.emojiName.isEmpty) {
        add(const LoadEmojiPacks());
        return;
      }
      final emojiPacks = await emojiPackRepository.getEmojiByName(event.emojiName);
      emit(EmojiPackLoaded(emojiPacks: [emojiPacks], isSearching: true));
    });

    on<UpdateEmojiPack>((event, emit) async {
      emit(EmojiPackLoading(emojiPacks: state.emojiPacks, progress: 0.0));

      final oldEmojiPack = await emojiPackRepository.getEmojiPackById(event.emojiPack.id);
      final newEmojiPack = event.emojiPack;

      // Update emoji pack name and image
      oldEmojiPack.name = newEmojiPack.name;
      if (oldEmojiPack.emojiPath != newEmojiPack.emojiPath) {
        fileServices.deleteImage(oldEmojiPack.emojiPath);
        oldEmojiPack.emojiPath = await fileServices.saveImage(newEmojiPack.emojiPath);
      }

      // Delete old emojis that are not in the new emoji pack
      for (int i = oldEmojiPack.emojis.length - 1; i >= 0; i--) {
        final oldEmoji = oldEmojiPack.emojis[i];
        bool isSameEmoji = newEmojiPack.emojis.any((emoji) {
          return emoji.emojiPath == oldEmoji.emojiPath;
        });
        if (!isSameEmoji) {
          fileServices.deleteImage(oldEmoji.emojiPath);
          oldEmojiPack.emojis.removeAt(i);
        }
        emit(EmojiPackLoading(
          emojiPacks: state.emojiPacks,
          progress: 0.5,
          message: 'Deleting old emojis...',
        ));
      }

      // Add new emojis that are not in the old emoji pack
      for (int i = 0; i < newEmojiPack.emojis.length; i++) {
        final newEmoji = newEmojiPack.emojis[i];
        final isSameEmoji = oldEmojiPack.emojis.any(
          (emoji) => emoji.emojiPath == newEmoji.emojiPath,
        );
        if (!isSameEmoji) {
          newEmoji.emojiPath = await fileServices.saveImage(newEmoji.emojiPath);
          oldEmojiPack.emojis.add(EmojiHiveModel.fromEmoji(newEmoji));
        }
        emit(EmojiPackLoading(
          emojiPacks: state.emojiPacks,
          progress: (i + 1) / newEmojiPack.emojis.length,
          message: 'Adding new emojis...',
        ));
      }

      await emojiPackRepository.updateEmojiPack(oldEmojiPack);
      add(const LoadEmojiPacks());
    });
  }
}
