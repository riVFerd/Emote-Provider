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
      name: fields[0] as String,
      stickerPath: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StickerHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.stickerPath);
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
