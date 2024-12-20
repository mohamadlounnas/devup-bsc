// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      emailVisibility: json['emailVisibility'] as bool?,
      verified: json['verified'] as bool?,
      avatar: json['avatar'] as String?,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      nationalId: json['national_id'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      placeOfBirth: json['place_of_birth'] as String?,
      banned: json['banned'] as bool?,
      grade: json['grade'] as String?,
      post: json['post'] as String?,
      type: $enumDecode(_$UserTypeEnumMap, json['type']),
      gender: $enumDecode(_$GenderEnumMap, json['gander']),
      phone: json['phone'] as String?,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'emailVisibility': instance.emailVisibility,
      'verified': instance.verified,
      'avatar': instance.avatar,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'national_id': instance.nationalId,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'place_of_birth': instance.placeOfBirth,
      'banned': instance.banned,
      'grade': instance.grade,
      'post': instance.post,
      'type': _$UserTypeEnumMap[instance.type]!,
      'gander': _$GenderEnumMap[instance.gender]!,
      'phone': instance.phone,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };

const _$UserTypeEnumMap = {
  UserType.employee: 'employee',
  UserType.client: 'client',
};

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};
