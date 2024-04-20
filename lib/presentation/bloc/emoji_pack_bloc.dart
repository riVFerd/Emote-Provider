import 'package:bloc/bloc.dart';
import 'package:dc_universal_emot/domain/repositories/emoji_pack_repository.dart';
import 'package:dc_universal_emot/services/file_services.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/emoji_pack.dart';

part 'emoji_pack_event.dart';
part 'emoji_pack_state.dart';

class EmojiPackBloc extends Bloc<EmojiPackEvent, EmojiPackState> {
  final EmojiPackRepository emojiPackRepository;
  final FileServices fileServices = FileServices();

  EmojiPackBloc({required this.emojiPackRepository})
      : super(const EmojiPackInitial(emojiPacks: [])) {
    on<LoadEmojiPacks>((event, emit) async {
      emit(EmojiPackLoading(emojiPacks: state.emojiPacks));
      final emojiPacks = await emojiPackRepository.getAllEmojiPack();
      emit(EmojiPackLoaded(emojiPacks: emojiPacks));
    });

    on<AddEmojiPack>((event, emit) async {
      final newEmojiPack = event.emojiPack;
      newEmojiPack.emojiPath = await fileServices.saveImage(
        newEmojiPack.emojiPath,
        prefixName: 'pack_logo',
      );

      for (int index = 0; index < newEmojiPack.emojis.length; index++) {
        final emoji = newEmojiPack.emojis[index];
        newEmojiPack.emojis[index].emojiPath = await fileServices.saveImage(emoji.emojiPath);
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
