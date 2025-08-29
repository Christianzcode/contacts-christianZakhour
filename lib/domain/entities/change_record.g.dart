// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChangeRecordImpl _$$ChangeRecordImplFromJson(Map<String, dynamic> json) =>
    _$ChangeRecordImpl(
      id: json['id'] as String,
      contactId: json['contactId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      op: json['op'] as String,
      diff: (json['diff'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as Map<String, dynamic>?),
      ),
    );

Map<String, dynamic> _$$ChangeRecordImplToJson(_$ChangeRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contactId': instance.contactId,
      'createdAt': instance.createdAt.toIso8601String(),
      'op': instance.op,
      'diff': instance.diff,
    };
