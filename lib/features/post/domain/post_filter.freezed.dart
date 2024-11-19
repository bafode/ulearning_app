// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PostFilter {
  String? get query => throw _privateConstructorUsedError;
  List<FieldOfStudy> get fieldsOfStudy => throw _privateConstructorUsedError;
  SortOption? get sort => throw _privateConstructorUsedError;
  OrderOption? get order => throw _privateConstructorUsedError;

  /// Create a copy of PostFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostFilterCopyWith<PostFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostFilterCopyWith<$Res> {
  factory $PostFilterCopyWith(
          PostFilter value, $Res Function(PostFilter) then) =
      _$PostFilterCopyWithImpl<$Res, PostFilter>;
  @useResult
  $Res call(
      {String? query,
      List<FieldOfStudy> fieldsOfStudy,
      SortOption? sort,
      OrderOption? order});
}

/// @nodoc
class _$PostFilterCopyWithImpl<$Res, $Val extends PostFilter>
    implements $PostFilterCopyWith<$Res> {
  _$PostFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? fieldsOfStudy = null,
    Object? sort = freezed,
    Object? order = freezed,
  }) {
    return _then(_value.copyWith(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldsOfStudy: null == fieldsOfStudy
          ? _value.fieldsOfStudy
          : fieldsOfStudy // ignore: cast_nullable_to_non_nullable
              as List<FieldOfStudy>,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as SortOption?,
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderOption?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostFilterImplCopyWith<$Res>
    implements $PostFilterCopyWith<$Res> {
  factory _$$PostFilterImplCopyWith(
          _$PostFilterImpl value, $Res Function(_$PostFilterImpl) then) =
      __$$PostFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? query,
      List<FieldOfStudy> fieldsOfStudy,
      SortOption? sort,
      OrderOption? order});
}

/// @nodoc
class __$$PostFilterImplCopyWithImpl<$Res>
    extends _$PostFilterCopyWithImpl<$Res, _$PostFilterImpl>
    implements _$$PostFilterImplCopyWith<$Res> {
  __$$PostFilterImplCopyWithImpl(
      _$PostFilterImpl _value, $Res Function(_$PostFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? fieldsOfStudy = null,
    Object? sort = freezed,
    Object? order = freezed,
  }) {
    return _then(_$PostFilterImpl(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldsOfStudy: null == fieldsOfStudy
          ? _value._fieldsOfStudy
          : fieldsOfStudy // ignore: cast_nullable_to_non_nullable
              as List<FieldOfStudy>,
      sort: freezed == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as SortOption?,
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderOption?,
    ));
  }
}

/// @nodoc

class _$PostFilterImpl implements _PostFilter {
  const _$PostFilterImpl(
      {this.query,
      final List<FieldOfStudy> fieldsOfStudy = const [],
      this.sort,
      this.order})
      : _fieldsOfStudy = fieldsOfStudy;

  @override
  final String? query;
  final List<FieldOfStudy> _fieldsOfStudy;
  @override
  @JsonKey()
  List<FieldOfStudy> get fieldsOfStudy {
    if (_fieldsOfStudy is EqualUnmodifiableListView) return _fieldsOfStudy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fieldsOfStudy);
  }

  @override
  final SortOption? sort;
  @override
  final OrderOption? order;

  @override
  String toString() {
    return 'PostFilter(query: $query, fieldsOfStudy: $fieldsOfStudy, sort: $sort, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostFilterImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality()
                .equals(other._fieldsOfStudy, _fieldsOfStudy) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query,
      const DeepCollectionEquality().hash(_fieldsOfStudy), sort, order);

  /// Create a copy of PostFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostFilterImplCopyWith<_$PostFilterImpl> get copyWith =>
      __$$PostFilterImplCopyWithImpl<_$PostFilterImpl>(this, _$identity);
}

abstract class _PostFilter implements PostFilter {
  const factory _PostFilter(
      {final String? query,
      final List<FieldOfStudy> fieldsOfStudy,
      final SortOption? sort,
      final OrderOption? order}) = _$PostFilterImpl;

  @override
  String? get query;
  @override
  List<FieldOfStudy> get fieldsOfStudy;
  @override
  SortOption? get sort;
  @override
  OrderOption? get order;

  /// Create a copy of PostFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostFilterImplCopyWith<_$PostFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
