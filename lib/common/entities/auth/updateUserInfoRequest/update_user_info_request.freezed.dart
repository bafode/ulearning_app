// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_info_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateUserInfoRequest _$UpdateUserInfoRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateUserInfoRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateUserInfoRequest {
  String? get city => throw _privateConstructorUsedError;
  String? get school => throw _privateConstructorUsedError;
  String? get fieldOfStudy => throw _privateConstructorUsedError;
  String? get levelOfStudy => throw _privateConstructorUsedError;
  List<String>? get categories => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get rePassword => throw _privateConstructorUsedError;

  /// Serializes this UpdateUserInfoRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateUserInfoRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateUserInfoRequestCopyWith<UpdateUserInfoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserInfoRequestCopyWith<$Res> {
  factory $UpdateUserInfoRequestCopyWith(UpdateUserInfoRequest value,
          $Res Function(UpdateUserInfoRequest) then) =
      _$UpdateUserInfoRequestCopyWithImpl<$Res, UpdateUserInfoRequest>;
  @useResult
  $Res call(
      {String? city,
      String? school,
      String? fieldOfStudy,
      String? levelOfStudy,
      List<String>? categories,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? rePassword});
}

/// @nodoc
class _$UpdateUserInfoRequestCopyWithImpl<$Res,
        $Val extends UpdateUserInfoRequest>
    implements $UpdateUserInfoRequestCopyWith<$Res> {
  _$UpdateUserInfoRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateUserInfoRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? city = freezed,
    Object? school = freezed,
    Object? fieldOfStudy = freezed,
    Object? levelOfStudy = freezed,
    Object? categories = freezed,
    Object? rePassword = freezed,
  }) {
    return _then(_value.copyWith(
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      school: freezed == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldOfStudy: freezed == fieldOfStudy
          ? _value.fieldOfStudy
          : fieldOfStudy // ignore: cast_nullable_to_non_nullable
              as String?,
      levelOfStudy: freezed == levelOfStudy
          ? _value.levelOfStudy
          : levelOfStudy // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      rePassword: freezed == rePassword
          ? _value.rePassword
          : rePassword // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateUserInfoRequestImplCopyWith<$Res>
    implements $UpdateUserInfoRequestCopyWith<$Res> {
  factory _$$UpdateUserInfoRequestImplCopyWith(
          _$UpdateUserInfoRequestImpl value,
          $Res Function(_$UpdateUserInfoRequestImpl) then) =
      __$$UpdateUserInfoRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? city,
      String? school,
      String? fieldOfStudy,
      String? levelOfStudy,
      List<String>? categories,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? rePassword});
}

/// @nodoc
class __$$UpdateUserInfoRequestImplCopyWithImpl<$Res>
    extends _$UpdateUserInfoRequestCopyWithImpl<$Res,
        _$UpdateUserInfoRequestImpl>
    implements _$$UpdateUserInfoRequestImplCopyWith<$Res> {
  __$$UpdateUserInfoRequestImplCopyWithImpl(_$UpdateUserInfoRequestImpl _value,
      $Res Function(_$UpdateUserInfoRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateUserInfoRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? city = freezed,
    Object? school = freezed,
    Object? fieldOfStudy = freezed,
    Object? levelOfStudy = freezed,
    Object? categories = freezed,
    Object? rePassword = freezed,
  }) {
    return _then(_$UpdateUserInfoRequestImpl(
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      school: freezed == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldOfStudy: freezed == fieldOfStudy
          ? _value.fieldOfStudy
          : fieldOfStudy // ignore: cast_nullable_to_non_nullable
              as String?,
      levelOfStudy: freezed == levelOfStudy
          ? _value.levelOfStudy
          : levelOfStudy // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      rePassword: freezed == rePassword
          ? _value.rePassword
          : rePassword // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateUserInfoRequestImpl implements _UpdateUserInfoRequest {
  _$UpdateUserInfoRequestImpl(
      {this.city,
      this.school,
      this.fieldOfStudy,
      this.levelOfStudy,
      final List<String>? categories,
      @JsonKey(includeFromJson: false, includeToJson: false) this.rePassword})
      : _categories = categories;

  factory _$UpdateUserInfoRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateUserInfoRequestImplFromJson(json);

  @override
  final String? city;
  @override
  final String? school;
  @override
  final String? fieldOfStudy;
  @override
  final String? levelOfStudy;
  final List<String>? _categories;
  @override
  List<String>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? rePassword;

  @override
  String toString() {
    return 'UpdateUserInfoRequest(city: $city, school: $school, fieldOfStudy: $fieldOfStudy, levelOfStudy: $levelOfStudy, categories: $categories, rePassword: $rePassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserInfoRequestImpl &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.school, school) || other.school == school) &&
            (identical(other.fieldOfStudy, fieldOfStudy) ||
                other.fieldOfStudy == fieldOfStudy) &&
            (identical(other.levelOfStudy, levelOfStudy) ||
                other.levelOfStudy == levelOfStudy) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.rePassword, rePassword) ||
                other.rePassword == rePassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      city,
      school,
      fieldOfStudy,
      levelOfStudy,
      const DeepCollectionEquality().hash(_categories),
      rePassword);

  /// Create a copy of UpdateUserInfoRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserInfoRequestImplCopyWith<_$UpdateUserInfoRequestImpl>
      get copyWith => __$$UpdateUserInfoRequestImplCopyWithImpl<
          _$UpdateUserInfoRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateUserInfoRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateUserInfoRequest implements UpdateUserInfoRequest {
  factory _UpdateUserInfoRequest(
      {final String? city,
      final String? school,
      final String? fieldOfStudy,
      final String? levelOfStudy,
      final List<String>? categories,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final String? rePassword}) = _$UpdateUserInfoRequestImpl;

  factory _UpdateUserInfoRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateUserInfoRequestImpl.fromJson;

  @override
  String? get city;
  @override
  String? get school;
  @override
  String? get fieldOfStudy;
  @override
  String? get levelOfStudy;
  @override
  List<String>? get categories;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get rePassword;

  /// Create a copy of UpdateUserInfoRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserInfoRequestImplCopyWith<_$UpdateUserInfoRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
