import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';

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
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      _hostels = [
        Hostel(
          id: '1',
          name: 'Student Haven',
          capacity: 100,
          location: '0.5km from campus',
          address: '123 University Ave',
          phone: '+1234567890',
          status: HostelStatus.active,
          created: DateTime.now(),
          updated: DateTime.now(),
        ),
        Hostel(
          id: '2',
          name: 'Campus Lodge',
          capacity: 150,
          location: '0.8km from campus',
          address: '456 College St',
          phone: '+1234567891',
          status: HostelStatus.partially,
          created: DateTime.now(),
          updated: DateTime.now(),
        ),
        Hostel(
          id: '3',
          name: 'University Dorms',
          capacity: 200,
          location: '1.2km from campus',
          address: '789 College St',
          phone: '+1234567892',
          status: HostelStatus.inactive,
          created: DateTime.now(),
          updated: DateTime.now(),
        ),
      ];
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
    String? maxDistance,
    double? minCapacity,
    HostelStatus? status,
  }) {
    return _hostels.where((hostel) {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!hostel.name.toLowerCase().contains(query) &&
            !(hostel.address?.toLowerCase().contains(query) ?? false) &&
            !(hostel.location?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }

      if (maxDistance != null && hostel.location != null) {
        // Extract numeric value from location string (e.g., "0.5km from campus")
        final distance = double.tryParse(hostel.location!.split('km').first);
        final maxDist = double.tryParse(maxDistance.split('km').first);
        if (distance != null && maxDist != null && distance > maxDist) {
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