// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_plant_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlyPlantHistoryAdapter
    extends TypeAdapter<MonthlyPlantHistory> {
  @override
  final int typeId = 2;

  @override
  MonthlyPlantHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };
    return MonthlyPlantHistory(
      year: fields[0] as int,
      month: fields[1] as int,
      maxLevel: fields[2] as int,
      totalExp: fields[3] as int,
      createdAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MonthlyPlantHistory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.maxLevel)
      ..writeByte(3)
      ..write(obj.totalExp)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyPlantHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
