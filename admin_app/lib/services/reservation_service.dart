import 'package:admin_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/models/hostel_reservation.dart';
import 'package:shared/models/models.dart';

class ReservationService extends ChangeNotifier {
  ReservationService._();
  static final ReservationService _instance = ReservationService._();
  static ReservationService get instance => _instance;

  String hostelCollectionName = 'hostels';
  String reservationCollectionName = 'hostels_reservations';

  List<HostelReservation> hostelReservations = [];

  Future<List<HostelReservation>> getReservations() async {
    try {
      List<HostelReservation> hostelresvalid = [];

      // First check if the hostel exists
      final hostels = await pb.collection(hostelCollectionName).getList(
            filter: 'admin = "${pb.authStore.model!.id}"',
            expand: 'reservations,reservations.user',
          );

      if (hostels.items.isEmpty) {
        // No hostel found for this admin
        return [];
      }

      final hostel = hostels.items.first;

      if (hostel.expand != null && hostel.expand['reservations'] != null) {
        hostelresvalid =
            (hostel.expand['reservations'] as List).map((reservation) {
          final data = reservation.toJson();
          if (reservation.expand != null &&
              reservation.expand['user'] != null) {
            final user = reservation.expand['user'].first;
            data['user_expand'] = user.toJson();
          }
          if (data['status'] == null || data['status'] == '') {
            data['status'] = 'pending';
          }
          return HostelReservation.fromJson(data);
        }).toList();
      }

      return hostelresvalid;
    } catch (e) {
      print('Error loading reservations: $e');
      // Return empty list instead of throwing error
      return [];
    }
  }

  Future<RecordModel> createReservation(
    HostelReservation reservation,
  ) async {
    try {
      final record = await pb.collection(reservationCollectionName).create(
            body: reservation.toJson(),
          );

      if (kDebugMode) {
        print('Created reservation: ${record.toJson()}');
      }
      return record;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating reservation: $e');
      }
      throw e;
    }
  }
}
