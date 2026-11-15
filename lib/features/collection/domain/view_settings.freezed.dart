// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'view_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ViewSettings {

 CollectionSort get sort; CompletionFilter get filter; bool get grid;
/// Create a copy of ViewSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewSettingsCopyWith<ViewSettings> get copyWith => _$ViewSettingsCopyWithImpl<ViewSettings>(this as ViewSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ViewSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewSettings&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.filter, _this.filter) || other.filter == _this.filter)&&(identical(other.grid, _this.grid) || other.grid == _this.grid));
}


@override
int get hashCode {
  final _this = this as ViewSettings;
  return Object.hash(runtimeType,_this.sort,_this.filter,_this.grid);
}

@override
String toString() {
  final _this = this as ViewSettings;
  return 'ViewSettings(sort: ${_this.sort}, filter: ${_this.filter}, grid: ${_this.grid})';
}


}

/// @nodoc
abstract mixin class $ViewSettingsCopyWith<$Res>  {
  factory $ViewSettingsCopyWith(ViewSettings value, $Res Function(ViewSettings) _then) = _$ViewSettingsCopyWithImpl;
@useResult
$Res call({
 CollectionSort sort, CompletionFilter filter, bool grid
});




}
/// @nodoc
class _$ViewSettingsCopyWithImpl<$Res>
    implements $ViewSettingsCopyWith<$Res> {
  _$ViewSettingsCopyWithImpl(this._self, this._then);

  final ViewSettings _self;
  final $Res Function(ViewSettings) _then;

/// Create a copy of ViewSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sort = null,Object? filter = null,Object? grid = null,}) {
  return _then(ViewSettings(
sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as CollectionSort,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as CompletionFilter,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ViewSettings].
extension ViewSettingsPatterns on ViewSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ViewSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ViewSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ViewSettings value)  $default,){
final _that = this;
switch (_that) {
case _ViewSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ViewSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ViewSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CollectionSort sort,  CompletionFilter filter,  bool grid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ViewSettings() when $default != null:
return $default(_that.sort,_that.filter,_that.grid);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CollectionSort sort,  CompletionFilter filter,  bool grid)  $default,) {final _that = this;
switch (_that) {
case _ViewSettings():
return $default(_that.sort,_that.filter,_that.grid);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CollectionSort sort,  CompletionFilter filter,  bool grid)?  $default,) {final _that = this;
switch (_that) {
case _ViewSettings() when $default != null:
return $default(_that.sort,_that.filter,_that.grid);case _:
  return null;

}
}

}

/// @nodoc


class _ViewSettings implements ViewSettings {
  const _ViewSettings({this.sort = CollectionSort.title, this.filter = CompletionFilter.all, this.grid = false});
  

@override@JsonKey() final  CollectionSort sort;
@override@JsonKey() final  CompletionFilter filter;
@override@JsonKey() final  bool grid;

/// Create a copy of ViewSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewSettingsCopyWith<_ViewSettings> get copyWith => __$ViewSettingsCopyWithImpl<_ViewSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewSettings&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.grid, grid) || other.grid == grid));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sort,filter,grid);
}

@override
String toString() {
    return 'ViewSettings(sort: $sort, filter: $filter, grid: $grid)';
}


}

/// @nodoc
abstract mixin class _$ViewSettingsCopyWith<$Res> implements $ViewSettingsCopyWith<$Res> {
  factory _$ViewSettingsCopyWith(_ViewSettings value, $Res Function(_ViewSettings) _then) = __$ViewSettingsCopyWithImpl;
@override @useResult
$Res call({
 CollectionSort sort, CompletionFilter filter, bool grid
});




}
/// @nodoc
class __$ViewSettingsCopyWithImpl<$Res>
    implements _$ViewSettingsCopyWith<$Res> {
  __$ViewSettingsCopyWithImpl(this._self, this._then);

  final _ViewSettings _self;
  final $Res Function(_ViewSettings) _then;

/// Create a copy of ViewSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sort = null,Object? filter = null,Object? grid = null,}) {
  return _then(_ViewSettings(
sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as CollectionSort,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as CompletionFilter,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
