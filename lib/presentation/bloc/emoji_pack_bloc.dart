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
      await emojiPackRepository.addEmojiPack(event.emojiPack);
      add(const LoadEmojiPacks());
    });

    on<DeleteAllEmojiPack>((event, emit) async {
      await emojiPackRepository.deleteAllEmojiPack();
      add(const LoadEmojiPacks());
    });
  }
}
