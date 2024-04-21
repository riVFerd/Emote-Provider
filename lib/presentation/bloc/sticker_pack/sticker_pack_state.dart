part of 'sticker_pack_bloc.dart';

sealed class StickerPackState extends Equatable {
  final List<StickerPack> stickerPacks;
  const StickerPackState({required this.stickerPacks});

  @override
  List<Object> get props => [stickerPacks];
}

final class StickerPackInitial extends StickerPackState {
  const StickerPackInitial({required super.stickerPacks});
}

final class StickerPackLoading extends StickerPackState {
  final double progress;
  const StickerPackLoading({required super.stickerPacks, required this.progress});

  @override
  List<Object> get props => [stickerPacks, progress];
}

final class StickerPackLoaded extends StickerPackState {
  const StickerPackLoaded({required super.stickerPacks});
}
