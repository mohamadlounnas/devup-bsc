// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FacilityImpl _$$FacilityImplFromJson(Map<String, dynamic> json) =>
    _$FacilityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      managerId: json['manager'] as String?,
      manager: json['manager_expand'] == null
          ? null
          : User.fromJson(json['manager_expand'] as Map<String, dynamic>),
      logo: json['logo'] as String?,
      cover: json['cover'] as String?,
      type: $enumDecode(_$FacilityTypeEnumMap, json['type']),
      location: json['location'] as String?,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$$FacilityImplToJson(_$FacilityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'manager': instance.managerId,
      'manager_expand': instance.manager?.toJson(),
      'logo': instance.logo,
      'cover': instance.cover,
      'type': _$FacilityTypeEnumMap[instance.type]!,
      'location': instance.location,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };

const _$FacilityTypeEnumMap = {
  FacilityType.sportClub: 'sport_club',
  FacilityType.touristAgency: 'tourist_agency',
  FacilityType.hotel: 'hotel',
  FacilityType.museum: 'museum',
  FacilityType.restaurant: 'restaurant',
};
