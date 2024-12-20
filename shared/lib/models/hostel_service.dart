// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'hostel_service.freezed.dart';
part 'hostel_service.g.dart';

const _serviceTypeEnumMap = {
  ServiceType.hospitality: 'hospitality',
  ServiceType.activity: 'activity',
  ServiceType.restoration: 'restoration',
  ServiceType.reservation: 'reservation',
  ServiceType.unknown: 'unknown',
};

/// Custom converter for ServiceType that can handle both string and array formats
class ServiceTypeConverter implements JsonConverter<ServiceType, dynamic> {
  const ServiceTypeConverter();

  @override
  ServiceType fromJson(dynamic json) {
    if (json is List && json.isNotEmpty) {
      // If it's an array, take the first value
      json = json.first;
    }
    return $enumDecode(_serviceTypeEnumMap, json);
  }

  @override
  dynamic toJson(ServiceType type) => _serviceTypeEnumMap[type]!;
}

/// HostelService model representing the hostels_services collection in PocketBase
@freezed
class HostelService with _$HostelService {
  const factory HostelService({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @ServiceTypeConverter() @JsonKey(name: 'type') required ServiceType type,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'updated') required DateTime updated,
  }) = _HostelService;

  /// Creates a HostelService instance from JSON data
  factory HostelService.fromJson(Map<String, dynamic> json) =>
      _$HostelServiceFromJson(json);
}
