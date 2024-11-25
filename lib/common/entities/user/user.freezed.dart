// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String? get id => throw _privateConstructorUsedError;
  String? get firstname => throw _privateConstructorUsedError;
  String? get lastname => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  bool? get isEmailVerified => throw _privateConstructorUsedError;
  bool? get accountClosed => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  bool? get online => throw _privateConstructorUsedError;
  String? get open_id => throw _privateConstructorUsedError;
  String? get authType => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get school => throw _privateConstructorUsedError;
  String? get fieldOfStudy => throw _privateConstructorUsedError;
  String? get levelOfStudy => throw _privateConstructorUsedError;
  List<String>? get categories => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String? id,
      String? firstname,
      String? lastname,
      String? email,
      String? avatar,
      String? gender,
      String? status,
      String? description,
      String? role,
      bool? isEmailVerified,
      bool? accountClosed,
      String? phone,
      bool? online,
      String? open_id,
      String? authType,
      String? city,
      String? school,
      String? fieldOfStudy,
      String? levelOfStudy,
      List<String>? categories});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? gender = freezed,
    Object? status = freezed,
    Object? description = freezed,
    Object? role = freezed,
    Object? isEmailVerified = freezed,
    Object? accountClosed = freezed,
    Object? phone = freezed,
    Object? online = freezed,
    Object? open_id = freezed,
    Object? authType = freezed,
    Object? city = freezed,
    Object? school = freezed,
    Object? fieldOfStudy = freezed,
    Object? levelOfStudy = freezed,
    Object? categories = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      isEmailVerified: freezed == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      accountClosed: freezed == accountClosed
          ? _value.accountClosed
          : accountClosed // ignore: cast_nullable_to_non_nullable
              as bool?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      online: freezed == online
          ? _value.online
          : online // ignore: cast_nullable_to_non_nullable
              as bool?,
      open_id: freezed == open_id
          ? _value.open_id
          : open_id // ignore: cast_nullable_to_non_nullable
              as String?,
      authType: freezed == authType
          ? _value.authType
          : authType // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? firstname,
      String? lastname,
      String? email,
      String? avatar,
      String? gender,
      String? status,
      String? description,
      String? role,
      bool? isEmailVerified,
      bool? accountClosed,
      String? phone,
      bool? online,
      String? open_id,
      String? authType,
      String? city,
      String? school,
      String? fieldOfStudy,
      String? levelOfStudy,
      List<String>? categories});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? email = freezed,
    Object? avatar = freezed,
    Object? gender = freezed,
    Object? status = freezed,
    Object? description = freezed,
    Object? role = freezed,
    Object? isEmailVerified = freezed,
    Object? accountClosed = freezed,
    Object? phone = freezed,
    Object? online = freezed,
    Object? open_id = freezed,
    Object? authType = freezed,
    Object? city = freezed,
    Object? school = freezed,
    Object? fieldOfStudy = freezed,
    Object? levelOfStudy = freezed,
    Object? categories = freezed,
  }) {
    return _then(_$UserImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      isEmailVerified: freezed == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      accountClosed: freezed == accountClosed
          ? _value.accountClosed
          : accountClosed // ignore: cast_nullable_to_non_nullable
              as bool?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      online: freezed == online
          ? _value.online
          : online // ignore: cast_nullable_to_non_nullable
              as bool?,
      open_id: freezed == open_id
          ? _value.open_id
          : open_id // ignore: cast_nullable_to_non_nullable
              as String?,
      authType: freezed == authType
          ? _value.authType
          : authType // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.avatar,
      this.gender,
      this.status,
      this.description,
      this.role,
      this.isEmailVerified,
      this.accountClosed,
      this.phone,
      this.online,
      this.open_id,
      this.authType,
      this.city,
      this.school,
      this.fieldOfStudy,
      this.levelOfStudy,
      final List<String>? categories})
      : _categories = categories;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String? id;
  @override
  final String? firstname;
  @override
  final String? lastname;
  @override
  final String? email;
  @override
  final String? avatar;
  @override
  final String? gender;
  @override
  final String? status;
  @override
  final String? description;
  @override
  final String? role;
  @override
  final bool? isEmailVerified;
  @override
  final bool? accountClosed;
  @override
  final String? phone;
  @override
  final bool? online;
  @override
  final String? open_id;
  @override
  final String? authType;
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
  String toString() {
    return 'User(id: $id, firstname: $firstname, lastname: $lastname, email: $email, avatar: $avatar, gender: $gender, status: $status, description: $description, role: $role, isEmailVerified: $isEmailVerified, accountClosed: $accountClosed, phone: $phone, online: $online, open_id: $open_id, authType: $authType, city: $city, school: $school, fieldOfStudy: $fieldOfStudy, levelOfStudy: $levelOfStudy, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstname, firstname) ||
                other.firstname == firstname) &&
            (identical(other.lastname, lastname) ||
                other.lastname == lastname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.accountClosed, accountClosed) ||
                other.accountClosed == accountClosed) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.online, online) || other.online == online) &&
            (identical(other.open_id, open_id) || other.open_id == open_id) &&
            (identical(other.authType, authType) ||
                other.authType == authType) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.school, school) || other.school == school) &&
            (identical(other.fieldOfStudy, fieldOfStudy) ||
                other.fieldOfStudy == fieldOfStudy) &&
            (identical(other.levelOfStudy, levelOfStudy) ||
                other.levelOfStudy == levelOfStudy) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        firstname,
        lastname,
        email,
        avatar,
        gender,
        status,
        description,
        role,
        isEmailVerified,
        accountClosed,
        phone,
        online,
        open_id,
        authType,
        city,
        school,
        fieldOfStudy,
        levelOfStudy,
        const DeepCollectionEquality().hash(_categories)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {final String? id,
      final String? firstname,
      final String? lastname,
      final String? email,
      final String? avatar,
      final String? gender,
      final String? status,
      final String? description,
      final String? role,
      final bool? isEmailVerified,
      final bool? accountClosed,
      final String? phone,
      final bool? online,
      final String? open_id,
      final String? authType,
      final String? city,
      final String? school,
      final String? fieldOfStudy,
      final String? levelOfStudy,
      final List<String>? categories}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String? get id;
  @override
  String? get firstname;
  @override
  String? get lastname;
  @override
  String? get email;
  @override
  String? get avatar;
  @override
  String? get gender;
  @override
  String? get status;
  @override
  String? get description;
  @override
  String? get role;
  @override
  bool? get isEmailVerified;
  @override
  bool? get accountClosed;
  @override
  String? get phone;
  @override
  bool? get online;
  @override
  String? get open_id;
  @override
  String? get authType;
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
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
