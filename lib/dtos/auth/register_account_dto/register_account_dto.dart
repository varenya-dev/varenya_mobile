import 'package:json_annotation/json_annotation.dart';

part 'register_account_dto.g.dart';

@JsonSerializable()
class RegisterAccountDto {
  final String fullName;

  @JsonKey(defaultValue: "")
  final String? imageUrl;

  final String emailAddress;
  final String password;

  RegisterAccountDto({
    required this.fullName,
    this.imageUrl,
    required this.emailAddress,
    required this.password,
  });

  factory RegisterAccountDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterAccountDtoToJson(this);
}
