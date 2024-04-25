// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StickerHiveModelAdapter extends TypeAdapter<StickerHiveModel> {
  @override
  final int typeId = 2;

  @override
  StickerHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StickerHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      stickerPath: fields[2] as String,
      originalPath: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StickerHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.stickerPath)
      ..writeByte(3)
      ..write(obj.originalPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickerHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
