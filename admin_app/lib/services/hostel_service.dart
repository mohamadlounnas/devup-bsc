import 'package:admin_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:shared/models/models.dart';

class HostelServices extends ChangeNotifier {
  HostelServices._();
  static final HostelServices _instance = HostelServices._();
  static HostelServices get instance => _instance;

  String hostelCollectionName = 'hostels';
  Hostel? userHostel;
  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> getHostelByUser() async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      var record = await pb
          .collection(hostelCollectionName)
          .getFirstListItem('admin = "${pb.authStore.model!.id}"');

      record.data.addAll(
        {
          'created': record.created,
          'updated': record.updated,
          'id': record.id,
        },
      );

      userHostel = Hostel.fromJson(record.data);

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      if (kDebugMode) {
        print('Error getting hostel: $e');
      }
      notifyListeners();
      throw e;
    }
  }

  Future<void> updateHostel(Hostel updatedHostel) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final record = await pb
          .collection(hostelCollectionName)
          .update(updatedHostel.id, body: updatedHostel.toJson());

      userHostel = updatedHostel;

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      if (kDebugMode) {
        print('Error updating hostel: $e');
      }
      notifyListeners();
      throw e;
    }
  }
}
