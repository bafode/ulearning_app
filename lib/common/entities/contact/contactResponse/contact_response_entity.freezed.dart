// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_response_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContactResponseEntity _$ContactResponseEntityFromJson(
    Map<String, dynamic> json) {
  return _ContactResponseEntity.fromJson(json);
}

/// @nodoc
mixin _$ContactResponseEntity {
  int? get code => throw _privateConstructorUsedError;
  String? get msg => throw _privateConstructorUsedError;
  List<ContactItem>? get data => throw _privateConstructorUsedError;

  /// Serializes this ContactResponseEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactResponseEntityCopyWith<ContactResponseEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactResponseEntityCopyWith<$Res> {
  factory $ContactResponseEntityCopyWith(ContactResponseEntity value,
          $Res Function(ContactResponseEntity) then) =
      _$ContactResponseEntityCopyWithImpl<$Res, ContactResponseEntity>;
  @useResult
  $Res call({int? code, String? msg, List<ContactItem>? data});
}

/// @nodoc
class _$ContactResponseEntityCopyWithImpl<$Res,
        $Val extends ContactResponseEntity>
    implements $ContactResponseEntityCopyWith<$Res> {
  _$ContactResponseEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? msg = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ContactItem>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactResponseEntityImplCopyWith<$Res>
    implements $ContactResponseEntityCopyWith<$Res> {
  factory _$$ContactResponseEntityImplCopyWith(
          _$ContactResponseEntityImpl value,
          $Res Function(_$ContactResponseEntityImpl) then) =
      __$$ContactResponseEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? code, String? msg, List<ContactItem>? data});
}

/// @nodoc
class __$$ContactResponseEntityImplCopyWithImpl<$Res>
    extends _$ContactResponseEntityCopyWithImpl<$Res,
        _$ContactResponseEntityImpl>
    implements _$$ContactResponseEntityImplCopyWith<$Res> {
  __$$ContactResponseEntityImplCopyWithImpl(_$ContactResponseEntityImpl _value,
      $Res Function(_$ContactResponseEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? msg = freezed,
    Object? data = freezed,
  }) {
    return _then(_$ContactResponseEntityImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ContactItem>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactResponseEntityImpl implements _ContactResponseEntity {
  const _$ContactResponseEntityImpl(
      {required this.code,
      required this.msg,
      required final List<ContactItem>? data})
      : _data = data;

  factory _$ContactResponseEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactResponseEntityImplFromJson(json);

  @override
  final int? code;
  @override
  final String? msg;
  final List<ContactItem>? _data;
  @override
  List<ContactItem>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ContactResponseEntity(code: $code, msg: $msg, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactResponseEntityImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, code, msg, const DeepCollectionEquality().hash(_data));

  /// Create a copy of ContactResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactResponseEntityImplCopyWith<_$ContactResponseEntityImpl>
      get copyWith => __$$ContactResponseEntityImplCopyWithImpl<
          _$ContactResponseEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactResponseEntityImplToJson(
      this,
    );
  }
}

abstract class _ContactResponseEntity implements ContactResponseEntity {
  const factory _ContactResponseEntity(
      {required final int? code,
      required final String? msg,
      required final List<ContactItem>? data}) = _$ContactResponseEntityImpl;

  factory _ContactResponseEntity.fromJson(Map<String, dynamic> json) =
      _$ContactResponseEntityImpl.fromJson;

  @override
  int? get code;
  @override
  String? get msg;
  @override
  List<ContactItem>? get data;

  /// Create a copy of ContactResponseEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactResponseEntityImplCopyWith<_$ContactResponseEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContactItem _$ContactItemFromJson(Map<String, dynamic> json) {
  return _ContactItem.fromJson(json);
}

/// @nodoc
mixin _$ContactItem {
  String? get token => throw _privateConstructorUsedError;
  String? get firstname => throw _privateConstructorUsedError;
  String? get lastname => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  int? get online => throw _privateConstructorUsedError;

  /// Serializes this ContactItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactItemCopyWith<ContactItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactItemCopyWith<$Res> {
  factory $ContactItemCopyWith(
          ContactItem value, $Res Function(ContactItem) then) =
      _$ContactItemCopyWithImpl<$Res, ContactItem>;
  @useResult
  $Res call(
      {String? token,
      String? firstname,
      String? lastname,
      String? description,
      String? avatar,
      int? online});
}

/// @nodoc
class _$ContactItemCopyWithImpl<$Res, $Val extends ContactItem>
    implements $ContactItemCopyWith<$Res> {
  _$ContactItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? description = freezed,
    Object? avatar = freezed,
    Object? online = freezed,
  }) {
    return _then(_value.copyWith(
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
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
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      online: freezed == online
          ? _value.online
          : online // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactItemImplCopyWith<$Res>
    implements $ContactItemCopyWith<$Res> {
  factory _$$ContactItemImplCopyWith(
          _$ContactItemImpl value, $Res Function(_$ContactItemImpl) then) =
      __$$ContactItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? token,
      String? firstname,
      String? lastname,
      String? description,
      String? avatar,
      int? online});
}

/// @nodoc
class __$$ContactItemImplCopyWithImpl<$Res>
    extends _$ContactItemCopyWithImpl<$Res, _$ContactItemImpl>
    implements _$$ContactItemImplCopyWith<$Res> {
  __$$ContactItemImplCopyWithImpl(
      _$ContactItemImpl _value, $Res Function(_$ContactItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = freezed,
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? description = freezed,
    Object? avatar = freezed,
    Object? online = freezed,
  }) {
    return _then(_$ContactItemImpl(
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
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
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      online: freezed == online
          ? _value.online
          : online // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactItemImpl implements _ContactItem {
  const _$ContactItemImpl(
      {required this.token,
      required this.firstname,
      required this.lastname,
      required this.description,
      required this.avatar,
      required this.online});

  factory _$ContactItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactItemImplFromJson(json);

  @override
  final String? token;
  @override
  final String? firstname;
  @override
  final String? lastname;
  @override
  final String? description;
  @override
  final String? avatar;
  @override
  final int? online;

  @override
  String toString() {
    return 'ContactItem(token: $token, firstname: $firstname, lastname: $lastname, description: $description, avatar: $avatar, online: $online)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactItemImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.firstname, firstname) ||
                other.firstname == firstname) &&
            (identical(other.lastname, lastname) ||
                other.lastname == lastname) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.online, online) || other.online == online));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, token, firstname, lastname, description, avatar, online);

  /// Create a copy of ContactItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactItemImplCopyWith<_$ContactItemImpl> get copyWith =>
      __$$ContactItemImplCopyWithImpl<_$ContactItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactItemImplToJson(
      this,
    );
  }
}

abstract class _ContactItem implements ContactItem {
  const factory _ContactItem(
      {required final String? token,
      required final String? firstname,
      required final String? lastname,
      required final String? description,
      required final String? avatar,
      required final int? online}) = _$ContactItemImpl;

  factory _ContactItem.fromJson(Map<String, dynamic> json) =
      _$ContactItemImpl.fromJson;

  @override
  String? get token;
  @override
  String? get firstname;
  @override
  String? get lastname;
  @override
  String? get description;
  @override
  String? get avatar;
  @override
  int? get online;

  /// Create a copy of ContactItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactItemImplCopyWith<_$ContactItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
