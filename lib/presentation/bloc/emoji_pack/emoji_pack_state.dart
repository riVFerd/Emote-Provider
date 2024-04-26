part of 'emoji_pack_bloc.dart';

sealed class EmojiPackState extends Equatable {
  final List<EmojiPack> emojiPacks;
  const EmojiPackState({required this.emojiPacks});

  @override
  List<Object> get props => [emojiPacks];
}

final class EmojiPackInitial extends EmojiPackState {
  const EmojiPackInitial({required super.emojiPacks});
}

final class EmojiPackLoading extends EmojiPackState {
  final double progress;
  const EmojiPackLoading({required super.emojiPacks, required this.progress});

  @override
  List<Object> get props => [emojiPacks, progress];
}

final class EmojiPackLoaded extends EmojiPackState {
  final bool isSearching;

  const EmojiPackLoaded({required super.emojiPacks, this.isSearching = false});

  @override
  List<Object> get props => [emojiPacks, isSearching];
}
