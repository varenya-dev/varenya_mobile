import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_mobile/enum/post_type.enum.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';
import 'package:varenya_mobile/models/post/post_image/post_image.model.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';

part 'post.model.g.dart';

@HiveType(typeId: 9)
@JsonSerializable()
class Post {
  @HiveField(0, defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  @HiveField(9, defaultValue: '')
  final String title;

  @HiveField(1, defaultValue: PostType.Post)
  final PostType postType;

  @HiveField(2, defaultValue: '')
  final String body;

  @HiveField(3, defaultValue: [])
  @JsonKey(defaultValue: const [])
  final List<PostImage> images;

  @HiveField(4)
  final ServerUser user;

  @HiveField(5, defaultValue: [])
  @JsonKey(defaultValue: const [])
  final List<Post> comments;

  @HiveField(6, defaultValue: [])
  @JsonKey(defaultValue: const [])
  final List<PostCategory> categories;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.postType,
    required this.body,
    required this.images,
    required this.user,
    required this.comments,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
