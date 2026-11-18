// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ItemPhoto {

 String get id; DateTime get createdAt; DateTime get updatedAt; String get itemId; String get url; PhotoKind get kind; int get position; String? get userId; DateTime? get deletedAt; bool get syncPending;
/// Create a copy of ItemPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemPhotoCopyWith<ItemPhoto> get copyWith => _$ItemPhotoCopyWithImpl<ItemPhoto>(this as ItemPhoto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ItemPhoto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemPhoto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.syncPending, _this.syncPending) || other.syncPending == _this.syncPending));
}


@override
int get hashCode {
  final _this = this as ItemPhoto;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.itemId,_this.url,_this.kind,_this.position,_this.userId,_this.deletedAt,_this.syncPending);
}

@override
String toString() {
  final _this = this as ItemPhoto;
  return 'ItemPhoto(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, itemId: ${_this.itemId}, url: ${_this.url}, kind: ${_this.kind}, position: ${_this.position}, userId: ${_this.userId}, deletedAt: ${_this.deletedAt}, syncPending: ${_this.syncPending})';
}


}

/// @nodoc
abstract mixin class $ItemPhotoCopyWith<$Res>  {
  factory $ItemPhotoCopyWith(ItemPhoto value, $Res Function(ItemPhoto) _then) = _$ItemPhotoCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String itemId, String url, PhotoKind kind, int position, String? userId, DateTime? deletedAt, bool syncPending
});




}
/// @nodoc
class _$ItemPhotoCopyWithImpl<$Res>
    implements $ItemPhotoCopyWith<$Res> {
  _$ItemPhotoCopyWithImpl(this._self, this._then);

  final ItemPhoto _self;
  final $Res Function(ItemPhoto) _then;

/// Create a copy of ItemPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? itemId = null,Object? url = null,Object? kind = null,Object? position = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,}) {
  return _then(ItemPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PhotoKind,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemPhoto].
extension ItemPhotoPatterns on ItemPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemPhoto value)  $default,){
final _that = this;
switch (_that) {
case _ItemPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String itemId,  String url,  PhotoKind kind,  int position,  String? userId,  DateTime? deletedAt,  bool syncPending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemPhoto() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.itemId,_that.url,_that.kind,_that.position,_that.userId,_that.deletedAt,_that.syncPending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String itemId,  String url,  PhotoKind kind,  int position,  String? userId,  DateTime? deletedAt,  bool syncPending)  $default,) {final _that = this;
switch (_that) {
case _ItemPhoto():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.itemId,_that.url,_that.kind,_that.position,_that.userId,_that.deletedAt,_that.syncPending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt,  String itemId,  String url,  PhotoKind kind,  int position,  String? userId,  DateTime? deletedAt,  bool syncPending)?  $default,) {final _that = this;
switch (_that) {
case _ItemPhoto() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.itemId,_that.url,_that.kind,_that.position,_that.userId,_that.deletedAt,_that.syncPending);case _:
  return null;

}
}

}

/// @nodoc


class _ItemPhoto implements ItemPhoto {
  const _ItemPhoto({required this.id, required this.createdAt, required this.updatedAt, required this.itemId, required this.url, this.kind = PhotoKind.dedicace, this.position = 0, this.userId, this.deletedAt, this.syncPending = true});
  

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String itemId;
@override final  String url;
@override@JsonKey() final  PhotoKind kind;
@override@JsonKey() final  int position;
@override final  String? userId;
@override final  DateTime? deletedAt;
@override@JsonKey() final  bool syncPending;

/// Create a copy of ItemPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemPhotoCopyWith<_ItemPhoto> get copyWith => __$ItemPhotoCopyWithImpl<_ItemPhoto>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.url, url) || other.url == url)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.position, position) || other.position == position)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncPending, syncPending) || other.syncPending == syncPending));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,itemId,url,kind,position,userId,deletedAt,syncPending);
}

@override
String toString() {
    return 'ItemPhoto(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, itemId: $itemId, url: $url, kind: $kind, position: $position, userId: $userId, deletedAt: $deletedAt, syncPending: $syncPending)';
}


}

/// @nodoc
abstract mixin class _$ItemPhotoCopyWith<$Res> implements $ItemPhotoCopyWith<$Res> {
  factory _$ItemPhotoCopyWith(_ItemPhoto value, $Res Function(_ItemPhoto) _then) = __$ItemPhotoCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String itemId, String url, PhotoKind kind, int position, String? userId, DateTime? deletedAt, bool syncPending
});




}
/// @nodoc
class __$ItemPhotoCopyWithImpl<$Res>
    implements _$ItemPhotoCopyWith<$Res> {
  __$ItemPhotoCopyWithImpl(this._self, this._then);

  final _ItemPhoto _self;
  final $Res Function(_ItemPhoto) _then;

/// Create a copy of ItemPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? itemId = null,Object? url = null,Object? kind = null,Object? position = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,}) {
  return _then(_ItemPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PhotoKind,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
