// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hostel_reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostelReservationImpl _$$HostelReservationImplFromJson(
        Map<String, dynamic> json) =>
    _$HostelReservationImpl(
      id: json['id'] as String,
      userId: json['user'] as String,
      user: json['user_expand'] == null
          ? null
          : User.fromJson(json['user_expand'] as Map<String, dynamic>),
      status: $enumDecode(_$ReservationStatusEnumMap, json['status']),
      parentalLicense: json['parental_license'] as String?,
      loginAt: json['login_at'] == null
          ? null
          : DateTime.parse(json['login_at'] as String),
      logoutAt: json['logout_at'] == null
          ? null
          : DateTime.parse(json['logout_at'] as String),
      paymentAmount: (json['payment_amount'] as num?)?.toDouble(),
      paymentReceipt: json['payment_receipt'] as String?,
      foodAmount: (json['food_amount'] as num?)?.toDouble(),
      foodReceipt: json['food_receipt'] as String?,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );

Map<String, dynamic> _$$HostelReservationImplToJson(
        _$HostelReservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.userId,
      'user_expand': instance.user?.toJson(),
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'parental_license': instance.parentalLicense,
      'login_at': instance.loginAt?.toIso8601String(),
      'logout_at': instance.logoutAt?.toIso8601String(),
      'payment_amount': instance.paymentAmount,
      'payment_receipt': instance.paymentReceipt,
      'food_amount': instance.foodAmount,
      'food_receipt': instance.foodReceipt,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
    };

const _$ReservationStatusEnumMap = {
  ReservationStatus.pending: 'pending',
  ReservationStatus.approved: 'approved',
  ReservationStatus.cancelled: 'cancelled',
};
