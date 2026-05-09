// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogAdapter extends TypeAdapter<Log> {
  @override
  final int typeId = 0;

  @override
  Log read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Log(
      date: fields[0] as DateTime,
      practiceMinutes: fields[1] as int,
      memo: fields[2] as String,
      tags: (fields[3] as List).cast<String>(),
      videoUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Log obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.practiceMinutes)
      ..writeByte(2)
      ..write(obj.memo)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.videoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
