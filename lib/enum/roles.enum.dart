import 'package:hive/hive.dart';

part 'roles.enum.g.dart';

@HiveType(typeId: 8)
enum Roles {
  @HiveField(0)
  MAIN,

  @HiveField(1)
  PROFESSIONAL,
}
