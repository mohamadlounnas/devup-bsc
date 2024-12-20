// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'enums.dart';
import 'user.dart';
import 'facility_event.dart';

part 'facility.freezed.dart';
part 'facility.g.dart';

/// A model class representing a facility in the system.
/// This class maps to the facilities collection in PocketBase database.
///
/// A facility can be of different types (sport club, tourist agency, etc.)
/// and can be managed by a user (manager). It can also host various events.
@freezed
class Facility with _$Facility {
  /// Creates a new [Facility] instance.
  ///
  /// Parameters:
  /// - [id]: Unique identifier for the facility
  /// - [name]: Name of the facility
  /// - [description]: Optional description of the facility
  /// - [managerId]: Optional ID of the user managing this facility
  /// - [manager]: Optional expanded manager user object
  /// - [logo]: Optional logo file ID/path
  /// - [cover]: Optional cover image file ID/path
  /// - [type]: Type of the facility (e.g., sport_club, tourist_agency)
  /// - [location]: Optional location information
  /// - [eventIds]: Optional list of event IDs associated with the facility
  /// - [events]: Optional expanded list of facility events
  /// - [created]: Timestamp when the facility was created
  /// - [updated]: Timestamp when the facility was last updated
  factory Facility({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'manager') String? managerId,
    @JsonKey(name: 'manager_expand') User? manager,
    @JsonKey(name: 'logo') String? logo,
    @JsonKey(name: 'cover') String? cover,
    @JsonKey(name: 'type') required FacilityType type,
    @JsonKey(name: 'location') String? location,
    @JsonKey(name: 'events') List<String>? eventIds,
    @JsonKey(name: 'events_expand') List<FacilityEvent>? events,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'updated') required DateTime updated,
  }) = _Facility;

  /// Creates a [Facility] instance from a JSON map.
  ///
  /// This factory constructor is used to deserialize JSON data into a Facility object.
  /// It's automatically generated using the freezed package.
  factory Facility.fromJson(Map<String, dynamic> json) => _$FacilityFromJson(json);
} 


// location is a string lat,lng separated by comma
// so we need to convert it to LatLng for easy use
extension Location on Facility {
  LatLng? get locationLatLng {
    if (location == null) return null;
    final parts = location!.split(',');
    if (parts.length != 2) return null;
    return LatLng(double.parse(parts[0]), double.parse(parts[1]));
  }
}


