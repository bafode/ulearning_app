// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostListRequest _$PostListRequestFromJson(Map<String, dynamic> json) =>
    PostListRequest(
      page: (json['page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PostListRequestToJson(PostListRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
    };
