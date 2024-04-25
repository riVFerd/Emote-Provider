// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_pack_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StickerPackHiveModelAdapter extends TypeAdapter<StickerPackHiveModel> {
  @override
  final int typeId = 3;

  @override
  StickerPackHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StickerPackHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      stickerPath: fields[2] as String,
      stickers: (fields[3] as List).cast<StickerHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, StickerPackHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.stickerPath)
      ..writeByte(3)
      ..write(obj.stickers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickerPackHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
