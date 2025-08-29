// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      id: json['id'] as String,
      remoteId: (json['remoteId'] as num?)?.toInt(),
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      company: json['company'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      pendingSync: json['pendingSync'] as bool? ?? false,
      deleted: json['deleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remoteId': instance.remoteId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'company': instance.company,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'pendingSync': instance.pendingSync,
      'deleted': instance.deleted,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
