part of 'emoji_pack_bloc.dart';

sealed class EmojiPackEvent extends Equatable {
  const EmojiPackEvent();
}

final class LoadEmojiPacks extends EmojiPackEvent {
  const LoadEmojiPacks();

  @override
  List<Object?> get props => [];
}

final class AddEmojiPack extends EmojiPackEvent {
  final EmojiPack emojiPack;

  const AddEmojiPack(this.emojiPack);

  @override
  List<Object?> get props => [emojiPack];
}

final class DeleteAllEmojiPack extends EmojiPackEvent {
  const DeleteAllEmojiPack();

  @override
  List<Object?> get props => [];
}

final class DeleteEmojiPack extends EmojiPackEvent {
  final EmojiPack emojiPack;

  const DeleteEmojiPack(this.emojiPack);

  @override
  List<Object?> get props => [emojiPack];
}

final class SearchEmojis extends EmojiPackEvent {
  final String emojiName;

  const SearchEmojis(this.emojiName);

  @override
  List<Object?> get props => [emojiName];
}

final class UpdateEmojiPack extends EmojiPackEvent {
  final EmojiPack emojiPack;

  const UpdateEmojiPack(this.emojiPack);

  @override
  List<Object?> get props => [emojiPack];
}
