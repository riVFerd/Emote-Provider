import 'package:bloc/bloc.dart';
import 'package:dc_universal_emot/domain/repositories/sticker_pack_repository.dart';
import 'package:dc_universal_emot/services/file_service.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/sticker_pack.dart';

part 'sticker_pack_event.dart';
part 'sticker_pack_state.dart';

class StickerPackBloc extends Bloc<StickerPackEvent, StickerPackState> {
  final StickerPackRepository stickerPackRepository;
  final FileService fileServices = FileService();

  StickerPackBloc({required this.stickerPackRepository})
      : super(const StickerPackInitial(stickerPacks: [])) {
    on<LoadStickerPacks>((event, emit) async {
      emit(StickerPackLoading(stickerPacks: state.stickerPacks, progress: 0.5));
      final stickerPacks = await stickerPackRepository.getAllStickerPack();
      emit(StickerPackLoaded(stickerPacks: stickerPacks));
    });

    on<AddStickerPack>((event, emit) async {
      double progress = 0.0;
      emit(StickerPackLoading(stickerPacks: state.stickerPacks, progress: progress));

      final newStickerPack = event.stickerPack;
      newStickerPack.stickerPath = await fileServices.saveImage(newStickerPack.stickerPath);
      for (int index = 0; index < newStickerPack.stickers.length; index++) {
        final sticker = newStickerPack.stickers[index];
        newStickerPack.stickers[index].stickerPath =
            await fileServices.saveImage(sticker.stickerPath, savedImageHeight: 168);
        progress = (index + 1) / newStickerPack.stickers.length;
        emit(StickerPackLoading(stickerPacks: state.stickerPacks, progress: progress));
      }
      await stickerPackRepository.addStickerPack(newStickerPack);
      add(const LoadStickerPacks());
    });

    on<DeleteAllStickerPack>((event, emit) async {
      await stickerPackRepository.deleteAllStickerPack();
      add(const LoadStickerPacks());
    });
  }
}
