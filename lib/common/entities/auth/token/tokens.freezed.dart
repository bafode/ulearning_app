// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tokens.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tokens _$TokensFromJson(Map<String, dynamic> json) {
  return _Tokens.fromJson(json);
}

/// @nodoc
mixin _$Tokens {
  Token get access => throw _privateConstructorUsedError;
  Token get refresh => throw _privateConstructorUsedError;

  /// Serializes this Tokens to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tokens
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TokensCopyWith<Tokens> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokensCopyWith<$Res> {
  factory $TokensCopyWith(Tokens value, $Res Function(Tokens) then) =
      _$TokensCopyWithImpl<$Res, Tokens>;
  @useResult
  $Res call({Token access, Token refresh});

  $TokenCopyWith<$Res> get access;
  $TokenCopyWith<$Res> get refresh;
}

/// @nodoc
class _$TokensCopyWithImpl<$Res, $Val extends Tokens>
    implements $TokensCopyWith<$Res> {
  _$TokensCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tokens
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access = null,
    Object? refresh = null,
  }) {
    return _then(_value.copyWith(
      access: null == access
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as Token,
      refresh: null == refresh
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as Token,
    ) as $Val);
  }

  /// Create a copy of Tokens
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenCopyWith<$Res> get access {
    return $TokenCopyWith<$Res>(_value.access, (value) {
      return _then(_value.copyWith(access: value) as $Val);
    });
  }

  /// Create a copy of Tokens
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenCopyWith<$Res> get refresh {
    return $TokenCopyWith<$Res>(_value.refresh, (value) {
      return _then(_value.copyWith(refresh: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TokensImplCopyWith<$Res> implements $TokensCopyWith<$Res> {
  factory _$$TokensImplCopyWith(
          _$TokensImpl value, $Res Function(_$TokensImpl) then) =
      __$$TokensImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Token access, Token refresh});

  @override
  $TokenCopyWith<$Res> get access;
  @override
  $TokenCopyWith<$Res> get refresh;
}

/// @nodoc
class __$$TokensImplCopyWithImpl<$Res>
    extends _$TokensCopyWithImpl<$Res, _$TokensImpl>
    implements _$$TokensImplCopyWith<$Res> {
  __$$TokensImplCopyWithImpl(
      _$TokensImpl _value, $Res Function(_$TokensImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tokens
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access = null,
    Object? refresh = null,
  }) {
    return _then(_$TokensImpl(
      access: null == access
          ? _value.access
          : access // ignore: cast_nullable_to_non_nullable
              as Token,
      refresh: null == refresh
          ? _value.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as Token,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TokensImpl implements _Tokens {
  const _$TokensImpl({required this.access, required this.refresh});

  factory _$TokensImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokensImplFromJson(json);

  @override
  final Token access;
  @override
  final Token refresh;

  @override
  String toString() {
    return 'Tokens(access: $access, refresh: $refresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokensImpl &&
            (identical(other.access, access) || other.access == access) &&
            (identical(other.refresh, refresh) || other.refresh == refresh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, access, refresh);

  /// Create a copy of Tokens
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TokensImplCopyWith<_$TokensImpl> get copyWith =>
      __$$TokensImplCopyWithImpl<_$TokensImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokensImplToJson(
      this,
    );
  }
}

abstract class _Tokens implements Tokens {
  const factory _Tokens(
      {required final Token access,
      required final Token refresh}) = _$TokensImpl;

  factory _Tokens.fromJson(Map<String, dynamic> json) = _$TokensImpl.fromJson;

  @override
  Token get access;
  @override
  Token get refresh;

  /// Create a copy of Tokens
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokensImplCopyWith<_$TokensImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
