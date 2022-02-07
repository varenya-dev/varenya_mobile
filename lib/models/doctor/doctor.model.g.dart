// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorAdapter extends TypeAdapter<Doctor> {
  @override
  final int typeId = 5;

  @override
  Doctor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Doctor(
      id: fields[0] == null ? '' : fields[0] as String,
      imageUrl: fields[1] == null ? '' : fields[1] as String,
      fullName: fields[2] == null ? '' : fields[2] as String,
      clinicAddress: fields[3] == null ? '' : fields[3] as String,
      cost: fields[4] == null ? 0.0 : fields[4] as double,
      jobTitle: fields[5] == null ? '' : fields[5] as String,
      specializations:
          fields[6] == null ? [] : (fields[6] as List).cast<Specialization>(),
      shiftStartTime: fields[7] as DateTime,
      shiftEndTime: fields[8] as DateTime,
      user: fields[9] as ServerUser?,
    );
  }

  @override
  void write(BinaryWriter writer, Doctor obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.clinicAddress)
      ..writeByte(4)
      ..write(obj.cost)
      ..writeByte(5)
      ..write(obj.jobTitle)
      ..writeByte(6)
      ..write(obj.specializations)
      ..writeByte(7)
      ..write(obj.shiftStartTime)
      ..writeByte(8)
      ..write(obj.shiftEndTime)
      ..writeByte(9)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      clinicAddress: json['clinicAddress'] as String? ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      jobTitle: json['jobTitle'] as String? ?? '',
      specializations: (json['specializations'] as List<dynamic>?)
              ?.map((e) => Specialization.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      shiftStartTime: DateTime.parse(json['shiftStartTime'] as String),
      shiftEndTime: DateTime.parse(json['shiftEndTime'] as String),
      user: json['user'] == null
          ? null
          : ServerUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'fullName': instance.fullName,
      'clinicAddress': instance.clinicAddress,
      'cost': instance.cost,
      'jobTitle': instance.jobTitle,
      'specializations': instance.specializations,
      'shiftStartTime': instance.shiftStartTime.toIso8601String(),
      'shiftEndTime': instance.shiftEndTime.toIso8601String(),
      'user': instance.user,
    };
