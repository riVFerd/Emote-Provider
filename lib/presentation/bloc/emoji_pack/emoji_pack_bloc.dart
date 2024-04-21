import 'package:bloc/bloc.dart';
import 'package:dc_universal_emot/domain/repositories/emoji_pack_repository.dart';
import 'package:dc_universal_emot/services/file_service.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/emoji_pack.dart';

part 'emoji_pack_event.dart';
part 'emoji_pack_state.dart';

class EmojiPackBloc extends Bloc<EmojiPackEvent, EmojiPackState> {
  final EmojiPackRepository emojiPackRepository;
  final FileService fileServices = FileService();

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
  }
}
