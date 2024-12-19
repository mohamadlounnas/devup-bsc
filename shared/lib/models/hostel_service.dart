// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'hostel_service.freezed.dart';
part 'hostel_service.g.dart';

/// HostelService model representing the hostels_services collection in PocketBase
@freezed
class HostelService with _$HostelService {
  const factory HostelService({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'updated') required DateTime updated,
  }) = _HostelService;

  /// Creates a HostelService instance from JSON data
  factory HostelService.fromJson(Map<String, dynamic> json) => _$HostelServiceFromJson(json);
} 