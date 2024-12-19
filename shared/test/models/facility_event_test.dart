import 'package:shared/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('FacilityEvent', () {
    test('should create FacilityEvent instance from JSON', () {
      final json = {
        'id': '123',
        'image': 'event.jpg',
        'name': 'Test Event',
        'description': 'A test event',
        'body': 'Event body content',
        'started': '2023-01-01T10:00:00.000Z',
        'ended': '2023-01-01T18:00:00.000Z',
        'seats': 100.0,
        'remaining_seats': 50.0,
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final event = FacilityEvent.fromJson(json);

      expect(event.id, '123');
      expect(event.image, 'event.jpg');
      expect(event.name, 'Test Event');
      expect(event.description, 'A test event');
      expect(event.body, 'Event body content');
      expect(event.started, DateTime.parse('2023-01-01T10:00:00.000Z'));
      expect(event.ended, DateTime.parse('2023-01-01T18:00:00.000Z'));
      expect(event.seats, 100.0);
      expect(event.remainingSeats, 50.0);
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

      expect(event.image, null);
      expect(event.description, null);
      expect(event.body, null);
      expect(event.started, null);
      expect(event.ended, null);
      expect(event.seats, null);
      expect(event.remainingSeats, null);
    });

    test('should convert FacilityEvent to JSON', () {
      final event = FacilityEvent(
        id: '123',
        name: 'Test Event',
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = event.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Test Event');
      expect(json['created'], '2023-01-01T00:00:00.000Z');
      expect(json['updated'], '2023-01-01T00:00:00.000Z');
    });
  });
} 