import 'package:app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:shared/models/facility_event.dart';
import 'package:shared/shared.dart';

/// Provider that manages event registrations state and operations
class EventRegistrationProvider extends ChangeNotifier {
  final Map<String, bool> _registeredEvents = {};
  bool _isLoading = false;
  String? _error;

  /// Whether any operation is in progress
  bool get isLoading => _isLoading;
  
  /// Current error message, if any
  String? get error => _error;

  /// Checks if a user is registered for a specific event
  bool isRegistered(String eventId) => _registeredEvents[eventId] ?? false;

  /// Loads user registrations for given events
  Future<void> loadRegistrations(String userId, List<String> eventIds) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await pb.collection('facilities_events_registrations').getList(
        filter: 'user = "$userId"',
      );

      for (final record in response.items) {
        final eventId = record.data['event'] as String;
        _registeredEvents[eventId] = true;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registers a user for an event
  Future<bool> registerForEvent(String userId, FacilityEvent event) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await pb.collection('facilities_events_registrations').create(body: {
        'user': userId,
        'event': event.id,
      });

      _registeredEvents[event.id] = true;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Unregisters a user from an event
  Future<bool> unregisterFromEvent(String userId, String eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await pb.collection('facilities_events_registrations').getList(
        filter: 'user = "$userId" && event = "$eventId"',
      );

      if (response.items.isNotEmpty) {
        await pb.collection('facilities_events_registrations').delete(response.items.first.id);
      }

      _registeredEvents.remove(eventId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears all registration data
  void clear() {
    _registeredEvents.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Add debug method
  void debugPrintRegistrations() {
    print('Registered Events: $_registeredEvents');
  }
} 