// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_create_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostCreateResponse _$PostCreateResponseFromJson(Map<String, dynamic> json) {
  return _PostCreateResponse.fromJson(json);
}

/// @nodoc
mixin _$PostCreateResponse {
  int? get code => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  Post? get post => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostCreateResponseCopyWith<PostCreateResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCreateResponseCopyWith<$Res> {
  factory $PostCreateResponseCopyWith(
          PostCreateResponse value, $Res Function(PostCreateResponse) then) =
      _$PostCreateResponseCopyWithImpl<$Res, PostCreateResponse>;
  @useResult
  $Res call({int? code, String? message, Post? post});

  $PostCopyWith<$Res>? get post;
}

/// @nodoc
class _$PostCreateResponseCopyWithImpl<$Res, $Val extends PostCreateResponse>
    implements $PostCreateResponseCopyWith<$Res> {
  _$PostCreateResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? message = freezed,
    Object? post = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      post: freezed == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as Post?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PostCopyWith<$Res>? get post {
    if (_value.post == null) {
      return null;
    }

    return $PostCopyWith<$Res>(_value.post!, (value) {
      return _then(_value.copyWith(post: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostCreateResponseImplCopyWith<$Res>
    implements $PostCreateResponseCopyWith<$Res> {
  factory _$$PostCreateResponseImplCopyWith(_$PostCreateResponseImpl value,
          $Res Function(_$PostCreateResponseImpl) then) =
      __$$PostCreateResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? code, String? message, Post? post});

  @override
  $PostCopyWith<$Res>? get post;
}

/// @nodoc
class __$$PostCreateResponseImplCopyWithImpl<$Res>
    extends _$PostCreateResponseCopyWithImpl<$Res, _$PostCreateResponseImpl>
    implements _$$PostCreateResponseImplCopyWith<$Res> {
  __$$PostCreateResponseImplCopyWithImpl(_$PostCreateResponseImpl _value,
      $Res Function(_$PostCreateResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? message = freezed,
    Object? post = freezed,
  }) {
    return _then(_$PostCreateResponseImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      post: freezed == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as Post?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostCreateResponseImpl implements _PostCreateResponse {
  const _$PostCreateResponseImpl({this.code, this.message, this.post});

  factory _$PostCreateResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostCreateResponseImplFromJson(json);

  @override
  final int? code;
  @override
  final String? message;
  @override
  final Post? post;

  @override
  String toString() {
    return 'PostCreateResponse(code: $code, message: $message, post: $post)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostCreateResponseImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.post, post) || other.post == post));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, message, post);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostCreateResponseImplCopyWith<_$PostCreateResponseImpl> get copyWith =>
      __$$PostCreateResponseImplCopyWithImpl<_$PostCreateResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostCreateResponseImplToJson(
      this,
    );
  }
}

abstract class _PostCreateResponse implements PostCreateResponse {
  const factory _PostCreateResponse(
      {final int? code,
      final String? message,
      final Post? post}) = _$PostCreateResponseImpl;

  factory _PostCreateResponse.fromJson(Map<String, dynamic> json) =
      _$PostCreateResponseImpl.fromJson;

  @override
  int? get code;
  @override
  String? get message;
  @override
  Post? get post;
  @override
  @JsonKey(ignore: true)
  _$$PostCreateResponseImplCopyWith<_$PostCreateResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
