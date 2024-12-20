import 'package:app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';

/// A provider that manages the state and data fetching for facilities
class FacilitiesProvider extends ChangeNotifier {
  final String _collectionName = 'facilities';
  List<Facility> _facilities = [];
  bool _loading = false;
  String? _error;

  List<Facility> get facilities => _facilities;
  bool get isLoading => _loading;
  String? get error => _error;

  /// Loads all facilities from the backend
  Future<void> loadFacilities() async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final records = await pb.collection(_collectionName).getFullList(
        expand: 'manager,events',
      );

      _facilities = records.map((record) {
        record.data.addAll({
          'created': record.created,
          'updated': record.updated,
          'id': record.id,
        });
        return Facility.fromJson(record.data);
      }).toList();

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  /// Refreshes the facilities list
  Future<void> refresh() => loadFacilities();

  /// Gets a facility by its ID
  Facility? getFacilityById(String id) {
    try {
      return _facilities.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }
} 