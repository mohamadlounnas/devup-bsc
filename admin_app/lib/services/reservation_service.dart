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
      var records = await pb.collection(hostelCollectionName).getFirstListItem(
          'admin = "${pb.authStore.model!.id}"',
          expand: 'reservations,reservations.user');
      print(records);
      if (records.expand != null && records.expand['reservations'] != null) {
        hostelresvalid =
            (records.expand['reservations'] as List).map((reservation) {
          final data = reservation.toJson();
          print(reservation.expand['user']);
          final user = reservation.expand['user'].first;
          data['user_expand'] = user.toJson();
          if (data['status'] == null || data['status'] == '') {
            data['status'] = 'pending';
          }
          return HostelReservation.fromJson(data);
        }).toList();
      }

      return hostelresvalid;
    } catch (e) {
      print('Error loading reservations: $e');
      throw e;
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
