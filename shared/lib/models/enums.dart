import 'package:json_annotation/json_annotation.dart';

/// Enum representing user types in the system
@JsonEnum()
enum UserType {
  /// Employee user type
  @JsonValue('employee')
  employee,

  /// Client user type
  @JsonValue('client')
  client;
}

/// Enum representing user gender
@JsonEnum()
enum Gender {
  /// Male gender
  @JsonValue('male')
  male,

  /// Female gender
  @JsonValue('female')
  female;
}

/// Enum representing facility types
@JsonEnum()
enum FacilityType {
  /// Sport club facility
  @JsonValue('sport_club')
  sportClub,

  /// Tourist agency facility
  @JsonValue('tourist_agency')
  touristAgency,

  /// Hotel facility
  @JsonValue('hotel')
  hotel,

  /// Museum facility
  @JsonValue('museum')
  museum,

  /// Restaurant facility
  @JsonValue('restaurant')
  restaurant;
}

/// Enum representing hostel status
@JsonEnum()
enum HostelStatus {
  /// Active hostel
  @JsonValue('active')
  active,

  /// Inactive hostel
  @JsonValue('inactive')
  inactive,

  /// Partially active hostel
  @JsonValue('partially')
  partially;
}

/// Enum representing reservation status
@JsonEnum()
enum ReservationStatus {
  /// Pending reservation - initial state when reservation is created
  @JsonValue('pending')
  pending,
  /// Approved reservation - when the reservation is confirmed by admin
  @JsonValue('approved')
  approved,
  /// Cancelled reservation - when the reservation is cancelled by user or admin
  @JsonValue('cancelled')
  cancelled;
}

/// Enum representing service types
@JsonEnum()
enum ServiceType {
  hospitality,
  activity,
  restoration,
}
