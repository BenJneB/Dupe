// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'series_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeriesMetadata {

 SeriesSource get source; String get sourceId; String get title; String? get originalTitle; List<String> get authors; String? get publisher; int? get totalVolumes; PublicationStatus get status; int? get startYear; String? get coverUrl; String? get description; String? get siteUrl;
/// Create a copy of SeriesMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeriesMetadataCopyWith<SeriesMetadata> get copyWith => _$SeriesMetadataCopyWithImpl<SeriesMetadata>(this as SeriesMetadata, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SeriesMetadata;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeriesMetadata&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.sourceId, _this.sourceId) || other.sourceId == _this.sourceId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.originalTitle, _this.originalTitle) || other.originalTitle == _this.originalTitle)&&const DeepCollectionEquality().equals(other.authors, _this.authors)&&(identical(other.publisher, _this.publisher) || other.publisher == _this.publisher)&&(identical(other.totalVolumes, _this.totalVolumes) || other.totalVolumes == _this.totalVolumes)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startYear, _this.startYear) || other.startYear == _this.startYear)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.siteUrl, _this.siteUrl) || other.siteUrl == _this.siteUrl));
}


@override
int get hashCode {
  final _this = this as SeriesMetadata;
  return Object.hash(runtimeType,_this.source,_this.sourceId,_this.title,_this.originalTitle,const DeepCollectionEquality().hash(_this.authors),_this.publisher,_this.totalVolumes,_this.status,_this.startYear,_this.coverUrl,_this.description,_this.siteUrl);
}

@override
String toString() {
  final _this = this as SeriesMetadata;
  return 'SeriesMetadata(source: ${_this.source}, sourceId: ${_this.sourceId}, title: ${_this.title}, originalTitle: ${_this.originalTitle}, authors: ${_this.authors}, publisher: ${_this.publisher}, totalVolumes: ${_this.totalVolumes}, status: ${_this.status}, startYear: ${_this.startYear}, coverUrl: ${_this.coverUrl}, description: ${_this.description}, siteUrl: ${_this.siteUrl})';
}


}

/// @nodoc
abstract mixin class $SeriesMetadataCopyWith<$Res>  {
  factory $SeriesMetadataCopyWith(SeriesMetadata value, $Res Function(SeriesMetadata) _then) = _$SeriesMetadataCopyWithImpl;
@useResult
$Res call({
 SeriesSource source, String sourceId, String title, String? originalTitle, List<String> authors, String? publisher, int? totalVolumes, PublicationStatus status, int? startYear, String? coverUrl, String? description, String? siteUrl
});




}
/// @nodoc
class _$SeriesMetadataCopyWithImpl<$Res>
    implements $SeriesMetadataCopyWith<$Res> {
  _$SeriesMetadataCopyWithImpl(this._self, this._then);

  final SeriesMetadata _self;
  final $Res Function(SeriesMetadata) _then;

/// Create a copy of SeriesMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? sourceId = null,Object? title = null,Object? originalTitle = freezed,Object? authors = null,Object? publisher = freezed,Object? totalVolumes = freezed,Object? status = null,Object? startYear = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? siteUrl = freezed,}) {
  return _then(SeriesMetadata(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as SeriesSource,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,totalVolumes: freezed == totalVolumes ? _self.totalVolumes : totalVolumes // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PublicationStatus,startYear: freezed == startYear ? _self.startYear : startYear // ignore: cast_nullable_to_non_nullable
as int?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,siteUrl: freezed == siteUrl ? _self.siteUrl : siteUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SeriesMetadata].
extension SeriesMetadataPatterns on SeriesMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeriesMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeriesMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeriesMetadata value)  $default,){
final _that = this;
switch (_that) {
case _SeriesMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeriesMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _SeriesMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SeriesSource source,  String sourceId,  String title,  String? originalTitle,  List<String> authors,  String? publisher,  int? totalVolumes,  PublicationStatus status,  int? startYear,  String? coverUrl,  String? description,  String? siteUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeriesMetadata() when $default != null:
return $default(_that.source,_that.sourceId,_that.title,_that.originalTitle,_that.authors,_that.publisher,_that.totalVolumes,_that.status,_that.startYear,_that.coverUrl,_that.description,_that.siteUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SeriesSource source,  String sourceId,  String title,  String? originalTitle,  List<String> authors,  String? publisher,  int? totalVolumes,  PublicationStatus status,  int? startYear,  String? coverUrl,  String? description,  String? siteUrl)  $default,) {final _that = this;
switch (_that) {
case _SeriesMetadata():
return $default(_that.source,_that.sourceId,_that.title,_that.originalTitle,_that.authors,_that.publisher,_that.totalVolumes,_that.status,_that.startYear,_that.coverUrl,_that.description,_that.siteUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SeriesSource source,  String sourceId,  String title,  String? originalTitle,  List<String> authors,  String? publisher,  int? totalVolumes,  PublicationStatus status,  int? startYear,  String? coverUrl,  String? description,  String? siteUrl)?  $default,) {final _that = this;
switch (_that) {
case _SeriesMetadata() when $default != null:
return $default(_that.source,_that.sourceId,_that.title,_that.originalTitle,_that.authors,_that.publisher,_that.totalVolumes,_that.status,_that.startYear,_that.coverUrl,_that.description,_that.siteUrl);case _:
  return null;

}
}

}

/// @nodoc


class _SeriesMetadata implements SeriesMetadata {
  const _SeriesMetadata({required this.source, required this.sourceId, required this.title, this.originalTitle,  List<String> authors = const <String>[], this.publisher, this.totalVolumes, this.status = PublicationStatus.inconnue, this.startYear, this.coverUrl, this.description, this.siteUrl}): _authors = authors;
  

@override final  SeriesSource source;
@override final  String sourceId;
@override final  String title;
@override final  String? originalTitle;
 final  List<String> _authors;
@override@JsonKey() List<String> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

@override final  String? publisher;
@override final  int? totalVolumes;
@override@JsonKey() final  PublicationStatus status;
@override final  int? startYear;
@override final  String? coverUrl;
@override final  String? description;
@override final  String? siteUrl;

/// Create a copy of SeriesMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeriesMetadataCopyWith<_SeriesMetadata> get copyWith => __$SeriesMetadataCopyWithImpl<_SeriesMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeriesMetadata&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&const DeepCollectionEquality().equals(other.authors, _authors)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.totalVolumes, totalVolumes) || other.totalVolumes == totalVolumes)&&(identical(other.status, status) || other.status == status)&&(identical(other.startYear, startYear) || other.startYear == startYear)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.siteUrl, siteUrl) || other.siteUrl == siteUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,source,sourceId,title,originalTitle,const DeepCollectionEquality().hash(_authors),publisher,totalVolumes,status,startYear,coverUrl,description,siteUrl);
}

@override
String toString() {
    return 'SeriesMetadata(source: $source, sourceId: $sourceId, title: $title, originalTitle: $originalTitle, authors: $authors, publisher: $publisher, totalVolumes: $totalVolumes, status: $status, startYear: $startYear, coverUrl: $coverUrl, description: $description, siteUrl: $siteUrl)';
}


}

/// @nodoc
abstract mixin class _$SeriesMetadataCopyWith<$Res> implements $SeriesMetadataCopyWith<$Res> {
  factory _$SeriesMetadataCopyWith(_SeriesMetadata value, $Res Function(_SeriesMetadata) _then) = __$SeriesMetadataCopyWithImpl;
@override @useResult
$Res call({
 SeriesSource source, String sourceId, String title, String? originalTitle, List<String> authors, String? publisher, int? totalVolumes, PublicationStatus status, int? startYear, String? coverUrl, String? description, String? siteUrl
});




}
/// @nodoc
class __$SeriesMetadataCopyWithImpl<$Res>
    implements _$SeriesMetadataCopyWith<$Res> {
  __$SeriesMetadataCopyWithImpl(this._self, this._then);

  final _SeriesMetadata _self;
  final $Res Function(_SeriesMetadata) _then;

/// Create a copy of SeriesMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? sourceId = null,Object? title = null,Object? originalTitle = freezed,Object? authors = null,Object? publisher = freezed,Object? totalVolumes = freezed,Object? status = null,Object? startYear = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? siteUrl = freezed,}) {
  return _then(_SeriesMetadata(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as SeriesSource,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,totalVolumes: freezed == totalVolumes ? _self.totalVolumes : totalVolumes // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PublicationStatus,startYear: freezed == startYear ? _self.startYear : startYear // ignore: cast_nullable_to_non_nullable
as int?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,siteUrl: freezed == siteUrl ? _self.siteUrl : siteUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
