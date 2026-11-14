// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_queue_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScanQueueEntry {

 String get id; String get isbn13; CollectionType get type; DateTime get scannedAt; ScanStatus get status; MetadataResult? get result;
/// Create a copy of ScanQueueEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanQueueEntryCopyWith<ScanQueueEntry> get copyWith => _$ScanQueueEntryCopyWithImpl<ScanQueueEntry>(this as ScanQueueEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScanQueueEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanQueueEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.isbn13, _this.isbn13) || other.isbn13 == _this.isbn13)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.scannedAt, _this.scannedAt) || other.scannedAt == _this.scannedAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.result, _this.result) || other.result == _this.result));
}


@override
int get hashCode {
  final _this = this as ScanQueueEntry;
  return Object.hash(runtimeType,_this.id,_this.isbn13,_this.type,_this.scannedAt,_this.status,_this.result);
}

@override
String toString() {
  final _this = this as ScanQueueEntry;
  return 'ScanQueueEntry(id: ${_this.id}, isbn13: ${_this.isbn13}, type: ${_this.type}, scannedAt: ${_this.scannedAt}, status: ${_this.status}, result: ${_this.result})';
}


}

/// @nodoc
abstract mixin class $ScanQueueEntryCopyWith<$Res>  {
  factory $ScanQueueEntryCopyWith(ScanQueueEntry value, $Res Function(ScanQueueEntry) _then) = _$ScanQueueEntryCopyWithImpl;
@useResult
$Res call({
 String id, String isbn13, CollectionType type, DateTime scannedAt, ScanStatus status, MetadataResult? result
});


$MetadataResultCopyWith<$Res>? get result;

}
/// @nodoc
class _$ScanQueueEntryCopyWithImpl<$Res>
    implements $ScanQueueEntryCopyWith<$Res> {
  _$ScanQueueEntryCopyWithImpl(this._self, this._then);

  final ScanQueueEntry _self;
  final $Res Function(ScanQueueEntry) _then;

/// Create a copy of ScanQueueEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isbn13 = null,Object? type = null,Object? scannedAt = null,Object? status = null,Object? result = freezed,}) {
  return _then(ScanQueueEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isbn13: null == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CollectionType,scannedAt: null == scannedAt ? _self.scannedAt : scannedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScanStatus,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as MetadataResult?,
  ));
}
/// Create a copy of ScanQueueEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $MetadataResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScanQueueEntry].
extension ScanQueueEntryPatterns on ScanQueueEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanQueueEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanQueueEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanQueueEntry value)  $default,){
final _that = this;
switch (_that) {
case _ScanQueueEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanQueueEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ScanQueueEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String isbn13,  CollectionType type,  DateTime scannedAt,  ScanStatus status,  MetadataResult? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanQueueEntry() when $default != null:
return $default(_that.id,_that.isbn13,_that.type,_that.scannedAt,_that.status,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String isbn13,  CollectionType type,  DateTime scannedAt,  ScanStatus status,  MetadataResult? result)  $default,) {final _that = this;
switch (_that) {
case _ScanQueueEntry():
return $default(_that.id,_that.isbn13,_that.type,_that.scannedAt,_that.status,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String isbn13,  CollectionType type,  DateTime scannedAt,  ScanStatus status,  MetadataResult? result)?  $default,) {final _that = this;
switch (_that) {
case _ScanQueueEntry() when $default != null:
return $default(_that.id,_that.isbn13,_that.type,_that.scannedAt,_that.status,_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _ScanQueueEntry implements ScanQueueEntry {
  const _ScanQueueEntry({required this.id, required this.isbn13, required this.type, required this.scannedAt, this.status = ScanStatus.pending, this.result});
  

@override final  String id;
@override final  String isbn13;
@override final  CollectionType type;
@override final  DateTime scannedAt;
@override@JsonKey() final  ScanStatus status;
@override final  MetadataResult? result;

/// Create a copy of ScanQueueEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanQueueEntryCopyWith<_ScanQueueEntry> get copyWith => __$ScanQueueEntryCopyWithImpl<_ScanQueueEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanQueueEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.type, type) || other.type == type)&&(identical(other.scannedAt, scannedAt) || other.scannedAt == scannedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,isbn13,type,scannedAt,status,result);
}

@override
String toString() {
    return 'ScanQueueEntry(id: $id, isbn13: $isbn13, type: $type, scannedAt: $scannedAt, status: $status, result: $result)';
}


}

/// @nodoc
abstract mixin class _$ScanQueueEntryCopyWith<$Res> implements $ScanQueueEntryCopyWith<$Res> {
  factory _$ScanQueueEntryCopyWith(_ScanQueueEntry value, $Res Function(_ScanQueueEntry) _then) = __$ScanQueueEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String isbn13, CollectionType type, DateTime scannedAt, ScanStatus status, MetadataResult? result
});


@override $MetadataResultCopyWith<$Res>? get result;

}
/// @nodoc
class __$ScanQueueEntryCopyWithImpl<$Res>
    implements _$ScanQueueEntryCopyWith<$Res> {
  __$ScanQueueEntryCopyWithImpl(this._self, this._then);

  final _ScanQueueEntry _self;
  final $Res Function(_ScanQueueEntry) _then;

/// Create a copy of ScanQueueEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isbn13 = null,Object? type = null,Object? scannedAt = null,Object? status = null,Object? result = freezed,}) {
  return _then(_ScanQueueEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,isbn13: null == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CollectionType,scannedAt: null == scannedAt ? _self.scannedAt : scannedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScanStatus,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as MetadataResult?,
  ));
}

/// Create a copy of ScanQueueEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $MetadataResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
