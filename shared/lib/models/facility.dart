// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'user.dart';

part 'facility.freezed.dart';
part 'facility.g.dart';

/// Facility model representing the facilities collection in PocketBase
@freezed
class Facility with _$Facility {
  const factory Facility({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'manager') String? managerId,
    @JsonKey(name: 'manager_expand') User? manager,
    @JsonKey(name: 'logo') String? logo,
    @JsonKey(name: 'cover') String? cover,
    @JsonKey(name: 'type') required FacilityType type,
    @JsonKey(name: 'location') String? location,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'updated') required DateTime updated,
  }) = _Facility;

  /// Creates a Facility instance from JSON data
  factory Facility.fromJson(Map<String, dynamic> json) => _$FacilityFromJson(json);
} 