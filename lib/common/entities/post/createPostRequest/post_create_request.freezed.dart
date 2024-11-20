// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostCreateRequest _$PostCreateRequestFromJson(Map<String, dynamic> json) {
  return _PostCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$PostCreateRequest {
  String? get title => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<File>? get media => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostCreateRequestCopyWith<PostCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCreateRequestCopyWith<$Res> {
  factory $PostCreateRequestCopyWith(
          PostCreateRequest value, $Res Function(PostCreateRequest) then) =
      _$PostCreateRequestCopyWithImpl<$Res, PostCreateRequest>;
  @useResult
  $Res call(
      {String? title,
      String? content,
      String? category,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<File>? media});
}

/// @nodoc
class _$PostCreateRequestCopyWithImpl<$Res, $Val extends PostCreateRequest>
    implements $PostCreateRequestCopyWith<$Res> {
  _$PostCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? content = freezed,
    Object? category = freezed,
    Object? media = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<File>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostCreateRequestImplCopyWith<$Res>
    implements $PostCreateRequestCopyWith<$Res> {
  factory _$$PostCreateRequestImplCopyWith(_$PostCreateRequestImpl value,
          $Res Function(_$PostCreateRequestImpl) then) =
      __$$PostCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      String? content,
      String? category,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<File>? media});
}

/// @nodoc
class __$$PostCreateRequestImplCopyWithImpl<$Res>
    extends _$PostCreateRequestCopyWithImpl<$Res, _$PostCreateRequestImpl>
    implements _$$PostCreateRequestImplCopyWith<$Res> {
  __$$PostCreateRequestImplCopyWithImpl(_$PostCreateRequestImpl _value,
      $Res Function(_$PostCreateRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? content = freezed,
    Object? category = freezed,
    Object? media = freezed,
  }) {
    return _then(_$PostCreateRequestImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<File>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostCreateRequestImpl implements _PostCreateRequest {
  const _$PostCreateRequestImpl(
      {this.title,
      this.content,
      this.category,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<File>? media})
      : _media = media;

  factory _$PostCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostCreateRequestImplFromJson(json);

  @override
  final String? title;
  @override
  final String? content;
  @override
  final String? category;
  final List<File>? _media;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<File>? get media {
    final value = _media;
    if (value == null) return null;
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PostCreateRequest(title: $title, content: $content, category: $category, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostCreateRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._media, _media));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, content, category,
      const DeepCollectionEquality().hash(_media));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostCreateRequestImplCopyWith<_$PostCreateRequestImpl> get copyWith =>
      __$$PostCreateRequestImplCopyWithImpl<_$PostCreateRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _PostCreateRequest implements PostCreateRequest {
  const factory _PostCreateRequest(
      {final String? title,
      final String? content,
      final String? category,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<File>? media}) = _$PostCreateRequestImpl;

  factory _PostCreateRequest.fromJson(Map<String, dynamic> json) =
      _$PostCreateRequestImpl.fromJson;

  @override
  String? get title;
  @override
  String? get content;
  @override
  String? get category;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<File>? get media;
  @override
  @JsonKey(ignore: true)
  _$$PostCreateRequestImplCopyWith<_$PostCreateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
