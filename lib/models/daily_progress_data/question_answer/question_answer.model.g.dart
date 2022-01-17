// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_answer.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionAnswerAdapter extends TypeAdapter<QuestionAnswer> {
  @override
  final int typeId = 12;

  @override
  QuestionAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionAnswer(
      question: fields[0] == null ? '' : fields[0] as String,
      answer: fields[1] == null ? '' : fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionAnswer obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
