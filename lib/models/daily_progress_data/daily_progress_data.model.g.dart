// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_progress_data.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyProgressDataAdapter extends TypeAdapter<DailyProgressData> {
  @override
  final int typeId = 13;

  @override
  DailyProgressData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyProgressData(
      answers:
          fields[0] == null ? [] : (fields[0] as List).cast<QuestionAnswer>(),
      moodRating: fields[1] == null ? 0 : fields[1] as int,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyProgressData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.answers)
      ..writeByte(1)
      ..write(obj.moodRating)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyProgressDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
