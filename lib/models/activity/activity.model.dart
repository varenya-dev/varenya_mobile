import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_mobile/models/appointments/appointment/appointment.model.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';

part 'activity.model.g.dart';

@JsonSerializable()
@HiveType(typeId: 11)
class Activity {
  @HiveField(0, defaultValue: '')
  @JsonKey(defaultValue: '')
  final String id;

  @HiveField(1, defaultValue: '')
  @JsonKey(defaultValue: '')
  final String activityType;

  @HiveField(2)
  final ServerUser user;

  @HiveField(3, defaultValue: null)
  @JsonKey(defaultValue: null)
  final Post? post;

  @HiveField(4, defaultValue: null)
  @JsonKey(defaultValue: null)
  final Appointment? appointment;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  Activity({
    required this.id,
    required this.activityType,
    required this.user,
    required this.post,
    required this.appointment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
