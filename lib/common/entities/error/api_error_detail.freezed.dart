// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_error_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiErrorDetail _$ApiErrorDetailFromJson(Map<String, dynamic> json) {
  return _ApiErrorDetail.fromJson(json);
}

/// @nodoc
mixin _$ApiErrorDetail {
  String? get field => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this ApiErrorDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiErrorDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiErrorDetailCopyWith<ApiErrorDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiErrorDetailCopyWith<$Res> {
  factory $ApiErrorDetailCopyWith(
          ApiErrorDetail value, $Res Function(ApiErrorDetail) then) =
      _$ApiErrorDetailCopyWithImpl<$Res, ApiErrorDetail>;
  @useResult
  $Res call({String? field, String? message});
}

/// @nodoc
class _$ApiErrorDetailCopyWithImpl<$Res, $Val extends ApiErrorDetail>
    implements $ApiErrorDetailCopyWith<$Res> {
  _$ApiErrorDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiErrorDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiErrorDetailImplCopyWith<$Res>
    implements $ApiErrorDetailCopyWith<$Res> {
  factory _$$ApiErrorDetailImplCopyWith(_$ApiErrorDetailImpl value,
          $Res Function(_$ApiErrorDetailImpl) then) =
      __$$ApiErrorDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? field, String? message});
}

/// @nodoc
class __$$ApiErrorDetailImplCopyWithImpl<$Res>
    extends _$ApiErrorDetailCopyWithImpl<$Res, _$ApiErrorDetailImpl>
    implements _$$ApiErrorDetailImplCopyWith<$Res> {
  __$$ApiErrorDetailImplCopyWithImpl(
      _$ApiErrorDetailImpl _value, $Res Function(_$ApiErrorDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiErrorDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = freezed,
    Object? message = freezed,
  }) {
    return _then(_$ApiErrorDetailImpl(
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiErrorDetailImpl implements _ApiErrorDetail {
  const _$ApiErrorDetailImpl({this.field, this.message});

  factory _$ApiErrorDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiErrorDetailImplFromJson(json);

  @override
  final String? field;
  @override
  final String? message;

  @override
  String toString() {
    return 'ApiErrorDetail(field: $field, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiErrorDetailImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, field, message);

  /// Create a copy of ApiErrorDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiErrorDetailImplCopyWith<_$ApiErrorDetailImpl> get copyWith =>
      __$$ApiErrorDetailImplCopyWithImpl<_$ApiErrorDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiErrorDetailImplToJson(
      this,
    );
  }
}

abstract class _ApiErrorDetail implements ApiErrorDetail {
  const factory _ApiErrorDetail({final String? field, final String? message}) =
      _$ApiErrorDetailImpl;

  factory _ApiErrorDetail.fromJson(Map<String, dynamic> json) =
      _$ApiErrorDetailImpl.fromJson;

  @override
  String? get field;
  @override
  String? get message;

  /// Create a copy of ApiErrorDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiErrorDetailImplCopyWith<_$ApiErrorDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
