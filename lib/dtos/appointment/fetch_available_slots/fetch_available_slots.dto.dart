import 'package:json_annotation/json_annotation.dart';

part 'fetch_available_slots.dto.g.dart';

@JsonSerializable()
class FetchAvailableSlotsDto {
  final DateTime date;
  final String doctorId;

  FetchAvailableSlotsDto({
    required this.date,
    required this.doctorId,
  });

  factory FetchAvailableSlotsDto.fromJson(Map<String, dynamic> json) =>
      _$FetchAvailableSlotsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FetchAvailableSlotsDtoToJson(this);
}
