// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmojiHiveModelAdapter extends TypeAdapter<EmojiHiveModel> {
  @override
  final int typeId = 0;

  @override
  EmojiHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmojiHiveModel(
      name: fields[0] as String,
      emojiPath: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EmojiHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.emojiPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmojiHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
