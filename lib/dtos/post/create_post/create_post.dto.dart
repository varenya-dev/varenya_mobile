import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_mobile/models/post/post_category/post_category.model.dart';

part 'create_post.dto.g.dart';

@JsonSerializable()
class CreatePostDto {
  final String body;
  final List<String> images;
  final List<PostCategory> categories;

  const CreatePostDto({
    required this.body,
    required this.images,
    required this.categories,
  });

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostDtoToJson(this);
}
