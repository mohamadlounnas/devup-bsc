// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';
import 'facility_event.dart';

part 'facility_event_registration.freezed.dart';
part 'facility_event_registration.g.dart';

/// A model class representing a registration for a facility event.
/// This class maps to the facilities_events_registrations collection in PocketBase database.
///
/// Each registration links a user to a specific facility event.
@freezed
class FacilityEventRegistration with _$FacilityEventRegistration {
  /// Creates a new [FacilityEventRegistration] instance.
  ///
  /// Parameters:
  /// - [id]: Unique identifier for the registration
  /// - [userId]: ID of the user who registered
  /// - [user]: Optional expanded user object
  /// - [eventId]: ID of the facility event
  /// - [event]: Optional expanded facility event object
  /// - [created]: Timestamp when the registration was created
  /// - [updated]: Timestamp when the registration was last updated
  const factory FacilityEventRegistration({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'user') required String userId,
    @JsonKey(name: 'user_expand') User? user,
    @JsonKey(name: 'event') required String eventId,
    @JsonKey(name: 'event_expand') FacilityEvent? event,
    // attended (datetime?)
    @JsonKey(name: 'attended') DateTime? attended,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'updated') required DateTime updated,
  }) = _FacilityEventRegistration;

  /// Creates a [FacilityEventRegistration] instance from JSON data
  factory FacilityEventRegistration.fromJson(Map<String, dynamic> json) =>
      _$FacilityEventRegistrationFromJson(json);
} 