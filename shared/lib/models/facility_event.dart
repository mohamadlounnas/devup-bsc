// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'facility_event.freezed.dart';
part 'facility_event.g.dart';

/// A model class representing an event hosted by a facility.
/// This class maps to the facilities_events collection in PocketBase database.
///
/// Events can have details like name, description, start/end dates,
/// and seat capacity management.
@freezed
class FacilityEvent with _$FacilityEvent {
  /// Creates a new [FacilityEvent] instance.
  ///
  /// Parameters:
  /// - [id]: Unique identifier for the event
  /// - [name]: Name of the event
  /// - [description]: Optional description of the event
  /// - [body]: Optional detailed content/body of the event
  /// - [image]: Optional event image file ID/path
  /// - [started]: Optional start date of the event
  /// - [ended]: Optional end date of the event
  /// - [seats]: Optional total number of available seats
  /// - [remainingSeats]: Optional number of remaining available seats
  /// - [location]: Optional location coordinates (format: "lat,lng")
  /// - [address]: Optional physical address of the event
  /// - [created]: Timestamp when the event was created
  /// - [updated]: Timestamp when the event was last updated
  factory FacilityEvent({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'body') String? body,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'started') DateTime? started,
    @JsonKey(name: 'ended') DateTime? ended,
    @JsonKey(name: 'seats') double? seats,
    @JsonKey(name: 'location') String? location,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'remaining_seats') double? remainingSeats,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'updated') required DateTime updated,
  }) = _FacilityEvent;

  /// Creates a [FacilityEvent] instance from a JSON map.
  ///
  /// This factory constructor is used to deserialize JSON data into a FacilityEvent object.
  /// It's automatically generated using the freezed package.
  factory FacilityEvent.fromJson(Map<String, dynamic> json) => _$FacilityEventFromJson(json);
}

extension FacilityLocationLatLng on FacilityEvent {
  LatLng? get locationLatLng {
    if (location == null) return null;
    final parts = location!.split(',');
    if (parts.length != 2) return null;
    return LatLng(double.parse(parts[0]), double.parse(parts[1]));
  }
}
