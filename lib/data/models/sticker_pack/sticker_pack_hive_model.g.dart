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
      name: fields[0] as String,
      stickerPath: fields[1] as String,
      stickers: (fields[2] as List).cast<StickerHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, StickerPackHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.stickerPath)
      ..writeByte(2)
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
