import 'package:shared/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Facility', () {
    test('should create Facility instance from JSON', () {
      final json = {
        'id': '123',
        'name': 'Test Facility',
        'description': 'A test facility',
        'manager': 'manager123',
        'manager_expand': {
          'id': 'manager123',
          'email': 'manager@example.com',
          'firstname': 'Manager',
          'lastname': 'Test',
          'type': 'employee',
          'gander': 'male',
          'created': '2023-01-01T00:00:00.000Z',
          'updated': '2023-01-01T00:00:00.000Z',
        },
        'logo': 'logo.jpg',
        'cover': 'cover.jpg',
        'type': 'sport_club',
        'location': 'New York',
        'events': ['event1', 'event2'],
        'events_expand': [
          {
            'id': 'event1',
            'name': 'Event 1',
            'description': 'Event 1 description',
            'body': 'Event 1 body',
            'image': 'event1.jpg',
            'started': '2023-01-01T10:00:00.000Z',
            'ended': '2023-01-01T18:00:00.000Z',
            'seats': 50.0,
            'remaining_seats': 30.0,
            'created': '2023-01-01T00:00:00.000Z',
            'updated': '2023-01-01T00:00:00.000Z',
          },
          {
            'id': 'event2',
            'name': 'Event 2',
            'description': 'Event 2 description',
            'body': 'Event 2 body',
            'image': 'event2.jpg',
            'started': '2023-01-02T10:00:00.000Z',
            'ended': '2023-01-02T18:00:00.000Z',
            'seats': 100.0,
            'remaining_seats': 75.0,
            'created': '2023-01-01T00:00:00.000Z',
            'updated': '2023-01-01T00:00:00.000Z',
          },
        ],
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final facility = Facility.fromJson(json);

      expect(facility.id, '123');
      expect(facility.name, 'Test Facility');
      expect(facility.description, 'A test facility');
      expect(facility.managerId, 'manager123');
      expect(facility.manager?.id, 'manager123');
      expect(facility.manager?.email, 'manager@example.com');
      expect(facility.logo, 'logo.jpg');
      expect(facility.cover, 'cover.jpg');
      expect(facility.type, FacilityType.sportClub);
      expect(facility.location, 'New York');
      expect(facility.eventIds, ['event1', 'event2']);
      expect(facility.events?.length, 2);
      expect(facility.events?[0].id, 'event1');
      expect(facility.events?[0].name, 'Event 1');
      expect(facility.events?[1].id, 'event2');
      expect(facility.events?[1].name, 'Event 2');
      expect(facility.created, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(facility.updated, DateTime.parse('2023-01-01T00:00:00.000Z'));
    });

    test('should handle null optional fields', () {
      final json = {
        'id': '123',
        'name': 'Test Facility',
        'type': 'sport_club',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final facility = Facility.fromJson(json);

      expect(facility.description, null);
      expect(facility.managerId, null);
      expect(facility.manager, null);
      expect(facility.logo, null);
      expect(facility.cover, null);
      expect(facility.location, null);
      expect(facility.eventIds, null);
      expect(facility.events, null);
    });

    test('should convert Facility to JSON', () {
      final facility = Facility(
        id: '123',
        name: 'Test Facility',
        type: FacilityType.sportClub,
        eventIds: ['event1', 'event2'],
        events: [
          FacilityEvent(
            id: 'event1',
            name: 'Event 1',
            created: DateTime.parse('2023-01-01T00:00:00.000Z'),
            updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
          ),
          FacilityEvent(
            id: 'event2',
            name: 'Event 2',
            created: DateTime.parse('2023-01-01T00:00:00.000Z'),
            updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
          ),
        ],
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = facility.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Test Facility');
      expect(json['type'], 'sport_club');
      expect(json['events'], ['event1', 'event2']);
      expect(json['created'], '2023-01-01T00:00:00.000Z');
      expect(json['updated'], '2023-01-01T00:00:00.000Z');
    });
  });
} 