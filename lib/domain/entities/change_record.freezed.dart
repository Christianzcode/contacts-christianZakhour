// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChangeRecord _$ChangeRecordFromJson(Map<String, dynamic> json) {
  return _ChangeRecord.fromJson(json);
}

/// @nodoc
mixin _$ChangeRecord {
  String get id => throw _privateConstructorUsedError;
  String get contactId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get op => throw _privateConstructorUsedError; // create/update/delete
  Map<String, Map<String, dynamic>?> get diff =>
      throw _privateConstructorUsedError;

  /// Serializes this ChangeRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangeRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangeRecordCopyWith<ChangeRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeRecordCopyWith<$Res> {
  factory $ChangeRecordCopyWith(
          ChangeRecord value, $Res Function(ChangeRecord) then) =
      _$ChangeRecordCopyWithImpl<$Res, ChangeRecord>;
  @useResult
  $Res call(
      {String id,
      String contactId,
      DateTime createdAt,
      String op,
      Map<String, Map<String, dynamic>?> diff});
}

/// @nodoc
class _$ChangeRecordCopyWithImpl<$Res, $Val extends ChangeRecord>
    implements $ChangeRecordCopyWith<$Res> {
  _$ChangeRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangeRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contactId = null,
    Object? createdAt = null,
    Object? op = null,
    Object? diff = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      op: null == op
          ? _value.op
          : op // ignore: cast_nullable_to_non_nullable
              as String,
      diff: null == diff
          ? _value.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, dynamic>?>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangeRecordImplCopyWith<$Res>
    implements $ChangeRecordCopyWith<$Res> {
  factory _$$ChangeRecordImplCopyWith(
          _$ChangeRecordImpl value, $Res Function(_$ChangeRecordImpl) then) =
      __$$ChangeRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String contactId,
      DateTime createdAt,
      String op,
      Map<String, Map<String, dynamic>?> diff});
}

/// @nodoc
class __$$ChangeRecordImplCopyWithImpl<$Res>
    extends _$ChangeRecordCopyWithImpl<$Res, _$ChangeRecordImpl>
    implements _$$ChangeRecordImplCopyWith<$Res> {
  __$$ChangeRecordImplCopyWithImpl(
      _$ChangeRecordImpl _value, $Res Function(_$ChangeRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChangeRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contactId = null,
    Object? createdAt = null,
    Object? op = null,
    Object? diff = null,
  }) {
    return _then(_$ChangeRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      op: null == op
          ? _value.op
          : op // ignore: cast_nullable_to_non_nullable
              as String,
      diff: null == diff
          ? _value._diff
          : diff // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, dynamic>?>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangeRecordImpl implements _ChangeRecord {
  const _$ChangeRecordImpl(
      {required this.id,
      required this.contactId,
      required this.createdAt,
      required this.op,
      required final Map<String, Map<String, dynamic>?> diff})
      : _diff = diff;

  factory _$ChangeRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangeRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String contactId;
  @override
  final DateTime createdAt;
  @override
  final String op;
// create/update/delete
  final Map<String, Map<String, dynamic>?> _diff;
// create/update/delete
  @override
  Map<String, Map<String, dynamic>?> get diff {
    if (_diff is EqualUnmodifiableMapView) return _diff;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_diff);
  }

  @override
  String toString() {
    return 'ChangeRecord(id: $id, contactId: $contactId, createdAt: $createdAt, op: $op, diff: $diff)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.op, op) || other.op == op) &&
            const DeepCollectionEquality().equals(other._diff, _diff));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, contactId, createdAt, op,
      const DeepCollectionEquality().hash(_diff));

  /// Create a copy of ChangeRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeRecordImplCopyWith<_$ChangeRecordImpl> get copyWith =>
      __$$ChangeRecordImplCopyWithImpl<_$ChangeRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangeRecordImplToJson(
      this,
    );
  }
}

abstract class _ChangeRecord implements ChangeRecord {
  const factory _ChangeRecord(
          {required final String id,
          required final String contactId,
          required final DateTime createdAt,
          required final String op,
          required final Map<String, Map<String, dynamic>?> diff}) =
      _$ChangeRecordImpl;

  factory _ChangeRecord.fromJson(Map<String, dynamic> json) =
      _$ChangeRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get contactId;
  @override
  DateTime get createdAt;
  @override
  String get op; // create/update/delete
  @override
  Map<String, Map<String, dynamic>?> get diff;

  /// Create a copy of ChangeRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangeRecordImplCopyWith<_$ChangeRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
