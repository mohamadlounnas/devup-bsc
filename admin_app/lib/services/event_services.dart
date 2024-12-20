import 'package:admin_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:shared/models/models.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class EventServices extends ChangeNotifier {
  // Singleton pattern
  EventServices._();
  static final EventServices _instance = EventServices._();
  static EventServices get instance => _instance;

  // Collection names
  final String eventCollectionName = 'facilities_events';
  final String registrationCollectionName = 'facilities_events_registrations';

  // State variables
  bool _loading = false;
  String? _error;

  // Getters
  bool get loading => _loading;
  String? get error => _error;

  /// Get all events for a facility
  Future<List<FacilityEvent>> getEvents() async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final records = await pb.collection(eventCollectionName).getFullList(
            expand: 'facility',
          );

      final events = records.map((record) {
        // Add created and updated fields to the record data
        record.data.addAll({
          'created': record.created,
          'updated': record.updated,
          'id': record.id,
        });

        // Add expanded facility data if available
        if (record.expand != null && record.expand['facility'] != null) {
          record.data['facility_expand'] = record.expand['facility'];
        }

        return FacilityEvent.fromJson(record.data);
      }).toList();

      _loading = false;
      notifyListeners();
      return events;
    } catch (e) {
      _loading = false;
      _error = e.toString();
      if (kDebugMode) {
        print('Error getting events: $e');
      }
      notifyListeners();
      throw e;
    }
  }

  /// Get registrations for an event
  Future<List<RecordModel>> getEventRegistrations(String eventId) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final records =
          await pb.collection(registrationCollectionName).getFullList(
                filter: 'event = "$eventId"',
                expand: 'user',
              );

      _loading = false;
      notifyListeners();
      return records;
    } catch (e) {
      _loading = false;
      _error = e.toString();
      if (kDebugMode) {
        print('Error getting event registrations: $e');
      }
      notifyListeners();
      throw e;
    }
  }

  /// Create a new event
  Future<FacilityEvent> createEvent(FacilityEvent event) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final record = await pb.collection(eventCollectionName).create(
            body: event.toJson(),
          );

      final newEvent = FacilityEvent.fromJson({
        ...record.data,
        'created': record.created,
        'updated': record.updated,
        'id': record.id,
      });

      _loading = false;
      notifyListeners();
      return newEvent;
    } catch (e) {
      _loading = false;
      _error = e.toString();
      if (kDebugMode) {
        print('Error creating event: $e');
      }
      notifyListeners();
      throw e;
    }
  }

  /// Update an existing event
  Future<FacilityEvent> updateEvent(FacilityEvent event) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final record = await pb.collection(eventCollectionName).update(
            event.id,
            body: event.toJson(),
          );

      final updatedEvent = FacilityEvent.fromJson({
        ...record.data,
        'created': record.created,
        'updated': record.updated,
        'id': record.id,
      });

      _loading = false;
      notifyListeners();
      return updatedEvent;
    } catch (e) {
      _loading = false;
      _error = e.toString();
      if (kDebugMode) {
        print('Error updating event: $e');
      }
      notifyListeners();
      throw e;
    }
  }

  /// Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      await pb.collection(eventCollectionName).delete(eventId);

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      if (kDebugMode) {
        print('Error deleting event: $e');
      }
      notifyListeners();
      throw e;
    }
  }

  /// Register a user for an event
  Future<void> registerUserForEvent(String eventId, String userId) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      await pb.collection(registrationCollectionName).create(
        body: {
          'event': eventId,
          'user': userId,
        },
      );

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      if (kDebugMode) {
        print('Error registering user for event: $e');
      }
      notifyListeners();
      throw e;
    }
  }

  /// Cancel a user's registration for an event
  Future<void> cancelEventRegistration(String registrationId) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      await pb.collection(registrationCollectionName).delete(registrationId);

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = e.toString();
      if (kDebugMode) {
        print('Error canceling event registration: $e');
      }
      notifyListeners();
      throw e;
    }
  }

  /// Create a new event with image
  Future<FacilityEvent> createEventWithImage(
    FacilityEvent event,
    PlatformFile image,
  ) async {
    try {
      var record = await pb.collection('facilities_events').create(
            body: event.toJson(),
            files: kIsWeb
                ? [
                    http.MultipartFile.fromBytes(
                      'image',
                      image.bytes!,
                      filename: image.name,
                    )
                  ]
                : [
                    await http.MultipartFile.fromPath(
                      'image',
                      image.path!,
                      filename: image.name,
                    )
                  ],
          );

      return FacilityEvent.fromJson({
        ...record.data,
        'created': record.created,
        'updated': record.updated,
        'id': record.id,
      });
    } catch (e) {
      rethrow;
    }
  }
}
