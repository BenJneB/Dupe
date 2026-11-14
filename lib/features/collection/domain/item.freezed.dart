// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Item {

 String get id; DateTime get createdAt; DateTime get updatedAt; CollectionType get type; String get title; String? get userId; DateTime? get deletedAt; bool get syncPending; String? get seriesId; String? get volumeNumber; String? get isbn13; String? get upc; List<String> get authors; String? get publisher; String? get edition; String? get format; String? get publishDate; int? get pageCount; String? get language; String? get coverUrl; String? get description; Ownership get ownership; ReadingStatus get readingStatus; DateTime? get readDate; int? get rating; bool get isFirstEdition; bool get isVariant; String? get condition; double? get purchasePrice; DateTime? get purchaseDate; double? get coverPrice; double? get estimatedValue; String get currency; int? get wishlistPriority; double? get wishlistMaxPrice; String? get location; String? get notes; String? get source; String? get sourceId;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Item;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.syncPending, _this.syncPending) || other.syncPending == _this.syncPending)&&(identical(other.seriesId, _this.seriesId) || other.seriesId == _this.seriesId)&&(identical(other.volumeNumber, _this.volumeNumber) || other.volumeNumber == _this.volumeNumber)&&(identical(other.isbn13, _this.isbn13) || other.isbn13 == _this.isbn13)&&(identical(other.upc, _this.upc) || other.upc == _this.upc)&&const DeepCollectionEquality().equals(other.authors, _this.authors)&&(identical(other.publisher, _this.publisher) || other.publisher == _this.publisher)&&(identical(other.edition, _this.edition) || other.edition == _this.edition)&&(identical(other.format, _this.format) || other.format == _this.format)&&(identical(other.publishDate, _this.publishDate) || other.publishDate == _this.publishDate)&&(identical(other.pageCount, _this.pageCount) || other.pageCount == _this.pageCount)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.ownership, _this.ownership) || other.ownership == _this.ownership)&&(identical(other.readingStatus, _this.readingStatus) || other.readingStatus == _this.readingStatus)&&(identical(other.readDate, _this.readDate) || other.readDate == _this.readDate)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.isFirstEdition, _this.isFirstEdition) || other.isFirstEdition == _this.isFirstEdition)&&(identical(other.isVariant, _this.isVariant) || other.isVariant == _this.isVariant)&&(identical(other.condition, _this.condition) || other.condition == _this.condition)&&(identical(other.purchasePrice, _this.purchasePrice) || other.purchasePrice == _this.purchasePrice)&&(identical(other.purchaseDate, _this.purchaseDate) || other.purchaseDate == _this.purchaseDate)&&(identical(other.coverPrice, _this.coverPrice) || other.coverPrice == _this.coverPrice)&&(identical(other.estimatedValue, _this.estimatedValue) || other.estimatedValue == _this.estimatedValue)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.wishlistPriority, _this.wishlistPriority) || other.wishlistPriority == _this.wishlistPriority)&&(identical(other.wishlistMaxPrice, _this.wishlistMaxPrice) || other.wishlistMaxPrice == _this.wishlistMaxPrice)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.sourceId, _this.sourceId) || other.sourceId == _this.sourceId));
}


@override
int get hashCode {
  final _this = this as Item;
  return Object.hashAll([runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.type,_this.title,_this.userId,_this.deletedAt,_this.syncPending,_this.seriesId,_this.volumeNumber,_this.isbn13,_this.upc,const DeepCollectionEquality().hash(_this.authors),_this.publisher,_this.edition,_this.format,_this.publishDate,_this.pageCount,_this.language,_this.coverUrl,_this.description,_this.ownership,_this.readingStatus,_this.readDate,_this.rating,_this.isFirstEdition,_this.isVariant,_this.condition,_this.purchasePrice,_this.purchaseDate,_this.coverPrice,_this.estimatedValue,_this.currency,_this.wishlistPriority,_this.wishlistMaxPrice,_this.location,_this.notes,_this.source,_this.sourceId]);
}

@override
String toString() {
  final _this = this as Item;
  return 'Item(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, type: ${_this.type}, title: ${_this.title}, userId: ${_this.userId}, deletedAt: ${_this.deletedAt}, syncPending: ${_this.syncPending}, seriesId: ${_this.seriesId}, volumeNumber: ${_this.volumeNumber}, isbn13: ${_this.isbn13}, upc: ${_this.upc}, authors: ${_this.authors}, publisher: ${_this.publisher}, edition: ${_this.edition}, format: ${_this.format}, publishDate: ${_this.publishDate}, pageCount: ${_this.pageCount}, language: ${_this.language}, coverUrl: ${_this.coverUrl}, description: ${_this.description}, ownership: ${_this.ownership}, readingStatus: ${_this.readingStatus}, readDate: ${_this.readDate}, rating: ${_this.rating}, isFirstEdition: ${_this.isFirstEdition}, isVariant: ${_this.isVariant}, condition: ${_this.condition}, purchasePrice: ${_this.purchasePrice}, purchaseDate: ${_this.purchaseDate}, coverPrice: ${_this.coverPrice}, estimatedValue: ${_this.estimatedValue}, currency: ${_this.currency}, wishlistPriority: ${_this.wishlistPriority}, wishlistMaxPrice: ${_this.wishlistMaxPrice}, location: ${_this.location}, notes: ${_this.notes}, source: ${_this.source}, sourceId: ${_this.sourceId})';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, CollectionType type, String title, String? userId, DateTime? deletedAt, bool syncPending, String? seriesId, String? volumeNumber, String? isbn13, String? upc, List<String> authors, String? publisher, String? edition, String? format, String? publishDate, int? pageCount, String? language, String? coverUrl, String? description, Ownership ownership, ReadingStatus readingStatus, DateTime? readDate, int? rating, bool isFirstEdition, bool isVariant, String? condition, double? purchasePrice, DateTime? purchaseDate, double? coverPrice, double? estimatedValue, String currency, int? wishlistPriority, double? wishlistMaxPrice, String? location, String? notes, String? source, String? sourceId
});




}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? type = null,Object? title = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,Object? seriesId = freezed,Object? volumeNumber = freezed,Object? isbn13 = freezed,Object? upc = freezed,Object? authors = null,Object? publisher = freezed,Object? edition = freezed,Object? format = freezed,Object? publishDate = freezed,Object? pageCount = freezed,Object? language = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? ownership = null,Object? readingStatus = null,Object? readDate = freezed,Object? rating = freezed,Object? isFirstEdition = null,Object? isVariant = null,Object? condition = freezed,Object? purchasePrice = freezed,Object? purchaseDate = freezed,Object? coverPrice = freezed,Object? estimatedValue = freezed,Object? currency = null,Object? wishlistPriority = freezed,Object? wishlistMaxPrice = freezed,Object? location = freezed,Object? notes = freezed,Object? source = freezed,Object? sourceId = freezed,}) {
  return _then(Item(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CollectionType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String?,volumeNumber: freezed == volumeNumber ? _self.volumeNumber : volumeNumber // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,upc: freezed == upc ? _self.upc : upc // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,edition: freezed == edition ? _self.edition : edition // ignore: cast_nullable_to_non_nullable
as String?,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,publishDate: freezed == publishDate ? _self.publishDate : publishDate // ignore: cast_nullable_to_non_nullable
as String?,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,ownership: null == ownership ? _self.ownership : ownership // ignore: cast_nullable_to_non_nullable
as Ownership,readingStatus: null == readingStatus ? _self.readingStatus : readingStatus // ignore: cast_nullable_to_non_nullable
as ReadingStatus,readDate: freezed == readDate ? _self.readDate : readDate // ignore: cast_nullable_to_non_nullable
as DateTime?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,isFirstEdition: null == isFirstEdition ? _self.isFirstEdition : isFirstEdition // ignore: cast_nullable_to_non_nullable
as bool,isVariant: null == isVariant ? _self.isVariant : isVariant // ignore: cast_nullable_to_non_nullable
as bool,condition: freezed == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String?,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,coverPrice: freezed == coverPrice ? _self.coverPrice : coverPrice // ignore: cast_nullable_to_non_nullable
as double?,estimatedValue: freezed == estimatedValue ? _self.estimatedValue : estimatedValue // ignore: cast_nullable_to_non_nullable
as double?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,wishlistPriority: freezed == wishlistPriority ? _self.wishlistPriority : wishlistPriority // ignore: cast_nullable_to_non_nullable
as int?,wishlistMaxPrice: freezed == wishlistMaxPrice ? _self.wishlistMaxPrice : wishlistMaxPrice // ignore: cast_nullable_to_non_nullable
as double?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Item].
extension ItemPatterns on Item {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Item value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Item value)  $default,){
final _that = this;
switch (_that) {
case _Item():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Item value)?  $default,){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  CollectionType type,  String title,  String? userId,  DateTime? deletedAt,  bool syncPending,  String? seriesId,  String? volumeNumber,  String? isbn13,  String? upc,  List<String> authors,  String? publisher,  String? edition,  String? format,  String? publishDate,  int? pageCount,  String? language,  String? coverUrl,  String? description,  Ownership ownership,  ReadingStatus readingStatus,  DateTime? readDate,  int? rating,  bool isFirstEdition,  bool isVariant,  String? condition,  double? purchasePrice,  DateTime? purchaseDate,  double? coverPrice,  double? estimatedValue,  String currency,  int? wishlistPriority,  double? wishlistMaxPrice,  String? location,  String? notes,  String? source,  String? sourceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.type,_that.title,_that.userId,_that.deletedAt,_that.syncPending,_that.seriesId,_that.volumeNumber,_that.isbn13,_that.upc,_that.authors,_that.publisher,_that.edition,_that.format,_that.publishDate,_that.pageCount,_that.language,_that.coverUrl,_that.description,_that.ownership,_that.readingStatus,_that.readDate,_that.rating,_that.isFirstEdition,_that.isVariant,_that.condition,_that.purchasePrice,_that.purchaseDate,_that.coverPrice,_that.estimatedValue,_that.currency,_that.wishlistPriority,_that.wishlistMaxPrice,_that.location,_that.notes,_that.source,_that.sourceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  CollectionType type,  String title,  String? userId,  DateTime? deletedAt,  bool syncPending,  String? seriesId,  String? volumeNumber,  String? isbn13,  String? upc,  List<String> authors,  String? publisher,  String? edition,  String? format,  String? publishDate,  int? pageCount,  String? language,  String? coverUrl,  String? description,  Ownership ownership,  ReadingStatus readingStatus,  DateTime? readDate,  int? rating,  bool isFirstEdition,  bool isVariant,  String? condition,  double? purchasePrice,  DateTime? purchaseDate,  double? coverPrice,  double? estimatedValue,  String currency,  int? wishlistPriority,  double? wishlistMaxPrice,  String? location,  String? notes,  String? source,  String? sourceId)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.type,_that.title,_that.userId,_that.deletedAt,_that.syncPending,_that.seriesId,_that.volumeNumber,_that.isbn13,_that.upc,_that.authors,_that.publisher,_that.edition,_that.format,_that.publishDate,_that.pageCount,_that.language,_that.coverUrl,_that.description,_that.ownership,_that.readingStatus,_that.readDate,_that.rating,_that.isFirstEdition,_that.isVariant,_that.condition,_that.purchasePrice,_that.purchaseDate,_that.coverPrice,_that.estimatedValue,_that.currency,_that.wishlistPriority,_that.wishlistMaxPrice,_that.location,_that.notes,_that.source,_that.sourceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt,  CollectionType type,  String title,  String? userId,  DateTime? deletedAt,  bool syncPending,  String? seriesId,  String? volumeNumber,  String? isbn13,  String? upc,  List<String> authors,  String? publisher,  String? edition,  String? format,  String? publishDate,  int? pageCount,  String? language,  String? coverUrl,  String? description,  Ownership ownership,  ReadingStatus readingStatus,  DateTime? readDate,  int? rating,  bool isFirstEdition,  bool isVariant,  String? condition,  double? purchasePrice,  DateTime? purchaseDate,  double? coverPrice,  double? estimatedValue,  String currency,  int? wishlistPriority,  double? wishlistMaxPrice,  String? location,  String? notes,  String? source,  String? sourceId)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.type,_that.title,_that.userId,_that.deletedAt,_that.syncPending,_that.seriesId,_that.volumeNumber,_that.isbn13,_that.upc,_that.authors,_that.publisher,_that.edition,_that.format,_that.publishDate,_that.pageCount,_that.language,_that.coverUrl,_that.description,_that.ownership,_that.readingStatus,_that.readDate,_that.rating,_that.isFirstEdition,_that.isVariant,_that.condition,_that.purchasePrice,_that.purchaseDate,_that.coverPrice,_that.estimatedValue,_that.currency,_that.wishlistPriority,_that.wishlistMaxPrice,_that.location,_that.notes,_that.source,_that.sourceId);case _:
  return null;

}
}

}

/// @nodoc


class _Item implements Item {
  const _Item({required this.id, required this.createdAt, required this.updatedAt, required this.type, required this.title, this.userId, this.deletedAt, this.syncPending = true, this.seriesId, this.volumeNumber, this.isbn13, this.upc,  List<String> authors = const <String>[], this.publisher, this.edition, this.format, this.publishDate, this.pageCount, this.language, this.coverUrl, this.description, this.ownership = Ownership.possede, this.readingStatus = ReadingStatus.nonLu, this.readDate, this.rating, this.isFirstEdition = false, this.isVariant = false, this.condition, this.purchasePrice, this.purchaseDate, this.coverPrice, this.estimatedValue, this.currency = 'EUR', this.wishlistPriority, this.wishlistMaxPrice, this.location, this.notes, this.source, this.sourceId}): _authors = authors;
  

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  CollectionType type;
@override final  String title;
@override final  String? userId;
@override final  DateTime? deletedAt;
@override@JsonKey() final  bool syncPending;
@override final  String? seriesId;
@override final  String? volumeNumber;
@override final  String? isbn13;
@override final  String? upc;
 final  List<String> _authors;
@override@JsonKey() List<String> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

@override final  String? publisher;
@override final  String? edition;
@override final  String? format;
@override final  String? publishDate;
@override final  int? pageCount;
@override final  String? language;
@override final  String? coverUrl;
@override final  String? description;
@override@JsonKey() final  Ownership ownership;
@override@JsonKey() final  ReadingStatus readingStatus;
@override final  DateTime? readDate;
@override final  int? rating;
@override@JsonKey() final  bool isFirstEdition;
@override@JsonKey() final  bool isVariant;
@override final  String? condition;
@override final  double? purchasePrice;
@override final  DateTime? purchaseDate;
@override final  double? coverPrice;
@override final  double? estimatedValue;
@override@JsonKey() final  String currency;
@override final  int? wishlistPriority;
@override final  double? wishlistMaxPrice;
@override final  String? location;
@override final  String? notes;
@override final  String? source;
@override final  String? sourceId;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncPending, syncPending) || other.syncPending == syncPending)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.volumeNumber, volumeNumber) || other.volumeNumber == volumeNumber)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.upc, upc) || other.upc == upc)&&const DeepCollectionEquality().equals(other.authors, _authors)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.edition, edition) || other.edition == edition)&&(identical(other.format, format) || other.format == format)&&(identical(other.publishDate, publishDate) || other.publishDate == publishDate)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.language, language) || other.language == language)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.ownership, ownership) || other.ownership == ownership)&&(identical(other.readingStatus, readingStatus) || other.readingStatus == readingStatus)&&(identical(other.readDate, readDate) || other.readDate == readDate)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.isFirstEdition, isFirstEdition) || other.isFirstEdition == isFirstEdition)&&(identical(other.isVariant, isVariant) || other.isVariant == isVariant)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.coverPrice, coverPrice) || other.coverPrice == coverPrice)&&(identical(other.estimatedValue, estimatedValue) || other.estimatedValue == estimatedValue)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.wishlistPriority, wishlistPriority) || other.wishlistPriority == wishlistPriority)&&(identical(other.wishlistMaxPrice, wishlistMaxPrice) || other.wishlistMaxPrice == wishlistMaxPrice)&&(identical(other.location, location) || other.location == location)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,id,createdAt,updatedAt,type,title,userId,deletedAt,syncPending,seriesId,volumeNumber,isbn13,upc,const DeepCollectionEquality().hash(_authors),publisher,edition,format,publishDate,pageCount,language,coverUrl,description,ownership,readingStatus,readDate,rating,isFirstEdition,isVariant,condition,purchasePrice,purchaseDate,coverPrice,estimatedValue,currency,wishlistPriority,wishlistMaxPrice,location,notes,source,sourceId]);
}

@override
String toString() {
    return 'Item(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, type: $type, title: $title, userId: $userId, deletedAt: $deletedAt, syncPending: $syncPending, seriesId: $seriesId, volumeNumber: $volumeNumber, isbn13: $isbn13, upc: $upc, authors: $authors, publisher: $publisher, edition: $edition, format: $format, publishDate: $publishDate, pageCount: $pageCount, language: $language, coverUrl: $coverUrl, description: $description, ownership: $ownership, readingStatus: $readingStatus, readDate: $readDate, rating: $rating, isFirstEdition: $isFirstEdition, isVariant: $isVariant, condition: $condition, purchasePrice: $purchasePrice, purchaseDate: $purchaseDate, coverPrice: $coverPrice, estimatedValue: $estimatedValue, currency: $currency, wishlistPriority: $wishlistPriority, wishlistMaxPrice: $wishlistMaxPrice, location: $location, notes: $notes, source: $source, sourceId: $sourceId)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, CollectionType type, String title, String? userId, DateTime? deletedAt, bool syncPending, String? seriesId, String? volumeNumber, String? isbn13, String? upc, List<String> authors, String? publisher, String? edition, String? format, String? publishDate, int? pageCount, String? language, String? coverUrl, String? description, Ownership ownership, ReadingStatus readingStatus, DateTime? readDate, int? rating, bool isFirstEdition, bool isVariant, String? condition, double? purchasePrice, DateTime? purchaseDate, double? coverPrice, double? estimatedValue, String currency, int? wishlistPriority, double? wishlistMaxPrice, String? location, String? notes, String? source, String? sourceId
});




}
/// @nodoc
class __$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(this._self, this._then);

  final _Item _self;
  final $Res Function(_Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? type = null,Object? title = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,Object? seriesId = freezed,Object? volumeNumber = freezed,Object? isbn13 = freezed,Object? upc = freezed,Object? authors = null,Object? publisher = freezed,Object? edition = freezed,Object? format = freezed,Object? publishDate = freezed,Object? pageCount = freezed,Object? language = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? ownership = null,Object? readingStatus = null,Object? readDate = freezed,Object? rating = freezed,Object? isFirstEdition = null,Object? isVariant = null,Object? condition = freezed,Object? purchasePrice = freezed,Object? purchaseDate = freezed,Object? coverPrice = freezed,Object? estimatedValue = freezed,Object? currency = null,Object? wishlistPriority = freezed,Object? wishlistMaxPrice = freezed,Object? location = freezed,Object? notes = freezed,Object? source = freezed,Object? sourceId = freezed,}) {
  return _then(_Item(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CollectionType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String?,volumeNumber: freezed == volumeNumber ? _self.volumeNumber : volumeNumber // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,upc: freezed == upc ? _self.upc : upc // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,edition: freezed == edition ? _self.edition : edition // ignore: cast_nullable_to_non_nullable
as String?,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,publishDate: freezed == publishDate ? _self.publishDate : publishDate // ignore: cast_nullable_to_non_nullable
as String?,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,ownership: null == ownership ? _self.ownership : ownership // ignore: cast_nullable_to_non_nullable
as Ownership,readingStatus: null == readingStatus ? _self.readingStatus : readingStatus // ignore: cast_nullable_to_non_nullable
as ReadingStatus,readDate: freezed == readDate ? _self.readDate : readDate // ignore: cast_nullable_to_non_nullable
as DateTime?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,isFirstEdition: null == isFirstEdition ? _self.isFirstEdition : isFirstEdition // ignore: cast_nullable_to_non_nullable
as bool,isVariant: null == isVariant ? _self.isVariant : isVariant // ignore: cast_nullable_to_non_nullable
as bool,condition: freezed == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String?,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,coverPrice: freezed == coverPrice ? _self.coverPrice : coverPrice // ignore: cast_nullable_to_non_nullable
as double?,estimatedValue: freezed == estimatedValue ? _self.estimatedValue : estimatedValue // ignore: cast_nullable_to_non_nullable
as double?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,wishlistPriority: freezed == wishlistPriority ? _self.wishlistPriority : wishlistPriority // ignore: cast_nullable_to_non_nullable
as int?,wishlistMaxPrice: freezed == wishlistMaxPrice ? _self.wishlistMaxPrice : wishlistMaxPrice // ignore: cast_nullable_to_non_nullable
as double?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
