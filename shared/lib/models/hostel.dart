// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'enums.dart';
import 'hostel_service.dart';
import 'user.dart';

part 'hostel.freezed.dart';
part 'hostel.g.dart';

/// A model class representing a hostel in the system.
/// This class maps to the hostels collection in PocketBase database.
///
/// A hostel is a lodging facility that can have various services,
/// an administrator, and specific status (active, inactive, or partially active).
@freezed
class Hostel with _$Hostel {
  /// Creates a new [Hostel] instance.
  ///
  /// Parameters:
  /// - [id]: Unique identifier for the hostel
  /// - [name]: Name of the hostel
  /// - [capacity]: Optional maximum capacity of the hostel
  /// - [location]: Optional location information
  /// - [address]: Physical address of the hostel
  /// - [phone]: Optional contact phone number
  /// - [status]: Current operational status of the hostel
  /// - [serviceIds]: Optional list of service IDs associated with the hostel
  /// - [services]: Optional expanded list of hostel services
  /// - [adminId]: Optional ID of the administrator user
  /// - [admin]: Optional expanded administrator user object
  /// - [created]: Timestamp when the hostel was created
  /// - [updated]: Timestamp when the hostel was last updated
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

  /// Creates a [Hostel] instance from a JSON map.
  ///
  /// This factory constructor is used to deserialize JSON data into a Hostel object.
  /// It's automatically generated using the freezed package.
  factory Hostel.fromJson(Map<String, dynamic> json) => _$HostelFromJson(json);
} 



// latlong extension
extension HostelLatLong on Hostel {
  LatLng? get latLong {
    try {
    if (location == null) return null;
    final latLong = location!.split(',');
    return LatLng(double.parse(latLong[0]), double.parse(latLong[1]));
    } catch (e) {
      return null;
    }
  }
}
