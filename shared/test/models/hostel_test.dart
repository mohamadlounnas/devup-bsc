import 'package:shared/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Hostel', () {
    test('should create Hostel instance from JSON', () {
      final json = {
        'id': '123',
        'name': 'Test Hostel',
        'capacity': 100.0,
        'location': 'New York',
        'address': '123 Main St',
        'phone': '+1234567890',
        'status': 'active',
        'services': ['service1', 'service2'],
        'services_expand': [
          {
            'id': 'service1',
            'name': 'Service 1',
            'description': 'Service 1 description',
            'icon': 'icon1.jpg',
            'created': '2023-01-01T00:00:00.000Z',
            'updated': '2023-01-01T00:00:00.000Z',
          },
          {
            'id': 'service2',
            'name': 'Service 2',
            'description': 'Service 2 description',
            'icon': 'icon2.jpg',
            'created': '2023-01-01T00:00:00.000Z',
            'updated': '2023-01-01T00:00:00.000Z',
          },
        ],
        'admin': 'admin123',
        'admin_expand': {
          'id': 'admin123',
          'email': 'admin@example.com',
          'firstname': 'Admin',
          'lastname': 'Test',
          'type': 'employee',
          'gander': 'male',
          'created': '2023-01-01T00:00:00.000Z',
          'updated': '2023-01-01T00:00:00.000Z',
        },
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final hostel = Hostel.fromJson(json);

      expect(hostel.id, '123');
      expect(hostel.name, 'Test Hostel');
      expect(hostel.capacity, 100.0);
      expect(hostel.location, 'New York');
      expect(hostel.address, '123 Main St');
      expect(hostel.phone, '+1234567890');
      expect(hostel.status, HostelStatus.active);
      expect(hostel.serviceIds, ['service1', 'service2']);
      expect(hostel.services?.length, 2);
      expect(hostel.services?[0].id, 'service1');
      expect(hostel.services?[1].id, 'service2');
      expect(hostel.adminId, 'admin123');
      expect(hostel.admin?.id, 'admin123');
      expect(hostel.admin?.email, 'admin@example.com');
      expect(hostel.created, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(hostel.updated, DateTime.parse('2023-01-01T00:00:00.000Z'));
    });

    test('should handle null optional fields', () {
      final json = {
        'id': '123',
        'name': 'Test Hostel',
        'address': '123 Main St',
        'status': 'active',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final hostel = Hostel.fromJson(json);

      expect(hostel.capacity, null);
      expect(hostel.location, null);
      expect(hostel.phone, null);
      expect(hostel.serviceIds, null);
      expect(hostel.services, null);
      expect(hostel.adminId, null);
      expect(hostel.admin, null);
    });

    test('should convert Hostel to JSON', () {
      final hostel = Hostel(
        id: '123',
        name: 'Test Hostel',
        address: '123 Main St',
        status: HostelStatus.active,
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = hostel.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Test Hostel');
      expect(json['address'], '123 Main St');
      expect(json['status'], 'active');
      expect(json['created'], '2023-01-01T00:00:00.000Z');
      expect(json['updated'], '2023-01-01T00:00:00.000Z');
    });
  });
} 