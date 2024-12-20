import 'package:shared/models/models.dart';
import 'package:test/test.dart';

/// Test suite for [FacilityEventRegistration] model
void main() {
  group('FacilityEventRegistration', () {
    test('should create FacilityEventRegistration instance from JSON with expanded fields', () {
      final json = {
        'id': '123',
        'user': 'user123',
        'user_expand': {
          'id': 'user123',
          'email': 'user@example.com',
          'firstname': 'John',
          'lastname': 'Doe',
          'type': 'client',
          'gender': 'male',
          'phone': '+1234567890',
          'created': '2023-01-01T00:00:00.000Z',
          'updated': '2023-01-01T00:00:00.000Z',
        },
        'event': 'event123',
        'event_expand': {
          'id': 'event123',
          'name': 'Test Event',
          'description': 'A test event',
          'seats': 50,
          'remaining_seats': 30,
          'facility': 'facility123',
          'created': '2023-01-01T00:00:00.000Z',
          'updated': '2023-01-01T00:00:00.000Z',
        },
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final registration = FacilityEventRegistration.fromJson(json);

      // Verify base fields
      expect(registration.id, '123');
      expect(registration.userId, 'user123');
      expect(registration.eventId, 'event123');
      expect(registration.created, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(registration.updated, DateTime.parse('2023-01-01T00:00:00.000Z'));

      // Verify expanded user fields
      expect(registration.user?.id, 'user123');
      expect(registration.user?.email, 'user@example.com');
      expect(registration.user?.firstname, 'John');
      expect(registration.user?.lastname, 'Doe');
      expect(registration.user?.phone, '+1234567890');

      // Verify expanded event fields
      expect(registration.event?.id, 'event123');
      expect(registration.event?.name, 'Test Event');
      expect(registration.event?.description, 'A test event');
      expect(registration.event?.seats, 50);
      expect(registration.event?.remainingSeats, 30);
    });

    test('should handle null expanded fields', () {
      final json = {
        'id': '123',
        'user': 'user123',
        'event': 'event123',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final registration = FacilityEventRegistration.fromJson(json);

      expect(registration.id, '123');
      expect(registration.userId, 'user123');
      expect(registration.eventId, 'event123');
      expect(registration.user, null);
      expect(registration.event, null);
      expect(registration.created, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(registration.updated, DateTime.parse('2023-01-01T00:00:00.000Z'));
    });

    test('should convert FacilityEventRegistration to JSON', () {
      final registration = FacilityEventRegistration(
        id: '123',
        userId: 'user123',
        eventId: 'event123',
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = registration.toJson();

      expect(json['id'], '123');
      expect(json['user'], 'user123');
      expect(json['event'], 'event123');
      expect(json['created'], '2023-01-01T00:00:00.000Z');
      expect(json['updated'], '2023-01-01T00:00:00.000Z');
    });
  });
} 