import 'package:shared/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('HostelService', () {
    test('should create HostelService instance from JSON', () {
      final json = {
        'id': '123',
        'icon': 'service.jpg',
        'name': 'Test Service',
        'description': 'A test service',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final service = HostelService.fromJson(json);

      expect(service.id, '123');
      expect(service.icon, 'service.jpg');
      expect(service.name, 'Test Service');
      expect(service.description, 'A test service');
      expect(service.created, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(service.updated, DateTime.parse('2023-01-01T00:00:00.000Z'));
    });

    test('should handle null optional fields', () {
      final json = {
        'id': '123',
        'name': 'Test Service',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final service = HostelService.fromJson(json);

      expect(service.icon, null);
      expect(service.description, null);
    });

    test('should convert HostelService to JSON', () {
      final service = HostelService(
        id: '123',
        name: 'Test Service',
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = service.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Test Service');
      expect(json['created'], '2023-01-01T00:00:00.000Z');
      expect(json['updated'], '2023-01-01T00:00:00.000Z');
    });
  });
} 