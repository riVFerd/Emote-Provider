import 'package:bloc/bloc.dart';
import 'package:dc_universal_emot/data/models/emoji/emoji_hive_model.dart';
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
      final pickedImages = await fileServices.pickImages();
      if (pickedImages == null) return;
      if (pickedImages.isEmpty) return;
      final emojiPack = EmojiPack(
        name: 'New Pack',
        emojis: pickedImages
            .map(
              (file) => EmojiHiveModel(
                name: file.path.split('/').last,
                emojiPath: file.absolute.path,
              ),
            )
            .toList(),
      );
      await emojiPackRepository.addEmojiPack(emojiPack);
      add(const LoadEmojiPacks());
    });

    on<DeleteAllEmojiPack>((event, emit) async {
      await emojiPackRepository.deleteAllEmojiPack();
      add(const LoadEmojiPacks());
    });
  }
}
