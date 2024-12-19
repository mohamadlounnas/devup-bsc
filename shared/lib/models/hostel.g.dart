// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hostel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostelImpl _$$HostelImplFromJson(Map<String, dynamic> json) => _$HostelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      capacity: (json['capacity'] as num?)?.toDouble(),
      location: json['location'] as String?,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      status: $enumDecode(_$HostelStatusEnumMap, json['status']),
      serviceIds: (json['services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      services: (json['services_expand'] as List<dynamic>?)
          ?.map((e) => HostelService.fromJson(e as Map<String, dynamic>))
          .toList(),
      adminId: json['admin'] as String?,
      admin: json['admin_expand'] == null
          ? null
          : User.fromJson(json['admin_expand'] as Map<String, dynamic>),
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$$HostelImplToJson(_$HostelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'capacity': instance.capacity,
      'location': instance.location,
      'address': instance.address,
      'phone': instance.phone,
      'status': _$HostelStatusEnumMap[instance.status]!,
      'services': instance.serviceIds,
      'services_expand': instance.services?.map((e) => e.toJson()).toList(),
      'admin': instance.adminId,
      'admin_expand': instance.admin?.toJson(),
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };

const _$HostelStatusEnumMap = {
  HostelStatus.active: 'active',
  HostelStatus.inactive: 'inactive',
  HostelStatus.partially: 'partially',
};
