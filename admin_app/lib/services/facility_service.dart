import 'package:admin_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:shared/models/models.dart';

class FacilityService extends ChangeNotifier {
  FacilityService._();
  static final FacilityService _instance = FacilityService._();
  static FacilityService get instance => _instance;

  String facilityCollectionName = 'facilities';
  Facility? userFacility;
  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> getFacilityByUser() async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      var record = await pb
          .collection(facilityCollectionName)
          .getFirstListItem('manager = "${pb.authStore.model!.id}"');

      record.data.addAll(
        {
          'created': record.created,
          'updated': record.updated,
          'id': record.id,
        },
      );

      userFacility = Facility.fromJson(record.data);

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      print(e);
      notifyListeners();
      throw e;
    }
  }

  Future<void> updateFacility(Facility updatedFacility) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final record = await pb
          .collection(facilityCollectionName)
          .update(updatedFacility.id, body: updatedFacility.toJson());

      userFacility = updatedFacility;

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }
}
