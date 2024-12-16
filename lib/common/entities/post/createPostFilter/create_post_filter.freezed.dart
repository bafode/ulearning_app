// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_post_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreatePostFilter {
  List<FieldOfStudy> get fieldsOfStudy => throw _privateConstructorUsedError;

  /// Create a copy of CreatePostFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePostFilterCopyWith<CreatePostFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostFilterCopyWith<$Res> {
  factory $CreatePostFilterCopyWith(
          CreatePostFilter value, $Res Function(CreatePostFilter) then) =
      _$CreatePostFilterCopyWithImpl<$Res, CreatePostFilter>;
  @useResult
  $Res call({List<FieldOfStudy> fieldsOfStudy});
}

/// @nodoc
class _$CreatePostFilterCopyWithImpl<$Res, $Val extends CreatePostFilter>
    implements $CreatePostFilterCopyWith<$Res> {
  _$CreatePostFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePostFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldsOfStudy = null,
  }) {
    return _then(_value.copyWith(
      fieldsOfStudy: null == fieldsOfStudy
          ? _value.fieldsOfStudy
          : fieldsOfStudy // ignore: cast_nullable_to_non_nullable
              as List<FieldOfStudy>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePostFilterImplCopyWith<$Res>
    implements $CreatePostFilterCopyWith<$Res> {
  factory _$$CreatePostFilterImplCopyWith(_$CreatePostFilterImpl value,
          $Res Function(_$CreatePostFilterImpl) then) =
      __$$CreatePostFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<FieldOfStudy> fieldsOfStudy});
}

/// @nodoc
class __$$CreatePostFilterImplCopyWithImpl<$Res>
    extends _$CreatePostFilterCopyWithImpl<$Res, _$CreatePostFilterImpl>
    implements _$$CreatePostFilterImplCopyWith<$Res> {
  __$$CreatePostFilterImplCopyWithImpl(_$CreatePostFilterImpl _value,
      $Res Function(_$CreatePostFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatePostFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldsOfStudy = null,
  }) {
    return _then(_$CreatePostFilterImpl(
      fieldsOfStudy: null == fieldsOfStudy
          ? _value._fieldsOfStudy
          : fieldsOfStudy // ignore: cast_nullable_to_non_nullable
              as List<FieldOfStudy>,
    ));
  }
}

/// @nodoc

class _$CreatePostFilterImpl implements _CreatePostFilter {
  const _$CreatePostFilterImpl(
      {final List<FieldOfStudy> fieldsOfStudy = const []})
      : _fieldsOfStudy = fieldsOfStudy;

  final List<FieldOfStudy> _fieldsOfStudy;
  @override
  @JsonKey()
  List<FieldOfStudy> get fieldsOfStudy {
    if (_fieldsOfStudy is EqualUnmodifiableListView) return _fieldsOfStudy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fieldsOfStudy);
  }

  @override
  String toString() {
    return 'CreatePostFilter(fieldsOfStudy: $fieldsOfStudy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostFilterImpl &&
            const DeepCollectionEquality()
                .equals(other._fieldsOfStudy, _fieldsOfStudy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_fieldsOfStudy));

  /// Create a copy of CreatePostFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostFilterImplCopyWith<_$CreatePostFilterImpl> get copyWith =>
      __$$CreatePostFilterImplCopyWithImpl<_$CreatePostFilterImpl>(
          this, _$identity);
}

abstract class _CreatePostFilter implements CreatePostFilter {
  const factory _CreatePostFilter({final List<FieldOfStudy> fieldsOfStudy}) =
      _$CreatePostFilterImpl;

  @override
  List<FieldOfStudy> get fieldsOfStudy;

  /// Create a copy of CreatePostFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePostFilterImplCopyWith<_$CreatePostFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
