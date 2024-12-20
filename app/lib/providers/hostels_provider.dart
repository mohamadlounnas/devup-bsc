import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';

/// A provider class that manages hostel data and notifies listeners of changes
class HostelsProvider extends ChangeNotifier {
  /// The list of all hostels
  List<Hostel> _hostels = [];

  /// Whether the provider is currently loading data
  bool _isLoading = false;

  /// Error message if loading fails
  String? _error;

  /// Gets the list of all hostels
  List<Hostel> get hostels => _hostels;

  /// Gets whether the provider is currently loading data
  bool get isLoading => _isLoading;

  /// Gets the current error message, if any
  String? get error => _error;

  /// Loads the list of hostels from the backend
  Future<void> loadHostels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final records = await pb.collection('hostels').getFullList(
        sort: '-created',
      );
      
      _hostels = records.map((record) => Hostel.fromJson(record.toJson())).toList();
    } catch (e, stackTrace) {
      _error = 'Failed to load hostels: ${e.toString()}';
      debugPrint('Error loading hostels: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filters hostels based on search query and other filters
  List<Hostel> filterHostels({
    String? searchQuery,
    List<String>? amenities,
    double? maxDistanceKm,
    LatLng? fromLocation,
    double? minCapacity,
    HostelStatus? status,
  }) {
    final distance = const Distance();

    return _hostels.where((hostel) {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!hostel.name.toLowerCase().contains(query) &&
            !(hostel.address?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }

      if (maxDistanceKm != null && hostel.latLong != null ) {
        final fromLocation= LatLng(0, 0);
        final distanceInKm = distance.as(LengthUnit.Kilometer, fromLocation, hostel.latLong!);
        if (distanceInKm > maxDistanceKm) {
          return false;
        }
      }

      if (minCapacity != null && (hostel.capacity ?? 0) < minCapacity) {
        return false;
      }

      if (status != null && hostel.status != status) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Clears any error message
  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
} 