// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'hostel_service.dart';
import 'user.dart';

part 'hostel.freezed.dart';
part 'hostel.g.dart';

/// Hostel model representing the hostels collection in PocketBase
@freezed
class Hostel with _$Hostel {
  const factory Hostel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'capacity') double? capacity,
    @JsonKey(name: 'location') String? location,
    @JsonKey(name: 'address') required String address,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'status') required HostelStatus status,
    @JsonKey(name: 'services') List<String>? serviceIds,
    @JsonKey(name: 'services_expand') List<HostelService>? services,
    @JsonKey(name: 'admin') String? adminId,
    @JsonKey(name: 'admin_expand') User? admin,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'updated') required DateTime updated,
  }) = _Hostel;

  /// Creates a Hostel instance from JSON data
  factory Hostel.fromJson(Map<String, dynamic> json) => _$HostelFromJson(json);
} 