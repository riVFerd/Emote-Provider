import 'package:bloc/bloc.dart';
import 'package:dc_universal_emot/data/models/sticker/sticker_hive_model.dart';
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

    on<DeleteStickerPack>((event, emit) async {
      await stickerPackRepository.deleteStickerPack(event.stickerPack);
      add(const LoadStickerPacks());
    });

    on<SearchStickers>((event, emit) async {
      if (event.stickerName.isEmpty) {
        add(const LoadStickerPacks());
        return;
      }
      final stickerPack = await stickerPackRepository.getStickersByName(event.stickerName);
      emit(StickerPackLoaded(stickerPacks: [stickerPack], isSearching: true));
    });

    on<UpdateStickerPack>((event, emit) async {
      emit(StickerPackLoading(stickerPacks: state.stickerPacks, progress: 0.0));

      final oldStickerPack = await stickerPackRepository.getStickerPackById(event.stickerPack.id);
      final newStickerPack = event.stickerPack;

      // Update sticker pack name and image
      oldStickerPack.name = newStickerPack.name;
      if (oldStickerPack.stickerPath != newStickerPack.stickerPath) {
        fileServices.deleteImage(oldStickerPack.stickerPath);
        oldStickerPack.stickerPath = await fileServices.saveImage(newStickerPack.stickerPath);
      }

      // Delete old stickers that are not in the new sticker pack
      for (int i = oldStickerPack.stickers.length - 1; i >= 0; i--) {
        final oldSticker = oldStickerPack.stickers[i];
        bool isSameSticker = newStickerPack.stickers.any(
          (sticker) => sticker.stickerPath == oldSticker.stickerPath,
        );
        if (!isSameSticker) {
          fileServices.deleteImage(oldSticker.stickerPath);
          oldStickerPack.stickers.removeAt(i);
        }
        emit(StickerPackLoading(
          stickerPacks: state.stickerPacks,
          progress: 0.5,
          message: 'Deleting old stickers...',
        ));
      }

      // Add new stickers that are not in the old sticker pack
      for (int i = 0; i < newStickerPack.stickers.length; i++) {
        final newSticker = newStickerPack.stickers[i];
        final isSameSticker = oldStickerPack.stickers.any(
          (sticker) => sticker.stickerPath == newSticker.stickerPath,
        );
        if (!isSameSticker) {
          newSticker.stickerPath = await fileServices.saveImage(newSticker.stickerPath);
          oldStickerPack.stickers.add(StickerHiveModel.fromSticker(newSticker));
        }
        emit(StickerPackLoading(
          stickerPacks: state.stickerPacks,
          progress: (i + 1) / newStickerPack.stickers.length,
          message: 'Adding new stickers...',
        ));
      }

      await stickerPackRepository.updateStickerPack(event.stickerPack);
      add(const LoadStickerPacks());
    });
  }
}
