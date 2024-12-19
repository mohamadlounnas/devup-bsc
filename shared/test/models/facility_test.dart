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
    });

    test('should convert Facility to JSON', () {
      final facility = Facility(
        id: '123',
        name: 'Test Facility',
        type: FacilityType.sportClub,
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = facility.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Test Facility');
      expect(json['type'], 'sport_club');
      expect(json['created'], '2023-01-01T00:00:00.000Z');
      expect(json['updated'], '2023-01-01T00:00:00.000Z');
    });
  });
} 