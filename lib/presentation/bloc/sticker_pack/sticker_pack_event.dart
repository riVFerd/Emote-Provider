part of 'sticker_pack_bloc.dart';

sealed class StickerPackEvent extends Equatable {
  const StickerPackEvent();
}

final class LoadStickerPacks extends StickerPackEvent {
  const LoadStickerPacks();

  @override
  List<Object?> get props => [];
}

final class AddStickerPack extends StickerPackEvent {
  final StickerPack stickerPack;

  const AddStickerPack(this.stickerPack);

  @override
  List<Object?> get props => [stickerPack];
}

final class DeleteAllStickerPack extends StickerPackEvent {
  const DeleteAllStickerPack();

  @override
  List<Object?> get props => [];
}

final class DeleteStickerPack extends StickerPackEvent {
  final StickerPack stickerPack;

  const DeleteStickerPack(this.stickerPack);

  @override
  List<Object?> get props => [stickerPack];
}
