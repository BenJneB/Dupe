// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metadata_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MetadataResult {

 MetadataSource get source; String get sourceId; String get title; String? get subtitle; List<String> get authors; String? get publisher;/// Free text: "2022", "2021-08-26"…
 String? get publishDate; int? get pageCount;/// ISO 639-1 code ("fr").
 String? get language; String? get isbn13; String? get coverUrl; String? get description;/// Series the volume belongs to, and its number ("1", "HS 2").
 String? get seriesTitle; String? get volumeNumber; double? get coverPrice; String? get currency;
/// Create a copy of MetadataResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetadataResultCopyWith<MetadataResult> get copyWith => _$MetadataResultCopyWithImpl<MetadataResult>(this as MetadataResult, _$identity);

  /// Serializes this MetadataResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MetadataResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetadataResult&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.sourceId, _this.sourceId) || other.sourceId == _this.sourceId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.subtitle, _this.subtitle) || other.subtitle == _this.subtitle)&&const DeepCollectionEquality().equals(other.authors, _this.authors)&&(identical(other.publisher, _this.publisher) || other.publisher == _this.publisher)&&(identical(other.publishDate, _this.publishDate) || other.publishDate == _this.publishDate)&&(identical(other.pageCount, _this.pageCount) || other.pageCount == _this.pageCount)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.isbn13, _this.isbn13) || other.isbn13 == _this.isbn13)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.seriesTitle, _this.seriesTitle) || other.seriesTitle == _this.seriesTitle)&&(identical(other.volumeNumber, _this.volumeNumber) || other.volumeNumber == _this.volumeNumber)&&(identical(other.coverPrice, _this.coverPrice) || other.coverPrice == _this.coverPrice)&&(identical(other.currency, _this.currency) || other.currency == _this.currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MetadataResult;
  return Object.hash(runtimeType,_this.source,_this.sourceId,_this.title,_this.subtitle,const DeepCollectionEquality().hash(_this.authors),_this.publisher,_this.publishDate,_this.pageCount,_this.language,_this.isbn13,_this.coverUrl,_this.description,_this.seriesTitle,_this.volumeNumber,_this.coverPrice,_this.currency);
}

@override
String toString() {
  final _this = this as MetadataResult;
  return 'MetadataResult(source: ${_this.source}, sourceId: ${_this.sourceId}, title: ${_this.title}, subtitle: ${_this.subtitle}, authors: ${_this.authors}, publisher: ${_this.publisher}, publishDate: ${_this.publishDate}, pageCount: ${_this.pageCount}, language: ${_this.language}, isbn13: ${_this.isbn13}, coverUrl: ${_this.coverUrl}, description: ${_this.description}, seriesTitle: ${_this.seriesTitle}, volumeNumber: ${_this.volumeNumber}, coverPrice: ${_this.coverPrice}, currency: ${_this.currency})';
}


}

/// @nodoc
abstract mixin class $MetadataResultCopyWith<$Res>  {
  factory $MetadataResultCopyWith(MetadataResult value, $Res Function(MetadataResult) _then) = _$MetadataResultCopyWithImpl;
@useResult
$Res call({
 MetadataSource source, String sourceId, String title, String? subtitle, List<String> authors, String? publisher, String? publishDate, int? pageCount, String? language, String? isbn13, String? coverUrl, String? description, String? seriesTitle, String? volumeNumber, double? coverPrice, String? currency
});




}
/// @nodoc
class _$MetadataResultCopyWithImpl<$Res>
    implements $MetadataResultCopyWith<$Res> {
  _$MetadataResultCopyWithImpl(this._self, this._then);

  final MetadataResult _self;
  final $Res Function(MetadataResult) _then;

/// Create a copy of MetadataResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? sourceId = null,Object? title = null,Object? subtitle = freezed,Object? authors = null,Object? publisher = freezed,Object? publishDate = freezed,Object? pageCount = freezed,Object? language = freezed,Object? isbn13 = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? seriesTitle = freezed,Object? volumeNumber = freezed,Object? coverPrice = freezed,Object? currency = freezed,}) {
  return _then(MetadataResult(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MetadataSource,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,publishDate: freezed == publishDate ? _self.publishDate : publishDate // ignore: cast_nullable_to_non_nullable
as String?,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,seriesTitle: freezed == seriesTitle ? _self.seriesTitle : seriesTitle // ignore: cast_nullable_to_non_nullable
as String?,volumeNumber: freezed == volumeNumber ? _self.volumeNumber : volumeNumber // ignore: cast_nullable_to_non_nullable
as String?,coverPrice: freezed == coverPrice ? _self.coverPrice : coverPrice // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MetadataResult].
extension MetadataResultPatterns on MetadataResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetadataResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetadataResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetadataResult value)  $default,){
final _that = this;
switch (_that) {
case _MetadataResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetadataResult value)?  $default,){
final _that = this;
switch (_that) {
case _MetadataResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MetadataSource source,  String sourceId,  String title,  String? subtitle,  List<String> authors,  String? publisher,  String? publishDate,  int? pageCount,  String? language,  String? isbn13,  String? coverUrl,  String? description,  String? seriesTitle,  String? volumeNumber,  double? coverPrice,  String? currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MetadataResult() when $default != null:
return $default(_that.source,_that.sourceId,_that.title,_that.subtitle,_that.authors,_that.publisher,_that.publishDate,_that.pageCount,_that.language,_that.isbn13,_that.coverUrl,_that.description,_that.seriesTitle,_that.volumeNumber,_that.coverPrice,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MetadataSource source,  String sourceId,  String title,  String? subtitle,  List<String> authors,  String? publisher,  String? publishDate,  int? pageCount,  String? language,  String? isbn13,  String? coverUrl,  String? description,  String? seriesTitle,  String? volumeNumber,  double? coverPrice,  String? currency)  $default,) {final _that = this;
switch (_that) {
case _MetadataResult():
return $default(_that.source,_that.sourceId,_that.title,_that.subtitle,_that.authors,_that.publisher,_that.publishDate,_that.pageCount,_that.language,_that.isbn13,_that.coverUrl,_that.description,_that.seriesTitle,_that.volumeNumber,_that.coverPrice,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MetadataSource source,  String sourceId,  String title,  String? subtitle,  List<String> authors,  String? publisher,  String? publishDate,  int? pageCount,  String? language,  String? isbn13,  String? coverUrl,  String? description,  String? seriesTitle,  String? volumeNumber,  double? coverPrice,  String? currency)?  $default,) {final _that = this;
switch (_that) {
case _MetadataResult() when $default != null:
return $default(_that.source,_that.sourceId,_that.title,_that.subtitle,_that.authors,_that.publisher,_that.publishDate,_that.pageCount,_that.language,_that.isbn13,_that.coverUrl,_that.description,_that.seriesTitle,_that.volumeNumber,_that.coverPrice,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MetadataResult implements MetadataResult {
  const _MetadataResult({required this.source, required this.sourceId, required this.title, this.subtitle,  List<String> authors = const <String>[], this.publisher, this.publishDate, this.pageCount, this.language, this.isbn13, this.coverUrl, this.description, this.seriesTitle, this.volumeNumber, this.coverPrice, this.currency}): _authors = authors;
  factory _MetadataResult.fromJson(Map<String, dynamic> json) => _$MetadataResultFromJson(json);

@override final  MetadataSource source;
@override final  String sourceId;
@override final  String title;
@override final  String? subtitle;
 final  List<String> _authors;
@override@JsonKey() List<String> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

@override final  String? publisher;
/// Free text: "2022", "2021-08-26"…
@override final  String? publishDate;
@override final  int? pageCount;
/// ISO 639-1 code ("fr").
@override final  String? language;
@override final  String? isbn13;
@override final  String? coverUrl;
@override final  String? description;
/// Series the volume belongs to, and its number ("1", "HS 2").
@override final  String? seriesTitle;
@override final  String? volumeNumber;
@override final  double? coverPrice;
@override final  String? currency;

/// Create a copy of MetadataResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetadataResultCopyWith<_MetadataResult> get copyWith => __$MetadataResultCopyWithImpl<_MetadataResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetadataResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetadataResult&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other.authors, _authors)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.publishDate, publishDate) || other.publishDate == publishDate)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.language, language) || other.language == language)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.seriesTitle, seriesTitle) || other.seriesTitle == seriesTitle)&&(identical(other.volumeNumber, volumeNumber) || other.volumeNumber == volumeNumber)&&(identical(other.coverPrice, coverPrice) || other.coverPrice == coverPrice)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,source,sourceId,title,subtitle,const DeepCollectionEquality().hash(_authors),publisher,publishDate,pageCount,language,isbn13,coverUrl,description,seriesTitle,volumeNumber,coverPrice,currency);
}

@override
String toString() {
    return 'MetadataResult(source: $source, sourceId: $sourceId, title: $title, subtitle: $subtitle, authors: $authors, publisher: $publisher, publishDate: $publishDate, pageCount: $pageCount, language: $language, isbn13: $isbn13, coverUrl: $coverUrl, description: $description, seriesTitle: $seriesTitle, volumeNumber: $volumeNumber, coverPrice: $coverPrice, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$MetadataResultCopyWith<$Res> implements $MetadataResultCopyWith<$Res> {
  factory _$MetadataResultCopyWith(_MetadataResult value, $Res Function(_MetadataResult) _then) = __$MetadataResultCopyWithImpl;
@override @useResult
$Res call({
 MetadataSource source, String sourceId, String title, String? subtitle, List<String> authors, String? publisher, String? publishDate, int? pageCount, String? language, String? isbn13, String? coverUrl, String? description, String? seriesTitle, String? volumeNumber, double? coverPrice, String? currency
});




}
/// @nodoc
class __$MetadataResultCopyWithImpl<$Res>
    implements _$MetadataResultCopyWith<$Res> {
  __$MetadataResultCopyWithImpl(this._self, this._then);

  final _MetadataResult _self;
  final $Res Function(_MetadataResult) _then;

/// Create a copy of MetadataResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? sourceId = null,Object? title = null,Object? subtitle = freezed,Object? authors = null,Object? publisher = freezed,Object? publishDate = freezed,Object? pageCount = freezed,Object? language = freezed,Object? isbn13 = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? seriesTitle = freezed,Object? volumeNumber = freezed,Object? coverPrice = freezed,Object? currency = freezed,}) {
  return _then(_MetadataResult(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MetadataSource,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,publishDate: freezed == publishDate ? _self.publishDate : publishDate // ignore: cast_nullable_to_non_nullable
as String?,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,seriesTitle: freezed == seriesTitle ? _self.seriesTitle : seriesTitle // ignore: cast_nullable_to_non_nullable
as String?,volumeNumber: freezed == volumeNumber ? _self.volumeNumber : volumeNumber // ignore: cast_nullable_to_non_nullable
as String?,coverPrice: freezed == coverPrice ? _self.coverPrice : coverPrice // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
