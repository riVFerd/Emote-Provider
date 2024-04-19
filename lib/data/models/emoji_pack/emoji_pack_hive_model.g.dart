// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_pack_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmojiPackHiveModelAdapter extends TypeAdapter<EmojiPackHiveModel> {
  @override
  final int typeId = 1;

  @override
  EmojiPackHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmojiPackHiveModel(
      name: fields[0] as String,
      emojiPath: fields[1] as String,
      emojis: (fields[2] as List).cast<EmojiHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, EmojiPackHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.emojiPath)
      ..writeByte(2)
      ..write(obj.emojis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmojiPackHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
