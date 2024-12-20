import 'package:shared/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('FacilityEvent', () {
    test('should create FacilityEvent instance from JSON', () {
      final json = {
        'id': '123',
        'name': 'Test Event',
        'description': 'A test event',
        'body': 'Event body content',
        'image': 'event.jpg',
        'started': '2023-01-01T10:00:00.000Z',
        'ended': '2023-01-01T18:00:00.000Z',
        'seats': 50.0,
        'location': '40.7128,-74.0060',
        'address': '123 Test Street, New York, NY 10001',
        'remaining_seats': 30.0,
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final event = FacilityEvent.fromJson(json);

      expect(event.id, '123');
      expect(event.name, 'Test Event');
      expect(event.description, 'A test event');
      expect(event.body, 'Event body content');
      expect(event.image, 'event.jpg');
      expect(event.started, DateTime.parse('2023-01-01T10:00:00.000Z'));
      expect(event.ended, DateTime.parse('2023-01-01T18:00:00.000Z'));
      expect(event.seats, 50.0);
      expect(event.location, '40.7128,-74.0060');
      expect(event.address, '123 Test Street, New York, NY 10001');
      expect(event.remainingSeats, 30.0);
      expect(event.created, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(event.updated, DateTime.parse('2023-01-01T00:00:00.000Z'));
    });

    test('should handle null optional fields', () {
      final json = {
        'id': '123',
        'name': 'Test Event',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final event = FacilityEvent.fromJson(json);

      expect(event.description, null);
      expect(event.body, null);
      expect(event.image, null);
      expect(event.started, null);
      expect(event.ended, null);
      expect(event.seats, null);
      expect(event.location, null);
      expect(event.address, null);
      expect(event.remainingSeats, null);
    });

    test('should convert FacilityEvent to JSON', () {
      final event = FacilityEvent(
        id: '123',
        name: 'Test Event',
        description: 'A test event',
        body: 'Event body content',
        image: 'event.jpg',
        started: DateTime.parse('2023-01-01T10:00:00.000Z'),
        ended: DateTime.parse('2023-01-01T18:00:00.000Z'),
        seats: 50.0,
        location: '40.7128,-74.0060',
        address: '123 Test Street, New York, NY 10001',
        remainingSeats: 30.0,
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = event.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Test Event');
      expect(json['description'], 'A test event');
      expect(json['body'], 'Event body content');
      expect(json['image'], 'event.jpg');
      expect(json['started'], '2023-01-01T10:00:00.000Z');
      expect(json['ended'], '2023-01-01T18:00:00.000Z');
      expect(json['seats'], 50.0);
      expect(json['location'], '40.7128,-74.0060');
      expect(json['address'], '123 Test Street, New York, NY 10001');
      expect(json['remaining_seats'], 30.0);
      expect(json['created'], '2023-01-01T00:00:00.000Z');
      expect(json['updated'], '2023-01-01T00:00:00.000Z');
    });

    test('should validate seat constraints', () {
      final event = FacilityEvent(
        id: '123',
        name: 'Test Event',
        seats: 50.0,
        remainingSeats: 30.0,
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      expect(event.remainingSeats!, lessThanOrEqualTo(event.seats!));
    });

    test('should validate date constraints', () {
      final event = FacilityEvent(
        id: '123',
        name: 'Test Event',
        started: DateTime.parse('2023-01-01T10:00:00.000Z'),
        ended: DateTime.parse('2023-01-01T18:00:00.000Z'),
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      expect(event.ended!.isAfter(event.started!), true);
    });

    test('should parse location to LatLng', () {
      final event = FacilityEvent(
        id: '123',
        name: 'Test Event',
        location: '40.7128,-74.0060',
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final latLng = event.locationLatLng;
      expect(latLng, isNotNull);
      expect(latLng!.latitude, 40.7128);
      expect(latLng.longitude, -74.0060);
    });
  });
} 