// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hostel_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostelServiceImpl _$$HostelServiceImplFromJson(Map<String, dynamic> json) =>
    _$HostelServiceImpl(
      id: json['id'] as String,
      icon: json['icon'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$$HostelServiceImplToJson(_$HostelServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'icon': instance.icon,
      'name': instance.name,
      'description': instance.description,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };
