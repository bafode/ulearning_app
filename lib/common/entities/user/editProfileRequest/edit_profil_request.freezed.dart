// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profil_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EditProfilRequest _$EditProfilRequestFromJson(Map<String, dynamic> json) {
  return _EditProfilRequest.fromJson(json);
}

/// @nodoc
mixin _$EditProfilRequest {
  String? get firstname => throw _privateConstructorUsedError;
  String? get lastname => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this EditProfilRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EditProfilRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditProfilRequestCopyWith<EditProfilRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditProfilRequestCopyWith<$Res> {
  factory $EditProfilRequestCopyWith(
          EditProfilRequest value, $Res Function(EditProfilRequest) then) =
      _$EditProfilRequestCopyWithImpl<$Res, EditProfilRequest>;
  @useResult
  $Res call({String? firstname, String? lastname, String? description});
}

/// @nodoc
class _$EditProfilRequestCopyWithImpl<$Res, $Val extends EditProfilRequest>
    implements $EditProfilRequestCopyWith<$Res> {
  _$EditProfilRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditProfilRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      firstname: freezed == firstname
          ? _value.firstname
          : firstname // ignore: cast_nullable_to_non_nullable
              as String?,
      lastname: freezed == lastname
          ? _value.lastname
          : lastname // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditProfilRequestImplCopyWith<$Res>
    implements $EditProfilRequestCopyWith<$Res> {
  factory _$$EditProfilRequestImplCopyWith(_$EditProfilRequestImpl value,
          $Res Function(_$EditProfilRequestImpl) then) =
      __$$EditProfilRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? firstname, String? lastname, String? description});
}

/// @nodoc
class __$$EditProfilRequestImplCopyWithImpl<$Res>
    extends _$EditProfilRequestCopyWithImpl<$Res, _$EditProfilRequestImpl>
    implements _$$EditProfilRequestImplCopyWith<$Res> {
  __$$EditProfilRequestImplCopyWithImpl(_$EditProfilRequestImpl _value,
      $Res Function(_$EditProfilRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of EditProfilRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? description = freezed,
  }) {
    return _then(_$EditProfilRequestImpl(
      firstname: freezed == firstname
          ? _value.firstname
          : firstname // ignore: cast_nullable_to_non_nullable
              as String?,
      lastname: freezed == lastname
          ? _value.lastname
          : lastname // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EditProfilRequestImpl implements _EditProfilRequest {
  const _$EditProfilRequestImpl(
      {this.firstname, this.lastname, this.description});

  factory _$EditProfilRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$EditProfilRequestImplFromJson(json);

  @override
  final String? firstname;
  @override
  final String? lastname;
  @override
  final String? description;

  @override
  String toString() {
    return 'EditProfilRequest(firstname: $firstname, lastname: $lastname, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditProfilRequestImpl &&
            (identical(other.firstname, firstname) ||
                other.firstname == firstname) &&
            (identical(other.lastname, lastname) ||
                other.lastname == lastname) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, firstname, lastname, description);

  /// Create a copy of EditProfilRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EditProfilRequestImplCopyWith<_$EditProfilRequestImpl> get copyWith =>
      __$$EditProfilRequestImplCopyWithImpl<_$EditProfilRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EditProfilRequestImplToJson(
      this,
    );
  }
}

abstract class _EditProfilRequest implements EditProfilRequest {
  const factory _EditProfilRequest(
      {final String? firstname,
      final String? lastname,
      final String? description}) = _$EditProfilRequestImpl;

  factory _EditProfilRequest.fromJson(Map<String, dynamic> json) =
      _$EditProfilRequestImpl.fromJson;

  @override
  String? get firstname;
  @override
  String? get lastname;
  @override
  String? get description;

  /// Create a copy of EditProfilRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EditProfilRequestImplCopyWith<_$EditProfilRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
