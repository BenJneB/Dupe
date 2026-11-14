// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Series {

 String get id; DateTime get createdAt; DateTime get updatedAt; CollectionType get type; String get title; String? get userId; DateTime? get deletedAt; bool get syncPending; String? get originalTitle; List<String> get authors; String? get publisher; String? get collection; PublicationStatus get statusPublication; int? get totalVolumes; String? get coverUrl; String? get description; Map<String, String> get externalIds; bool get followed; String? get notes;
/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeriesCopyWith<Series> get copyWith => _$SeriesCopyWithImpl<Series>(this as Series, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Series;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Series&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.syncPending, _this.syncPending) || other.syncPending == _this.syncPending)&&(identical(other.originalTitle, _this.originalTitle) || other.originalTitle == _this.originalTitle)&&const DeepCollectionEquality().equals(other.authors, _this.authors)&&(identical(other.publisher, _this.publisher) || other.publisher == _this.publisher)&&(identical(other.collection, _this.collection) || other.collection == _this.collection)&&(identical(other.statusPublication, _this.statusPublication) || other.statusPublication == _this.statusPublication)&&(identical(other.totalVolumes, _this.totalVolumes) || other.totalVolumes == _this.totalVolumes)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.description, _this.description) || other.description == _this.description)&&const DeepCollectionEquality().equals(other.externalIds, _this.externalIds)&&(identical(other.followed, _this.followed) || other.followed == _this.followed)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}


@override
int get hashCode {
  final _this = this as Series;
  return Object.hashAll([runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.type,_this.title,_this.userId,_this.deletedAt,_this.syncPending,_this.originalTitle,const DeepCollectionEquality().hash(_this.authors),_this.publisher,_this.collection,_this.statusPublication,_this.totalVolumes,_this.coverUrl,_this.description,const DeepCollectionEquality().hash(_this.externalIds),_this.followed,_this.notes]);
}

@override
String toString() {
  final _this = this as Series;
  return 'Series(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, type: ${_this.type}, title: ${_this.title}, userId: ${_this.userId}, deletedAt: ${_this.deletedAt}, syncPending: ${_this.syncPending}, originalTitle: ${_this.originalTitle}, authors: ${_this.authors}, publisher: ${_this.publisher}, collection: ${_this.collection}, statusPublication: ${_this.statusPublication}, totalVolumes: ${_this.totalVolumes}, coverUrl: ${_this.coverUrl}, description: ${_this.description}, externalIds: ${_this.externalIds}, followed: ${_this.followed}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $SeriesCopyWith<$Res>  {
  factory $SeriesCopyWith(Series value, $Res Function(Series) _then) = _$SeriesCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, CollectionType type, String title, String? userId, DateTime? deletedAt, bool syncPending, String? originalTitle, List<String> authors, String? publisher, String? collection, PublicationStatus statusPublication, int? totalVolumes, String? coverUrl, String? description, Map<String, String> externalIds, bool followed, String? notes
});




}
/// @nodoc
class _$SeriesCopyWithImpl<$Res>
    implements $SeriesCopyWith<$Res> {
  _$SeriesCopyWithImpl(this._self, this._then);

  final Series _self;
  final $Res Function(Series) _then;

/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? type = null,Object? title = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,Object? originalTitle = freezed,Object? authors = null,Object? publisher = freezed,Object? collection = freezed,Object? statusPublication = null,Object? totalVolumes = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? externalIds = null,Object? followed = null,Object? notes = freezed,}) {
  return _then(Series(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CollectionType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,collection: freezed == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as String?,statusPublication: null == statusPublication ? _self.statusPublication : statusPublication // ignore: cast_nullable_to_non_nullable
as PublicationStatus,totalVolumes: freezed == totalVolumes ? _self.totalVolumes : totalVolumes // ignore: cast_nullable_to_non_nullable
as int?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,externalIds: null == externalIds ? _self.externalIds : externalIds // ignore: cast_nullable_to_non_nullable
as Map<String, String>,followed: null == followed ? _self.followed : followed // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Series].
extension SeriesPatterns on Series {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Series value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Series() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Series value)  $default,){
final _that = this;
switch (_that) {
case _Series():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Series value)?  $default,){
final _that = this;
switch (_that) {
case _Series() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  CollectionType type,  String title,  String? userId,  DateTime? deletedAt,  bool syncPending,  String? originalTitle,  List<String> authors,  String? publisher,  String? collection,  PublicationStatus statusPublication,  int? totalVolumes,  String? coverUrl,  String? description,  Map<String, String> externalIds,  bool followed,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Series() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.type,_that.title,_that.userId,_that.deletedAt,_that.syncPending,_that.originalTitle,_that.authors,_that.publisher,_that.collection,_that.statusPublication,_that.totalVolumes,_that.coverUrl,_that.description,_that.externalIds,_that.followed,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  CollectionType type,  String title,  String? userId,  DateTime? deletedAt,  bool syncPending,  String? originalTitle,  List<String> authors,  String? publisher,  String? collection,  PublicationStatus statusPublication,  int? totalVolumes,  String? coverUrl,  String? description,  Map<String, String> externalIds,  bool followed,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _Series():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.type,_that.title,_that.userId,_that.deletedAt,_that.syncPending,_that.originalTitle,_that.authors,_that.publisher,_that.collection,_that.statusPublication,_that.totalVolumes,_that.coverUrl,_that.description,_that.externalIds,_that.followed,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt,  CollectionType type,  String title,  String? userId,  DateTime? deletedAt,  bool syncPending,  String? originalTitle,  List<String> authors,  String? publisher,  String? collection,  PublicationStatus statusPublication,  int? totalVolumes,  String? coverUrl,  String? description,  Map<String, String> externalIds,  bool followed,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _Series() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.type,_that.title,_that.userId,_that.deletedAt,_that.syncPending,_that.originalTitle,_that.authors,_that.publisher,_that.collection,_that.statusPublication,_that.totalVolumes,_that.coverUrl,_that.description,_that.externalIds,_that.followed,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _Series implements Series {
  const _Series({required this.id, required this.createdAt, required this.updatedAt, required this.type, required this.title, this.userId, this.deletedAt, this.syncPending = true, this.originalTitle,  List<String> authors = const <String>[], this.publisher, this.collection, this.statusPublication = PublicationStatus.inconnue, this.totalVolumes, this.coverUrl, this.description,  Map<String, String> externalIds = const <String, String>{}, this.followed = true, this.notes}): _authors = authors,_externalIds = externalIds;
  

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  CollectionType type;
@override final  String title;
@override final  String? userId;
@override final  DateTime? deletedAt;
@override@JsonKey() final  bool syncPending;
@override final  String? originalTitle;
 final  List<String> _authors;
@override@JsonKey() List<String> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

@override final  String? publisher;
@override final  String? collection;
@override@JsonKey() final  PublicationStatus statusPublication;
@override final  int? totalVolumes;
@override final  String? coverUrl;
@override final  String? description;
 final  Map<String, String> _externalIds;
@override@JsonKey() Map<String, String> get externalIds {
  if (_externalIds is EqualUnmodifiableMapView) return _externalIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_externalIds);
}

@override@JsonKey() final  bool followed;
@override final  String? notes;

/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeriesCopyWith<_Series> get copyWith => __$SeriesCopyWithImpl<_Series>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Series&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncPending, syncPending) || other.syncPending == syncPending)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&const DeepCollectionEquality().equals(other.authors, _authors)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.collection, collection) || other.collection == collection)&&(identical(other.statusPublication, statusPublication) || other.statusPublication == statusPublication)&&(identical(other.totalVolumes, totalVolumes) || other.totalVolumes == totalVolumes)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.externalIds, _externalIds)&&(identical(other.followed, followed) || other.followed == followed)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,id,createdAt,updatedAt,type,title,userId,deletedAt,syncPending,originalTitle,const DeepCollectionEquality().hash(_authors),publisher,collection,statusPublication,totalVolumes,coverUrl,description,const DeepCollectionEquality().hash(_externalIds),followed,notes]);
}

@override
String toString() {
    return 'Series(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, type: $type, title: $title, userId: $userId, deletedAt: $deletedAt, syncPending: $syncPending, originalTitle: $originalTitle, authors: $authors, publisher: $publisher, collection: $collection, statusPublication: $statusPublication, totalVolumes: $totalVolumes, coverUrl: $coverUrl, description: $description, externalIds: $externalIds, followed: $followed, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$SeriesCopyWith<$Res> implements $SeriesCopyWith<$Res> {
  factory _$SeriesCopyWith(_Series value, $Res Function(_Series) _then) = __$SeriesCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, CollectionType type, String title, String? userId, DateTime? deletedAt, bool syncPending, String? originalTitle, List<String> authors, String? publisher, String? collection, PublicationStatus statusPublication, int? totalVolumes, String? coverUrl, String? description, Map<String, String> externalIds, bool followed, String? notes
});




}
/// @nodoc
class __$SeriesCopyWithImpl<$Res>
    implements _$SeriesCopyWith<$Res> {
  __$SeriesCopyWithImpl(this._self, this._then);

  final _Series _self;
  final $Res Function(_Series) _then;

/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? type = null,Object? title = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,Object? originalTitle = freezed,Object? authors = null,Object? publisher = freezed,Object? collection = freezed,Object? statusPublication = null,Object? totalVolumes = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? externalIds = null,Object? followed = null,Object? notes = freezed,}) {
  return _then(_Series(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CollectionType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,collection: freezed == collection ? _self.collection : collection // ignore: cast_nullable_to_non_nullable
as String?,statusPublication: null == statusPublication ? _self.statusPublication : statusPublication // ignore: cast_nullable_to_non_nullable
as PublicationStatus,totalVolumes: freezed == totalVolumes ? _self.totalVolumes : totalVolumes // ignore: cast_nullable_to_non_nullable
as int?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,externalIds: null == externalIds ? _self._externalIds : externalIds // ignore: cast_nullable_to_non_nullable
as Map<String, String>,followed: null == followed ? _self.followed : followed // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
