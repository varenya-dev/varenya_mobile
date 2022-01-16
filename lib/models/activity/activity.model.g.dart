// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 11;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      id: fields[0] == null ? '' : fields[0] as String,
      activityType: fields[1] == null ? '' : fields[1] as String,
      user: fields[2] as ServerUser,
      post: fields[3] as Post?,
      appointment: fields[4] as Appointment?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.activityType)
      ..writeByte(2)
      ..write(obj.user)
      ..writeByte(3)
      ..write(obj.post)
      ..writeByte(4)
      ..write(obj.appointment)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as String? ?? '',
      activityType: json['activityType'] as String? ?? '',
      user: ServerUser.fromJson(json['user'] as Map<String, dynamic>),
      post: json['post'] == null
          ? null
          : Post.fromJson(json['post'] as Map<String, dynamic>),
      appointment: json['appointment'] == null
          ? null
          : Appointment.fromJson(json['appointment'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'activityType': instance.activityType,
      'user': instance.user,
      'post': instance.post,
      'appointment': instance.appointment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
