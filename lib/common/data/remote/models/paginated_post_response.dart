import 'package:json_annotation/json_annotation.dart';

part 'paginated_post_response.g.dart';


@JsonSerializable(genericArgumentFactories: true)
class PostListRequest {
  @JsonKey(name: 'page')
  int? page;
  PostListRequest({
    this.page,
  });

  factory PostListRequest.fromJson(Map<String, dynamic> json) =>
      _$PostListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PostListRequestToJson(this);
}
