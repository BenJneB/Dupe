// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'release_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReleaseAlert {

 String get id; DateTime get createdAt; DateTime get updatedAt;/// `series:<series id>:<number>` or `isbn:<isbn>`.
 String get key; AlertKind get kind; CollectionType get type; String get title; AlertStatus get status; String? get seriesId; String? get volumeNumber; String? get authorName; List<String> get authors; String? get isbn13; String? get publisher; String? get publishDate; String? get coverUrl; String? get userId; DateTime? get deletedAt; bool get syncPending;
/// Create a copy of ReleaseAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReleaseAlertCopyWith<ReleaseAlert> get copyWith => _$ReleaseAlertCopyWithImpl<ReleaseAlert>(this as ReleaseAlert, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReleaseAlert;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReleaseAlert&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.seriesId, _this.seriesId) || other.seriesId == _this.seriesId)&&(identical(other.volumeNumber, _this.volumeNumber) || other.volumeNumber == _this.volumeNumber)&&(identical(other.authorName, _this.authorName) || other.authorName == _this.authorName)&&const DeepCollectionEquality().equals(other.authors, _this.authors)&&(identical(other.isbn13, _this.isbn13) || other.isbn13 == _this.isbn13)&&(identical(other.publisher, _this.publisher) || other.publisher == _this.publisher)&&(identical(other.publishDate, _this.publishDate) || other.publishDate == _this.publishDate)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.syncPending, _this.syncPending) || other.syncPending == _this.syncPending));
}


@override
int get hashCode {
  final _this = this as ReleaseAlert;
  return Object.hashAll([runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.key,_this.kind,_this.type,_this.title,_this.status,_this.seriesId,_this.volumeNumber,_this.authorName,const DeepCollectionEquality().hash(_this.authors),_this.isbn13,_this.publisher,_this.publishDate,_this.coverUrl,_this.userId,_this.deletedAt,_this.syncPending]);
}

@override
String toString() {
  final _this = this as ReleaseAlert;
  return 'ReleaseAlert(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, key: ${_this.key}, kind: ${_this.kind}, type: ${_this.type}, title: ${_this.title}, status: ${_this.status}, seriesId: ${_this.seriesId}, volumeNumber: ${_this.volumeNumber}, authorName: ${_this.authorName}, authors: ${_this.authors}, isbn13: ${_this.isbn13}, publisher: ${_this.publisher}, publishDate: ${_this.publishDate}, coverUrl: ${_this.coverUrl}, userId: ${_this.userId}, deletedAt: ${_this.deletedAt}, syncPending: ${_this.syncPending})';
}


}

/// @nodoc
abstract mixin class $ReleaseAlertCopyWith<$Res>  {
  factory $ReleaseAlertCopyWith(ReleaseAlert value, $Res Function(ReleaseAlert) _then) = _$ReleaseAlertCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String key, AlertKind kind, CollectionType type, String title, AlertStatus status, String? seriesId, String? volumeNumber, String? authorName, List<String> authors, String? isbn13, String? publisher, String? publishDate, String? coverUrl, String? userId, DateTime? deletedAt, bool syncPending
});




}
/// @nodoc
class _$ReleaseAlertCopyWithImpl<$Res>
    implements $ReleaseAlertCopyWith<$Res> {
  _$ReleaseAlertCopyWithImpl(this._self, this._then);

  final ReleaseAlert _self;
  final $Res Function(ReleaseAlert) _then;

/// Create a copy of ReleaseAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? key = null,Object? kind = null,Object? type = null,Object? title = null,Object? status = null,Object? seriesId = freezed,Object? volumeNumber = freezed,Object? authorName = freezed,Object? authors = null,Object? isbn13 = freezed,Object? publisher = freezed,Object? publishDate = freezed,Object? coverUrl = freezed,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,}) {
  return _then(ReleaseAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AlertKind,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CollectionType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertStatus,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String?,volumeNumber: freezed == volumeNumber ? _self.volumeNumber : volumeNumber // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,publishDate: freezed == publishDate ? _self.publishDate : publishDate // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReleaseAlert].
extension ReleaseAlertPatterns on ReleaseAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReleaseAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReleaseAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReleaseAlert value)  $default,){
final _that = this;
switch (_that) {
case _ReleaseAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReleaseAlert value)?  $default,){
final _that = this;
switch (_that) {
case _ReleaseAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String key,  AlertKind kind,  CollectionType type,  String title,  AlertStatus status,  String? seriesId,  String? volumeNumber,  String? authorName,  List<String> authors,  String? isbn13,  String? publisher,  String? publishDate,  String? coverUrl,  String? userId,  DateTime? deletedAt,  bool syncPending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReleaseAlert() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.key,_that.kind,_that.type,_that.title,_that.status,_that.seriesId,_that.volumeNumber,_that.authorName,_that.authors,_that.isbn13,_that.publisher,_that.publishDate,_that.coverUrl,_that.userId,_that.deletedAt,_that.syncPending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String key,  AlertKind kind,  CollectionType type,  String title,  AlertStatus status,  String? seriesId,  String? volumeNumber,  String? authorName,  List<String> authors,  String? isbn13,  String? publisher,  String? publishDate,  String? coverUrl,  String? userId,  DateTime? deletedAt,  bool syncPending)  $default,) {final _that = this;
switch (_that) {
case _ReleaseAlert():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.key,_that.kind,_that.type,_that.title,_that.status,_that.seriesId,_that.volumeNumber,_that.authorName,_that.authors,_that.isbn13,_that.publisher,_that.publishDate,_that.coverUrl,_that.userId,_that.deletedAt,_that.syncPending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt,  String key,  AlertKind kind,  CollectionType type,  String title,  AlertStatus status,  String? seriesId,  String? volumeNumber,  String? authorName,  List<String> authors,  String? isbn13,  String? publisher,  String? publishDate,  String? coverUrl,  String? userId,  DateTime? deletedAt,  bool syncPending)?  $default,) {final _that = this;
switch (_that) {
case _ReleaseAlert() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.key,_that.kind,_that.type,_that.title,_that.status,_that.seriesId,_that.volumeNumber,_that.authorName,_that.authors,_that.isbn13,_that.publisher,_that.publishDate,_that.coverUrl,_that.userId,_that.deletedAt,_that.syncPending);case _:
  return null;

}
}

}

/// @nodoc


class _ReleaseAlert implements ReleaseAlert {
  const _ReleaseAlert({required this.id, required this.createdAt, required this.updatedAt, required this.key, required this.kind, required this.type, required this.title, this.status = AlertStatus.nouveau, this.seriesId, this.volumeNumber, this.authorName,  List<String> authors = const <String>[], this.isbn13, this.publisher, this.publishDate, this.coverUrl, this.userId, this.deletedAt, this.syncPending = true}): _authors = authors;
  

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// `series:<series id>:<number>` or `isbn:<isbn>`.
@override final  String key;
@override final  AlertKind kind;
@override final  CollectionType type;
@override final  String title;
@override@JsonKey() final  AlertStatus status;
@override final  String? seriesId;
@override final  String? volumeNumber;
@override final  String? authorName;
 final  List<String> _authors;
@override@JsonKey() List<String> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

@override final  String? isbn13;
@override final  String? publisher;
@override final  String? publishDate;
@override final  String? coverUrl;
@override final  String? userId;
@override final  DateTime? deletedAt;
@override@JsonKey() final  bool syncPending;

/// Create a copy of ReleaseAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReleaseAlertCopyWith<_ReleaseAlert> get copyWith => __$ReleaseAlertCopyWithImpl<_ReleaseAlert>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReleaseAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.key, key) || other.key == key)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.volumeNumber, volumeNumber) || other.volumeNumber == volumeNumber)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&const DeepCollectionEquality().equals(other.authors, _authors)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.publishDate, publishDate) || other.publishDate == publishDate)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncPending, syncPending) || other.syncPending == syncPending));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,id,createdAt,updatedAt,key,kind,type,title,status,seriesId,volumeNumber,authorName,const DeepCollectionEquality().hash(_authors),isbn13,publisher,publishDate,coverUrl,userId,deletedAt,syncPending]);
}

@override
String toString() {
    return 'ReleaseAlert(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, key: $key, kind: $kind, type: $type, title: $title, status: $status, seriesId: $seriesId, volumeNumber: $volumeNumber, authorName: $authorName, authors: $authors, isbn13: $isbn13, publisher: $publisher, publishDate: $publishDate, coverUrl: $coverUrl, userId: $userId, deletedAt: $deletedAt, syncPending: $syncPending)';
}


}

/// @nodoc
abstract mixin class _$ReleaseAlertCopyWith<$Res> implements $ReleaseAlertCopyWith<$Res> {
  factory _$ReleaseAlertCopyWith(_ReleaseAlert value, $Res Function(_ReleaseAlert) _then) = __$ReleaseAlertCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String key, AlertKind kind, CollectionType type, String title, AlertStatus status, String? seriesId, String? volumeNumber, String? authorName, List<String> authors, String? isbn13, String? publisher, String? publishDate, String? coverUrl, String? userId, DateTime? deletedAt, bool syncPending
});




}
/// @nodoc
class __$ReleaseAlertCopyWithImpl<$Res>
    implements _$ReleaseAlertCopyWith<$Res> {
  __$ReleaseAlertCopyWithImpl(this._self, this._then);

  final _ReleaseAlert _self;
  final $Res Function(_ReleaseAlert) _then;

/// Create a copy of ReleaseAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? key = null,Object? kind = null,Object? type = null,Object? title = null,Object? status = null,Object? seriesId = freezed,Object? volumeNumber = freezed,Object? authorName = freezed,Object? authors = null,Object? isbn13 = freezed,Object? publisher = freezed,Object? publishDate = freezed,Object? coverUrl = freezed,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,}) {
  return _then(_ReleaseAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AlertKind,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CollectionType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AlertStatus,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String?,volumeNumber: freezed == volumeNumber ? _self.volumeNumber : volumeNumber // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,publishDate: freezed == publishDate ? _self.publishDate : publishDate // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$FollowedAuthor {

 String get id; DateTime get createdAt; DateTime get updatedAt; String get name; String? get userId; DateTime? get deletedAt; bool get syncPending;
/// Create a copy of FollowedAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowedAuthorCopyWith<FollowedAuthor> get copyWith => _$FollowedAuthorCopyWithImpl<FollowedAuthor>(this as FollowedAuthor, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FollowedAuthor;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowedAuthor&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.syncPending, _this.syncPending) || other.syncPending == _this.syncPending));
}


@override
int get hashCode {
  final _this = this as FollowedAuthor;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.name,_this.userId,_this.deletedAt,_this.syncPending);
}

@override
String toString() {
  final _this = this as FollowedAuthor;
  return 'FollowedAuthor(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, name: ${_this.name}, userId: ${_this.userId}, deletedAt: ${_this.deletedAt}, syncPending: ${_this.syncPending})';
}


}

/// @nodoc
abstract mixin class $FollowedAuthorCopyWith<$Res>  {
  factory $FollowedAuthorCopyWith(FollowedAuthor value, $Res Function(FollowedAuthor) _then) = _$FollowedAuthorCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String name, String? userId, DateTime? deletedAt, bool syncPending
});




}
/// @nodoc
class _$FollowedAuthorCopyWithImpl<$Res>
    implements $FollowedAuthorCopyWith<$Res> {
  _$FollowedAuthorCopyWithImpl(this._self, this._then);

  final FollowedAuthor _self;
  final $Res Function(FollowedAuthor) _then;

/// Create a copy of FollowedAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? name = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,}) {
  return _then(FollowedAuthor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowedAuthor].
extension FollowedAuthorPatterns on FollowedAuthor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowedAuthor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowedAuthor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowedAuthor value)  $default,){
final _that = this;
switch (_that) {
case _FollowedAuthor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowedAuthor value)?  $default,){
final _that = this;
switch (_that) {
case _FollowedAuthor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String name,  String? userId,  DateTime? deletedAt,  bool syncPending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowedAuthor() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.name,_that.userId,_that.deletedAt,_that.syncPending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String name,  String? userId,  DateTime? deletedAt,  bool syncPending)  $default,) {final _that = this;
switch (_that) {
case _FollowedAuthor():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.name,_that.userId,_that.deletedAt,_that.syncPending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt,  String name,  String? userId,  DateTime? deletedAt,  bool syncPending)?  $default,) {final _that = this;
switch (_that) {
case _FollowedAuthor() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.name,_that.userId,_that.deletedAt,_that.syncPending);case _:
  return null;

}
}

}

/// @nodoc


class _FollowedAuthor implements FollowedAuthor {
  const _FollowedAuthor({required this.id, required this.createdAt, required this.updatedAt, required this.name, this.userId, this.deletedAt, this.syncPending = true});
  

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String name;
@override final  String? userId;
@override final  DateTime? deletedAt;
@override@JsonKey() final  bool syncPending;

/// Create a copy of FollowedAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowedAuthorCopyWith<_FollowedAuthor> get copyWith => __$FollowedAuthorCopyWithImpl<_FollowedAuthor>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowedAuthor&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncPending, syncPending) || other.syncPending == syncPending));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,name,userId,deletedAt,syncPending);
}

@override
String toString() {
    return 'FollowedAuthor(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, userId: $userId, deletedAt: $deletedAt, syncPending: $syncPending)';
}


}

/// @nodoc
abstract mixin class _$FollowedAuthorCopyWith<$Res> implements $FollowedAuthorCopyWith<$Res> {
  factory _$FollowedAuthorCopyWith(_FollowedAuthor value, $Res Function(_FollowedAuthor) _then) = __$FollowedAuthorCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String name, String? userId, DateTime? deletedAt, bool syncPending
});




}
/// @nodoc
class __$FollowedAuthorCopyWithImpl<$Res>
    implements _$FollowedAuthorCopyWith<$Res> {
  __$FollowedAuthorCopyWithImpl(this._self, this._then);

  final _FollowedAuthor _self;
  final $Res Function(_FollowedAuthor) _then;

/// Create a copy of FollowedAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? name = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,}) {
  return _then(_FollowedAuthor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
