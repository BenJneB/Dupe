// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_feedback.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecommendationFeedback {

 String get id; DateTime get createdAt; DateTime get updatedAt;/// `Suggestion.key` of the dismissed suggestion.
 String get suggestionKey;/// Its reason (`SuggestionReason.kind` name and key): each dismissal
/// lowers the weight of that reason.
 String get reasonKind; String get reasonKey; String? get userId; DateTime? get deletedAt; bool get syncPending;
/// Create a copy of RecommendationFeedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationFeedbackCopyWith<RecommendationFeedback> get copyWith => _$RecommendationFeedbackCopyWithImpl<RecommendationFeedback>(this as RecommendationFeedback, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecommendationFeedback;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendationFeedback&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.suggestionKey, _this.suggestionKey) || other.suggestionKey == _this.suggestionKey)&&(identical(other.reasonKind, _this.reasonKind) || other.reasonKind == _this.reasonKind)&&(identical(other.reasonKey, _this.reasonKey) || other.reasonKey == _this.reasonKey)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.syncPending, _this.syncPending) || other.syncPending == _this.syncPending));
}


@override
int get hashCode {
  final _this = this as RecommendationFeedback;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.suggestionKey,_this.reasonKind,_this.reasonKey,_this.userId,_this.deletedAt,_this.syncPending);
}

@override
String toString() {
  final _this = this as RecommendationFeedback;
  return 'RecommendationFeedback(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, suggestionKey: ${_this.suggestionKey}, reasonKind: ${_this.reasonKind}, reasonKey: ${_this.reasonKey}, userId: ${_this.userId}, deletedAt: ${_this.deletedAt}, syncPending: ${_this.syncPending})';
}


}

/// @nodoc
abstract mixin class $RecommendationFeedbackCopyWith<$Res>  {
  factory $RecommendationFeedbackCopyWith(RecommendationFeedback value, $Res Function(RecommendationFeedback) _then) = _$RecommendationFeedbackCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String suggestionKey, String reasonKind, String reasonKey, String? userId, DateTime? deletedAt, bool syncPending
});




}
/// @nodoc
class _$RecommendationFeedbackCopyWithImpl<$Res>
    implements $RecommendationFeedbackCopyWith<$Res> {
  _$RecommendationFeedbackCopyWithImpl(this._self, this._then);

  final RecommendationFeedback _self;
  final $Res Function(RecommendationFeedback) _then;

/// Create a copy of RecommendationFeedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? suggestionKey = null,Object? reasonKind = null,Object? reasonKey = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,}) {
  return _then(RecommendationFeedback(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,suggestionKey: null == suggestionKey ? _self.suggestionKey : suggestionKey // ignore: cast_nullable_to_non_nullable
as String,reasonKind: null == reasonKind ? _self.reasonKind : reasonKind // ignore: cast_nullable_to_non_nullable
as String,reasonKey: null == reasonKey ? _self.reasonKey : reasonKey // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecommendationFeedback].
extension RecommendationFeedbackPatterns on RecommendationFeedback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendationFeedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendationFeedback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendationFeedback value)  $default,){
final _that = this;
switch (_that) {
case _RecommendationFeedback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendationFeedback value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendationFeedback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String suggestionKey,  String reasonKind,  String reasonKey,  String? userId,  DateTime? deletedAt,  bool syncPending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendationFeedback() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.suggestionKey,_that.reasonKind,_that.reasonKey,_that.userId,_that.deletedAt,_that.syncPending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String suggestionKey,  String reasonKind,  String reasonKey,  String? userId,  DateTime? deletedAt,  bool syncPending)  $default,) {final _that = this;
switch (_that) {
case _RecommendationFeedback():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.suggestionKey,_that.reasonKind,_that.reasonKey,_that.userId,_that.deletedAt,_that.syncPending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt,  String suggestionKey,  String reasonKind,  String reasonKey,  String? userId,  DateTime? deletedAt,  bool syncPending)?  $default,) {final _that = this;
switch (_that) {
case _RecommendationFeedback() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.suggestionKey,_that.reasonKind,_that.reasonKey,_that.userId,_that.deletedAt,_that.syncPending);case _:
  return null;

}
}

}

/// @nodoc


class _RecommendationFeedback implements RecommendationFeedback {
  const _RecommendationFeedback({required this.id, required this.createdAt, required this.updatedAt, required this.suggestionKey, required this.reasonKind, required this.reasonKey, this.userId, this.deletedAt, this.syncPending = true});
  

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// `Suggestion.key` of the dismissed suggestion.
@override final  String suggestionKey;
/// Its reason (`SuggestionReason.kind` name and key): each dismissal
/// lowers the weight of that reason.
@override final  String reasonKind;
@override final  String reasonKey;
@override final  String? userId;
@override final  DateTime? deletedAt;
@override@JsonKey() final  bool syncPending;

/// Create a copy of RecommendationFeedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationFeedbackCopyWith<_RecommendationFeedback> get copyWith => __$RecommendationFeedbackCopyWithImpl<_RecommendationFeedback>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendationFeedback&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.suggestionKey, suggestionKey) || other.suggestionKey == suggestionKey)&&(identical(other.reasonKind, reasonKind) || other.reasonKind == reasonKind)&&(identical(other.reasonKey, reasonKey) || other.reasonKey == reasonKey)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncPending, syncPending) || other.syncPending == syncPending));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,suggestionKey,reasonKind,reasonKey,userId,deletedAt,syncPending);
}

@override
String toString() {
    return 'RecommendationFeedback(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, suggestionKey: $suggestionKey, reasonKind: $reasonKind, reasonKey: $reasonKey, userId: $userId, deletedAt: $deletedAt, syncPending: $syncPending)';
}


}

/// @nodoc
abstract mixin class _$RecommendationFeedbackCopyWith<$Res> implements $RecommendationFeedbackCopyWith<$Res> {
  factory _$RecommendationFeedbackCopyWith(_RecommendationFeedback value, $Res Function(_RecommendationFeedback) _then) = __$RecommendationFeedbackCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String suggestionKey, String reasonKind, String reasonKey, String? userId, DateTime? deletedAt, bool syncPending
});




}
/// @nodoc
class __$RecommendationFeedbackCopyWithImpl<$Res>
    implements _$RecommendationFeedbackCopyWith<$Res> {
  __$RecommendationFeedbackCopyWithImpl(this._self, this._then);

  final _RecommendationFeedback _self;
  final $Res Function(_RecommendationFeedback) _then;

/// Create a copy of RecommendationFeedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? suggestionKey = null,Object? reasonKind = null,Object? reasonKey = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,}) {
  return _then(_RecommendationFeedback(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,suggestionKey: null == suggestionKey ? _self.suggestionKey : suggestionKey // ignore: cast_nullable_to_non_nullable
as String,reasonKind: null == reasonKind ? _self.reasonKind : reasonKind // ignore: cast_nullable_to_non_nullable
as String,reasonKey: null == reasonKey ? _self.reasonKey : reasonKey // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
