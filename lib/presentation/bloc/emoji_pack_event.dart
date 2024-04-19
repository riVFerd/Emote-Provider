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
  const AddEmojiPack();

  @override
  List<Object?> get props => [];
}

final class DeleteAllEmojiPack extends EmojiPackEvent {
  const DeleteAllEmojiPack();

  @override
  List<Object?> get props => [];
}
