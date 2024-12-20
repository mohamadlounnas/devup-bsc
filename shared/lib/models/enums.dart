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
  /// Pending reservation
  @JsonValue('pending')
  pending,

  /// Confirmed reservation
  @JsonValue('confirmed')
  confirmed,

  /// Completed reservation
  @JsonValue('completed')
  completed;
}

/// Enum representing service types
@JsonEnum()
enum ServiceType {
  hospitality,
  activities,
  restoration,
  unknown,
}
