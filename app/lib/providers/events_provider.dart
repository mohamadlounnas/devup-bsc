import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/shared.dart';

import '../main.dart';

/// Provider that manages facility events with real-time updates
class EventsProvider extends ChangeNotifier {
  final ApiService _api;
  List<FacilityEvent> _events = [];
  String? _error;
  bool _isLoading = true;
  UnsubscribeFunc? _unsubscribe;

  /// Creates a new events provider
  EventsProvider() : _api = ApiService(pb);

  /// The current list of events
  List<FacilityEvent> get events => _events;

  /// The current error message, if any
  String? get error => _error;

  /// Whether the provider is currently loading data
  bool get isLoading => _isLoading;

  /// Subscribes to real-time updates for facility events
  Future<void> subscribeToEvents() async {
    try {
      // Initial fetch
      _events = await _api.getFacilityEvents();
      _error = null;
      _isLoading = false;
      notifyListeners();

      // Subscribe to real-time updates
      _unsubscribe = await _api.pb
          .collection('facility_events')
          .subscribe('*', (e) async {
        // Refetch all events when any change occurs
        try {
          _events = await _api.getFacilityEvents();
          _error = null;
          notifyListeners();
        } catch (e) {
          _error = e.toString();
          notifyListeners();
        }
      });
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _unsubscribe?.call();
    super.dispose();
  }
} 