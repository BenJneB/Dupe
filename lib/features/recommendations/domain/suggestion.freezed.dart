// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SuggestionReason {

 SuggestionKind get kind;/// Author key or AniList id of the owned series behind the reason.
 String get key;/// Author name or series title, as displayed.
 String get label;/// Owned books of that author or series ("12 albums de Larcenet").
 int get count;
/// Create a copy of SuggestionReason
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuggestionReasonCopyWith<SuggestionReason> get copyWith => _$SuggestionReasonCopyWithImpl<SuggestionReason>(this as SuggestionReason, _$identity);

  /// Serializes this SuggestionReason to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SuggestionReason;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuggestionReason&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SuggestionReason;
  return Object.hash(runtimeType,_this.kind,_this.key,_this.label,_this.count);
}

@override
String toString() {
  final _this = this as SuggestionReason;
  return 'SuggestionReason(kind: ${_this.kind}, key: ${_this.key}, label: ${_this.label}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $SuggestionReasonCopyWith<$Res>  {
  factory $SuggestionReasonCopyWith(SuggestionReason value, $Res Function(SuggestionReason) _then) = _$SuggestionReasonCopyWithImpl;
@useResult
$Res call({
 SuggestionKind kind, String key, String label, int count
});




}
/// @nodoc
class _$SuggestionReasonCopyWithImpl<$Res>
    implements $SuggestionReasonCopyWith<$Res> {
  _$SuggestionReasonCopyWithImpl(this._self, this._then);

  final SuggestionReason _self;
  final $Res Function(SuggestionReason) _then;

/// Create a copy of SuggestionReason
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? key = null,Object? label = null,Object? count = null,}) {
  return _then(SuggestionReason(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SuggestionKind,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SuggestionReason].
extension SuggestionReasonPatterns on SuggestionReason {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuggestionReason value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuggestionReason() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuggestionReason value)  $default,){
final _that = this;
switch (_that) {
case _SuggestionReason():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuggestionReason value)?  $default,){
final _that = this;
switch (_that) {
case _SuggestionReason() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SuggestionKind kind,  String key,  String label,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuggestionReason() when $default != null:
return $default(_that.kind,_that.key,_that.label,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SuggestionKind kind,  String key,  String label,  int count)  $default,) {final _that = this;
switch (_that) {
case _SuggestionReason():
return $default(_that.kind,_that.key,_that.label,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SuggestionKind kind,  String key,  String label,  int count)?  $default,) {final _that = this;
switch (_that) {
case _SuggestionReason() when $default != null:
return $default(_that.kind,_that.key,_that.label,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SuggestionReason implements SuggestionReason {
  const _SuggestionReason({required this.kind, required this.key, required this.label, required this.count});
  factory _SuggestionReason.fromJson(Map<String, dynamic> json) => _$SuggestionReasonFromJson(json);

@override final  SuggestionKind kind;
/// Author key or AniList id of the owned series behind the reason.
@override final  String key;
/// Author name or series title, as displayed.
@override final  String label;
/// Owned books of that author or series ("12 albums de Larcenet").
@override final  int count;

/// Create a copy of SuggestionReason
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuggestionReasonCopyWith<_SuggestionReason> get copyWith => __$SuggestionReasonCopyWithImpl<_SuggestionReason>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuggestionReasonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuggestionReason&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,key,label,count);
}

@override
String toString() {
    return 'SuggestionReason(kind: $kind, key: $key, label: $label, count: $count)';
}


}

/// @nodoc
abstract mixin class _$SuggestionReasonCopyWith<$Res> implements $SuggestionReasonCopyWith<$Res> {
  factory _$SuggestionReasonCopyWith(_SuggestionReason value, $Res Function(_SuggestionReason) _then) = __$SuggestionReasonCopyWithImpl;
@override @useResult
$Res call({
 SuggestionKind kind, String key, String label, int count
});




}
/// @nodoc
class __$SuggestionReasonCopyWithImpl<$Res>
    implements _$SuggestionReasonCopyWith<$Res> {
  __$SuggestionReasonCopyWithImpl(this._self, this._then);

  final _SuggestionReason _self;
  final $Res Function(_SuggestionReason) _then;

/// Create a copy of SuggestionReason
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? key = null,Object? label = null,Object? count = null,}) {
  return _then(_SuggestionReason(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SuggestionKind,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Suggestion {

/// Stable identity: `anilist:<id>`, `series:<title>` or `book:<title>`.
 String get key; CollectionType get type; String get title; SuggestionReason get reason;/// Set for a series (the wish is its volume 1).
 String? get seriesTitle;/// Other titles of the work (romaji, synonyms): owned under another
/// name means owned.
 List<String> get altTitles; List<String> get authors; String? get publisher; String? get isbn13; String? get coverUrl; String? get siteUrl;/// AniList id, kept on the series created from the suggestion.
 String? get anilistId;/// Community votes (AniList recommendation rating).
 int get votes; double get score;
/// Create a copy of Suggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuggestionCopyWith<Suggestion> get copyWith => _$SuggestionCopyWithImpl<Suggestion>(this as Suggestion, _$identity);

  /// Serializes this Suggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Suggestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Suggestion&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.seriesTitle, _this.seriesTitle) || other.seriesTitle == _this.seriesTitle)&&const DeepCollectionEquality().equals(other.altTitles, _this.altTitles)&&const DeepCollectionEquality().equals(other.authors, _this.authors)&&(identical(other.publisher, _this.publisher) || other.publisher == _this.publisher)&&(identical(other.isbn13, _this.isbn13) || other.isbn13 == _this.isbn13)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.siteUrl, _this.siteUrl) || other.siteUrl == _this.siteUrl)&&(identical(other.anilistId, _this.anilistId) || other.anilistId == _this.anilistId)&&(identical(other.votes, _this.votes) || other.votes == _this.votes)&&(identical(other.score, _this.score) || other.score == _this.score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Suggestion;
  return Object.hash(runtimeType,_this.key,_this.type,_this.title,_this.reason,_this.seriesTitle,const DeepCollectionEquality().hash(_this.altTitles),const DeepCollectionEquality().hash(_this.authors),_this.publisher,_this.isbn13,_this.coverUrl,_this.siteUrl,_this.anilistId,_this.votes,_this.score);
}

@override
String toString() {
  final _this = this as Suggestion;
  return 'Suggestion(key: ${_this.key}, type: ${_this.type}, title: ${_this.title}, reason: ${_this.reason}, seriesTitle: ${_this.seriesTitle}, altTitles: ${_this.altTitles}, authors: ${_this.authors}, publisher: ${_this.publisher}, isbn13: ${_this.isbn13}, coverUrl: ${_this.coverUrl}, siteUrl: ${_this.siteUrl}, anilistId: ${_this.anilistId}, votes: ${_this.votes}, score: ${_this.score})';
}


}

/// @nodoc
abstract mixin class $SuggestionCopyWith<$Res>  {
  factory $SuggestionCopyWith(Suggestion value, $Res Function(Suggestion) _then) = _$SuggestionCopyWithImpl;
@useResult
$Res call({
 String key, CollectionType type, String title, SuggestionReason reason, String? seriesTitle, List<String> altTitles, List<String> authors, String? publisher, String? isbn13, String? coverUrl, String? siteUrl, String? anilistId, int votes, double score
});


$SuggestionReasonCopyWith<$Res> get reason;

}
/// @nodoc
class _$SuggestionCopyWithImpl<$Res>
    implements $SuggestionCopyWith<$Res> {
  _$SuggestionCopyWithImpl(this._self, this._then);

  final Suggestion _self;
  final $Res Function(Suggestion) _then;

/// Create a copy of Suggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? type = null,Object? title = null,Object? reason = null,Object? seriesTitle = freezed,Object? altTitles = null,Object? authors = null,Object? publisher = freezed,Object? isbn13 = freezed,Object? coverUrl = freezed,Object? siteUrl = freezed,Object? anilistId = freezed,Object? votes = null,Object? score = null,}) {
  return _then(Suggestion(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CollectionType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as SuggestionReason,seriesTitle: freezed == seriesTitle ? _self.seriesTitle : seriesTitle // ignore: cast_nullable_to_non_nullable
as String?,altTitles: null == altTitles ? _self.altTitles : altTitles // ignore: cast_nullable_to_non_nullable
as List<String>,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,siteUrl: freezed == siteUrl ? _self.siteUrl : siteUrl // ignore: cast_nullable_to_non_nullable
as String?,anilistId: freezed == anilistId ? _self.anilistId : anilistId // ignore: cast_nullable_to_non_nullable
as String?,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of Suggestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuggestionReasonCopyWith<$Res> get reason {
  
  return $SuggestionReasonCopyWith<$Res>(_self.reason, (value) {
    return _then(_self.copyWith(reason: value));
  });
}
}


/// Adds pattern-matching-related methods to [Suggestion].
extension SuggestionPatterns on Suggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Suggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Suggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Suggestion value)  $default,){
final _that = this;
switch (_that) {
case _Suggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Suggestion value)?  $default,){
final _that = this;
switch (_that) {
case _Suggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  CollectionType type,  String title,  SuggestionReason reason,  String? seriesTitle,  List<String> altTitles,  List<String> authors,  String? publisher,  String? isbn13,  String? coverUrl,  String? siteUrl,  String? anilistId,  int votes,  double score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Suggestion() when $default != null:
return $default(_that.key,_that.type,_that.title,_that.reason,_that.seriesTitle,_that.altTitles,_that.authors,_that.publisher,_that.isbn13,_that.coverUrl,_that.siteUrl,_that.anilistId,_that.votes,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  CollectionType type,  String title,  SuggestionReason reason,  String? seriesTitle,  List<String> altTitles,  List<String> authors,  String? publisher,  String? isbn13,  String? coverUrl,  String? siteUrl,  String? anilistId,  int votes,  double score)  $default,) {final _that = this;
switch (_that) {
case _Suggestion():
return $default(_that.key,_that.type,_that.title,_that.reason,_that.seriesTitle,_that.altTitles,_that.authors,_that.publisher,_that.isbn13,_that.coverUrl,_that.siteUrl,_that.anilistId,_that.votes,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  CollectionType type,  String title,  SuggestionReason reason,  String? seriesTitle,  List<String> altTitles,  List<String> authors,  String? publisher,  String? isbn13,  String? coverUrl,  String? siteUrl,  String? anilistId,  int votes,  double score)?  $default,) {final _that = this;
switch (_that) {
case _Suggestion() when $default != null:
return $default(_that.key,_that.type,_that.title,_that.reason,_that.seriesTitle,_that.altTitles,_that.authors,_that.publisher,_that.isbn13,_that.coverUrl,_that.siteUrl,_that.anilistId,_that.votes,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Suggestion implements Suggestion {
  const _Suggestion({required this.key, required this.type, required this.title, required this.reason, this.seriesTitle,  List<String> altTitles = const <String>[],  List<String> authors = const <String>[], this.publisher, this.isbn13, this.coverUrl, this.siteUrl, this.anilistId, this.votes = 0, this.score = 0}): _altTitles = altTitles,_authors = authors;
  factory _Suggestion.fromJson(Map<String, dynamic> json) => _$SuggestionFromJson(json);

/// Stable identity: `anilist:<id>`, `series:<title>` or `book:<title>`.
@override final  String key;
@override final  CollectionType type;
@override final  String title;
@override final  SuggestionReason reason;
/// Set for a series (the wish is its volume 1).
@override final  String? seriesTitle;
/// Other titles of the work (romaji, synonyms): owned under another
/// name means owned.
 final  List<String> _altTitles;
/// Other titles of the work (romaji, synonyms): owned under another
/// name means owned.
@override@JsonKey() List<String> get altTitles {
  if (_altTitles is EqualUnmodifiableListView) return _altTitles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_altTitles);
}

 final  List<String> _authors;
@override@JsonKey() List<String> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

@override final  String? publisher;
@override final  String? isbn13;
@override final  String? coverUrl;
@override final  String? siteUrl;
/// AniList id, kept on the series created from the suggestion.
@override final  String? anilistId;
/// Community votes (AniList recommendation rating).
@override@JsonKey() final  int votes;
@override@JsonKey() final  double score;

/// Create a copy of Suggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuggestionCopyWith<_Suggestion> get copyWith => __$SuggestionCopyWithImpl<_Suggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Suggestion&&(identical(other.key, key) || other.key == key)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.seriesTitle, seriesTitle) || other.seriesTitle == seriesTitle)&&const DeepCollectionEquality().equals(other.altTitles, _altTitles)&&const DeepCollectionEquality().equals(other.authors, _authors)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.siteUrl, siteUrl) || other.siteUrl == siteUrl)&&(identical(other.anilistId, anilistId) || other.anilistId == anilistId)&&(identical(other.votes, votes) || other.votes == votes)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,type,title,reason,seriesTitle,const DeepCollectionEquality().hash(_altTitles),const DeepCollectionEquality().hash(_authors),publisher,isbn13,coverUrl,siteUrl,anilistId,votes,score);
}

@override
String toString() {
    return 'Suggestion(key: $key, type: $type, title: $title, reason: $reason, seriesTitle: $seriesTitle, altTitles: $altTitles, authors: $authors, publisher: $publisher, isbn13: $isbn13, coverUrl: $coverUrl, siteUrl: $siteUrl, anilistId: $anilistId, votes: $votes, score: $score)';
}


}

/// @nodoc
abstract mixin class _$SuggestionCopyWith<$Res> implements $SuggestionCopyWith<$Res> {
  factory _$SuggestionCopyWith(_Suggestion value, $Res Function(_Suggestion) _then) = __$SuggestionCopyWithImpl;
@override @useResult
$Res call({
 String key, CollectionType type, String title, SuggestionReason reason, String? seriesTitle, List<String> altTitles, List<String> authors, String? publisher, String? isbn13, String? coverUrl, String? siteUrl, String? anilistId, int votes, double score
});


@override $SuggestionReasonCopyWith<$Res> get reason;

}
/// @nodoc
class __$SuggestionCopyWithImpl<$Res>
    implements _$SuggestionCopyWith<$Res> {
  __$SuggestionCopyWithImpl(this._self, this._then);

  final _Suggestion _self;
  final $Res Function(_Suggestion) _then;

/// Create a copy of Suggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? type = null,Object? title = null,Object? reason = null,Object? seriesTitle = freezed,Object? altTitles = null,Object? authors = null,Object? publisher = freezed,Object? isbn13 = freezed,Object? coverUrl = freezed,Object? siteUrl = freezed,Object? anilistId = freezed,Object? votes = null,Object? score = null,}) {
  return _then(_Suggestion(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CollectionType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as SuggestionReason,seriesTitle: freezed == seriesTitle ? _self.seriesTitle : seriesTitle // ignore: cast_nullable_to_non_nullable
as String?,altTitles: null == altTitles ? _self._altTitles : altTitles // ignore: cast_nullable_to_non_nullable
as List<String>,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,siteUrl: freezed == siteUrl ? _self.siteUrl : siteUrl // ignore: cast_nullable_to_non_nullable
as String?,anilistId: freezed == anilistId ? _self.anilistId : anilistId // ignore: cast_nullable_to_non_nullable
as String?,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of Suggestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SuggestionReasonCopyWith<$Res> get reason {
  
  return $SuggestionReasonCopyWith<$Res>(_self.reason, (value) {
    return _then(_self.copyWith(reason: value));
  });
}
}

// dart format on
