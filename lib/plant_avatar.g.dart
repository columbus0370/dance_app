// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_avatar.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantAvatarAdapter extends TypeAdapter<PlantAvatar> {
  @override
  final int typeId = 1;

  @override
  PlantAvatar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantAvatar(
      exp: fields[0] as int? ?? 0,
      level: fields[1] as int? ?? 0,
      createdAt: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PlantAvatar obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.currentExp)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantAvatarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
