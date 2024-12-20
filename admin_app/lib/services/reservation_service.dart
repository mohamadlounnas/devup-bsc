import 'package:admin_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/models/hostel_reservation.dart';

class ReservationService extends ChangeNotifier {
  ReservationService._();
  static final ReservationService _instance = ReservationService._();
  static ReservationService get instance => _instance;

  String hostelCollectionName = 'hostels';

  List<RecordModel> hostelReservations = [];

  Future<void> getReservations() async {
    try {
      var reservations = await pb.collection(hostelCollectionName).getFullList(
          filter: 'admin = "${pb.authStore.model!.id}"',
          expand: 'reservations');
      print(reservations);
      hostelReservations = reservations;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
