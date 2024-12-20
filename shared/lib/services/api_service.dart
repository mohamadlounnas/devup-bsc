import 'package:pocketbase/pocketbase.dart';
import '../models/models.dart';

/// Service for interacting with the PocketBase API
class ApiService {
  /// PocketBase client instance
  final PocketBase pb;

  /// Constructor
  ApiService(this.pb);

  /// Get a user by ID
  Future<User> getUser(String id) async {
    final record = await pb.collection('users').getOne(id);
    return User.fromJson(record.toJson());
  }

  /// Get all users
  Future<List<User>> getUsers() async {
    final records = await pb.collection('users').getFullList();
    return records.map((r) => User.fromJson(r.toJson())).toList();
  }

  /// Get a facility by ID
  Future<Facility> getFacility(String id) async {
    final record = await pb.collection('facilities').getOne(id);
    return Facility.fromJson(record.toJson());
  }

  /// Get all facilities
  Future<List<Facility>> getFacilities() async {
    final records = await pb.collection('facilities').getFullList();
    return records.map((r) => Facility.fromJson(r.toJson())).toList();
  }

  /// Get a hostel by ID
  Future<Hostel> getHostel(String id) async {
    final record = await pb.collection('hostels').getOne(id);
    return Hostel.fromJson(record.toJson());
  }

  /// Get all hostels
  Future<List<Hostel>> getHostels() async {
    final records = await pb.collection('hostels').getFullList();
    return records.map((r) => Hostel.fromJson(r.toJson())).toList();
  }

  /// Get a hostel service by ID
  Future<HostelService> getHostelService(String id) async {
    final record = await pb.collection('hostels_services').getOne(id);
    return HostelService.fromJson(record.toJson());
  }

  /// Get all hostel services
  Future<List<HostelService>> getHostelServices() async {
    final records = await pb.collection('hostels_services').getFullList();
    return records.map((r) => HostelService.fromJson(r.toJson())).toList();
  }

  /// Get a hostel reservation by ID
  Future<HostelReservation> getHostelReservation(String id) async {
    final record = await pb.collection('hostels_reservations').getOne(id);
    return HostelReservation.fromJson(record.toJson());
  }

  /// Get all hostel reservations
  Future<List<HostelReservation>> getHostelReservations() async {
    final records = await pb.collection('hostels_reservations').getFullList();
    return records.map((r) => HostelReservation.fromJson(r.toJson())).toList();
  }

  /// Get a facility event by ID
  Future<FacilityEvent> getFacilityEvent(String id) async {
    final record = await pb.collection('facilities_events').getOne(id);
    return FacilityEvent.fromJson(record.toJson());
  }

  /// Get all facility events
  Future<List<FacilityEvent>> getFacilityEvents() async {
    final records = await pb.collection('facilities_events').getFullList();
    return records.map((r) => FacilityEvent.fromJson(r.toJson())).toList();
  }

  Future<HostelReservation> createHostelReservation(
      HostelReservation reservation) async {
    final record = await pb
        .collection('hostels_reservations')
        .create(body: reservation.toJson());
    return HostelReservation.fromJson(record.toJson());
  }

  /// Create a new hostel service
  Future<HostelService> createHostelService(HostelService service) async {
    final record =
        await pb.collection('hostels_services').create(body: service.toJson());
    return HostelService.fromJson(record.toJson());
  }
}
