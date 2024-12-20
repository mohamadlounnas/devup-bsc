// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hostel_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostelServiceImpl _$$HostelServiceImplFromJson(Map<String, dynamic> json) =>
    _$HostelServiceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: const ServiceTypeConverter().fromJson(json['type']),
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$$HostelServiceImplToJson(_$HostelServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': const ServiceTypeConverter().toJson(instance.type),
      'description': instance.description,
      'icon': instance.icon,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };

const _$ServiceTypeEnumMap = {
  ServiceType.hospitality: 'hospitality',
  ServiceType.activity: 'activity',
  ServiceType.restoration: 'restoration',
};
