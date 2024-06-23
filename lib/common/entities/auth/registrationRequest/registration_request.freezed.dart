// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationRequest _$RegistrationRequestFromJson(Map<String, dynamic> json) {
  return _RegistrationRequest.fromJson(json);
}

/// @nodoc
mixin _$RegistrationRequest {
  String? get firstname => throw _privateConstructorUsedError;
  String? get lastname => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get rePassword => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationRequestCopyWith<RegistrationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationRequestCopyWith<$Res> {
  factory $RegistrationRequestCopyWith(
          RegistrationRequest value, $Res Function(RegistrationRequest) then) =
      _$RegistrationRequestCopyWithImpl<$Res, RegistrationRequest>;
  @useResult
  $Res call(
      {String? firstname,
      String? lastname,
      String? email,
      String? password,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? rePassword});
}

/// @nodoc
class _$RegistrationRequestCopyWithImpl<$Res, $Val extends RegistrationRequest>
    implements $RegistrationRequestCopyWith<$Res> {
  _$RegistrationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? rePassword = freezed,
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
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      rePassword: freezed == rePassword
          ? _value.rePassword
          : rePassword // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationRequestImplCopyWith<$Res>
    implements $RegistrationRequestCopyWith<$Res> {
  factory _$$RegistrationRequestImplCopyWith(_$RegistrationRequestImpl value,
          $Res Function(_$RegistrationRequestImpl) then) =
      __$$RegistrationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? firstname,
      String? lastname,
      String? email,
      String? password,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? rePassword});
}

/// @nodoc
class __$$RegistrationRequestImplCopyWithImpl<$Res>
    extends _$RegistrationRequestCopyWithImpl<$Res, _$RegistrationRequestImpl>
    implements _$$RegistrationRequestImplCopyWith<$Res> {
  __$$RegistrationRequestImplCopyWithImpl(_$RegistrationRequestImpl _value,
      $Res Function(_$RegistrationRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? rePassword = freezed,
  }) {
    return _then(_$RegistrationRequestImpl(
      firstname: freezed == firstname
          ? _value.firstname
          : firstname // ignore: cast_nullable_to_non_nullable
              as String?,
      lastname: freezed == lastname
          ? _value.lastname
          : lastname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      rePassword: freezed == rePassword
          ? _value.rePassword
          : rePassword // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationRequestImpl implements _RegistrationRequest {
  _$RegistrationRequestImpl(
      {this.firstname,
      this.lastname,
      this.email,
      this.password,
      @JsonKey(includeFromJson: false, includeToJson: false) this.rePassword});

  factory _$RegistrationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationRequestImplFromJson(json);

  @override
  final String? firstname;
  @override
  final String? lastname;
  @override
  final String? email;
  @override
  final String? password;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? rePassword;

  @override
  String toString() {
    return 'RegistrationRequest(firstname: $firstname, lastname: $lastname, email: $email, password: $password, rePassword: $rePassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationRequestImpl &&
            (identical(other.firstname, firstname) ||
                other.firstname == firstname) &&
            (identical(other.lastname, lastname) ||
                other.lastname == lastname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rePassword, rePassword) ||
                other.rePassword == rePassword));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, firstname, lastname, email, password, rePassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationRequestImplCopyWith<_$RegistrationRequestImpl> get copyWith =>
      __$$RegistrationRequestImplCopyWithImpl<_$RegistrationRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationRequestImplToJson(
      this,
    );
  }
}

abstract class _RegistrationRequest implements RegistrationRequest {
  factory _RegistrationRequest(
      {final String? firstname,
      final String? lastname,
      final String? email,
      final String? password,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final String? rePassword}) = _$RegistrationRequestImpl;

  factory _RegistrationRequest.fromJson(Map<String, dynamic> json) =
      _$RegistrationRequestImpl.fromJson;

  @override
  String? get firstname;
  @override
  String? get lastname;
  @override
  String? get email;
  @override
  String? get password;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get rePassword;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationRequestImplCopyWith<_$RegistrationRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
