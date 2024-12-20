// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_event_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FacilityEventRegistrationImpl _$$FacilityEventRegistrationImplFromJson(
        Map<String, dynamic> json) =>
    _$FacilityEventRegistrationImpl(
      id: json['id'] as String,
      userId: json['user'] as String,
      user: json['user_expand'] == null
          ? null
          : User.fromJson(json['user_expand'] as Map<String, dynamic>),
      eventId: json['event'] as String,
      event: json['event_expand'] == null
          ? null
          : FacilityEvent.fromJson(
              json['event_expand'] as Map<String, dynamic>),
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$$FacilityEventRegistrationImplToJson(
        _$FacilityEventRegistrationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.userId,
      'user_expand': instance.user?.toJson(),
      'event': instance.eventId,
      'event_expand': instance.event?.toJson(),
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };
