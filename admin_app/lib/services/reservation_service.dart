import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/models/models.dart';

class ReservationService extends ChangeNotifier {
  final PocketBase _pb;
  List<Map<String, dynamic>> _reservations = [];
  bool _loading = false;
  String? _error;

  ReservationService(this._pb);

  List<Map<String, dynamic>> get reservations => _reservations;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchReservations() async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      // Using static data instead of PocketBase fetch
      _reservations = [
        {
          'id': '001',
          'name': 'Event 1',
          'description': 'Description for Event 1',
          'seats': 100,
          'remaining_seats': 50,
          'created': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'status': 'Confirmed',
        },
        {
          'id': '002',
          'name': 'Event 2',
          'description': 'Description for Event 2',
          'seats': 75,
          'remaining_seats': 25,
          'created': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'status': 'Pending',
        },
        {
          'id': '003',
          'name': 'Event 3',
          'description': 'Description for Event 3',
          'seats': 150,
          'remaining_seats': 100,
          'created': DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
          'status': 'Completed',
        },
      ];

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
      if (kDebugMode) {
        print('Error fetching reservations: $e');
      }
    }
  }

  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return '#4CAF50'; // Green
      case 'pending':
        return '#FFA726'; // Orange
      case 'completed':
        return '#2196F3'; // Blue
      default:
        return '#9E9E9E'; // Grey
    }
  }
}
