// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_challenge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeeklyChallengeAdapter extends TypeAdapter<WeeklyChallenge> {
  @override
  final int typeId = 4;

  @override
  WeeklyChallenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklyChallenge(
      id: fields[0] as String?,
      title: fields[1] as String,
      targetMinutes: fields[2] as int,
      startDate: fields[4] as DateTime,
      achievedMinutes: fields[3] as int,
      isCompleted: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WeeklyChallenge obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.targetMinutes)
      ..writeByte(3)
      ..write(obj.achievedMinutes)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
