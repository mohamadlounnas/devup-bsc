// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FacilityEventImpl _$$FacilityEventImplFromJson(Map<String, dynamic> json) =>
    _$FacilityEventImpl(
      id: json['id'] as String,
      image: json['image'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      body: json['body'] as String?,
      started: json['started'] == null
          ? null
          : DateTime.parse(json['started'] as String),
      ended: json['ended'] == null
          ? null
          : DateTime.parse(json['ended'] as String),
      seats: (json['seats'] as num?)?.toDouble(),
      remainingSeats: (json['remaining_seats'] as num?)?.toDouble(),
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$$FacilityEventImplToJson(_$FacilityEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'description': instance.description,
      'body': instance.body,
      'started': instance.started?.toIso8601String(),
      'ended': instance.ended?.toIso8601String(),
      'seats': instance.seats,
      'remaining_seats': instance.remainingSeats,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };