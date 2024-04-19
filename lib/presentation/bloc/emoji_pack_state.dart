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
  const EmojiPackLoading({required super.emojiPacks});
}

final class EmojiPackLoaded extends EmojiPackState {
  const EmojiPackLoaded({required super.emojiPacks});
}
