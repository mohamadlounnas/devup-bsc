// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';
import 'enums.dart';

part 'hostel_reservation.freezed.dart';
part 'hostel_reservation.g.dart';

/// HostelReservation model representing the hostels_reservations collection in PocketBase
@freezed
class HostelReservation with _$HostelReservation {
  const factory HostelReservation({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'user') required String userId,
    @JsonKey(name: 'user_expand') User? user,
    /// The status of the reservation (pending, approved, cancelled)
    @JsonKey(name: 'status') required ReservationStatus status,
    @JsonKey(name: 'parental_license') String? parentalLicense,
    @JsonKey(name: 'login_at') DateTime? loginAt,
    @JsonKey(name: 'logout_at') DateTime? logoutAt,
    @JsonKey(name: 'payment_amount') double? paymentAmount,
    @JsonKey(name: 'payment_receipt') String? paymentReceipt,
    @JsonKey(name: 'food_amount') double? foodAmount,
    @JsonKey(name: 'food_receipt') String? foodReceipt,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'updated') required DateTime updated,
  }) = _HostelReservation;

  /// Creates a HostelReservation instance from JSON data
  factory HostelReservation.fromJson(Map<String, dynamic> json) =>
      _$HostelReservationFromJson(json);
}
