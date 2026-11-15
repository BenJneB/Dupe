// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Loan {

 String get id; DateTime get createdAt; DateTime get updatedAt; String get itemId; String get borrowerName; DateTime get loanedAt; String? get userId; DateTime? get deletedAt; bool get syncPending; DateTime? get dueAt; DateTime? get returnedAt; String? get notes;
/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanCopyWith<Loan> get copyWith => _$LoanCopyWithImpl<Loan>(this as Loan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Loan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loan&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.borrowerName, _this.borrowerName) || other.borrowerName == _this.borrowerName)&&(identical(other.loanedAt, _this.loanedAt) || other.loanedAt == _this.loanedAt)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.syncPending, _this.syncPending) || other.syncPending == _this.syncPending)&&(identical(other.dueAt, _this.dueAt) || other.dueAt == _this.dueAt)&&(identical(other.returnedAt, _this.returnedAt) || other.returnedAt == _this.returnedAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}


@override
int get hashCode {
  final _this = this as Loan;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.itemId,_this.borrowerName,_this.loanedAt,_this.userId,_this.deletedAt,_this.syncPending,_this.dueAt,_this.returnedAt,_this.notes);
}

@override
String toString() {
  final _this = this as Loan;
  return 'Loan(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, itemId: ${_this.itemId}, borrowerName: ${_this.borrowerName}, loanedAt: ${_this.loanedAt}, userId: ${_this.userId}, deletedAt: ${_this.deletedAt}, syncPending: ${_this.syncPending}, dueAt: ${_this.dueAt}, returnedAt: ${_this.returnedAt}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $LoanCopyWith<$Res>  {
  factory $LoanCopyWith(Loan value, $Res Function(Loan) _then) = _$LoanCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String itemId, String borrowerName, DateTime loanedAt, String? userId, DateTime? deletedAt, bool syncPending, DateTime? dueAt, DateTime? returnedAt, String? notes
});




}
/// @nodoc
class _$LoanCopyWithImpl<$Res>
    implements $LoanCopyWith<$Res> {
  _$LoanCopyWithImpl(this._self, this._then);

  final Loan _self;
  final $Res Function(Loan) _then;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? itemId = null,Object? borrowerName = null,Object? loanedAt = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,Object? dueAt = freezed,Object? returnedAt = freezed,Object? notes = freezed,}) {
  return _then(Loan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,loanedAt: null == loanedAt ? _self.loanedAt : loanedAt // ignore: cast_nullable_to_non_nullable
as DateTime,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Loan].
extension LoanPatterns on Loan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Loan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Loan value)  $default,){
final _that = this;
switch (_that) {
case _Loan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Loan value)?  $default,){
final _that = this;
switch (_that) {
case _Loan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String itemId,  String borrowerName,  DateTime loanedAt,  String? userId,  DateTime? deletedAt,  bool syncPending,  DateTime? dueAt,  DateTime? returnedAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.itemId,_that.borrowerName,_that.loanedAt,_that.userId,_that.deletedAt,_that.syncPending,_that.dueAt,_that.returnedAt,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String itemId,  String borrowerName,  DateTime loanedAt,  String? userId,  DateTime? deletedAt,  bool syncPending,  DateTime? dueAt,  DateTime? returnedAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _Loan():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.itemId,_that.borrowerName,_that.loanedAt,_that.userId,_that.deletedAt,_that.syncPending,_that.dueAt,_that.returnedAt,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt,  String itemId,  String borrowerName,  DateTime loanedAt,  String? userId,  DateTime? deletedAt,  bool syncPending,  DateTime? dueAt,  DateTime? returnedAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.itemId,_that.borrowerName,_that.loanedAt,_that.userId,_that.deletedAt,_that.syncPending,_that.dueAt,_that.returnedAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _Loan extends Loan {
  const _Loan({required this.id, required this.createdAt, required this.updatedAt, required this.itemId, required this.borrowerName, required this.loanedAt, this.userId, this.deletedAt, this.syncPending = true, this.dueAt, this.returnedAt, this.notes}): super._();
  

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String itemId;
@override final  String borrowerName;
@override final  DateTime loanedAt;
@override final  String? userId;
@override final  DateTime? deletedAt;
@override@JsonKey() final  bool syncPending;
@override final  DateTime? dueAt;
@override final  DateTime? returnedAt;
@override final  String? notes;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanCopyWith<_Loan> get copyWith => __$LoanCopyWithImpl<_Loan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loan&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.borrowerName, borrowerName) || other.borrowerName == borrowerName)&&(identical(other.loanedAt, loanedAt) || other.loanedAt == loanedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.syncPending, syncPending) || other.syncPending == syncPending)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,itemId,borrowerName,loanedAt,userId,deletedAt,syncPending,dueAt,returnedAt,notes);
}

@override
String toString() {
    return 'Loan(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, itemId: $itemId, borrowerName: $borrowerName, loanedAt: $loanedAt, userId: $userId, deletedAt: $deletedAt, syncPending: $syncPending, dueAt: $dueAt, returnedAt: $returnedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$LoanCopyWith<$Res> implements $LoanCopyWith<$Res> {
  factory _$LoanCopyWith(_Loan value, $Res Function(_Loan) _then) = __$LoanCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String itemId, String borrowerName, DateTime loanedAt, String? userId, DateTime? deletedAt, bool syncPending, DateTime? dueAt, DateTime? returnedAt, String? notes
});




}
/// @nodoc
class __$LoanCopyWithImpl<$Res>
    implements _$LoanCopyWith<$Res> {
  __$LoanCopyWithImpl(this._self, this._then);

  final _Loan _self;
  final $Res Function(_Loan) _then;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? itemId = null,Object? borrowerName = null,Object? loanedAt = null,Object? userId = freezed,Object? deletedAt = freezed,Object? syncPending = null,Object? dueAt = freezed,Object? returnedAt = freezed,Object? notes = freezed,}) {
  return _then(_Loan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,borrowerName: null == borrowerName ? _self.borrowerName : borrowerName // ignore: cast_nullable_to_non_nullable
as String,loanedAt: null == loanedAt ? _self.loanedAt : loanedAt // ignore: cast_nullable_to_non_nullable
as DateTime,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,returnedAt: freezed == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
