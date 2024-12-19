import 'package:pocketbase/pocketbase.dart';

/// Mock PocketBase client for testing
class MockPocketBase implements PocketBase {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  RecordService collection(String collectionIdOrName) {
    return MockRecordService();
  }
}

/// Mock RecordService for testing
class MockRecordService implements RecordService {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  Future<RecordModel> getOne(
    String idOrName, {
    String? expand,
    String? fields,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    switch (idOrName) {
      case 'user123':
        return RecordModel.fromJson({
          'id': 'user123',
          'email': 'test@example.com',
          'firstname': 'John',
          'lastname': 'Doe',
          'type': 'employee',
          'gander': 'male',
          'created': '2023-01-01T00:00:00.000Z',
          'updated': '2023-01-01T00:00:00.000Z',
        });
      case 'facility123':
        return RecordModel.fromJson({
          'id': 'facility123',
          'name': 'Test Facility',
          'type': 'sport_club',
          'created': '2023-01-01T00:00:00.000Z',
          'updated': '2023-01-01T00:00:00.000Z',
        });
      case 'hostel123':
        return RecordModel.fromJson({
          'id': 'hostel123',
          'name': 'Test Hostel',
          'address': '123 Main St',
          'status': 'active',
          'created': '2023-01-01T00:00:00.000Z',
          'updated': '2023-01-01T00:00:00.000Z',
        });
      default:
        throw Exception('Record not found');
    }
  }

  @override
  Future<List<RecordModel>> getFullList({
    int batch = 200,
    String? expand,
    String? fields,
    String? filter,
    String? sort,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    return [
      RecordModel.fromJson({
        'id': 'user123',
        'email': 'test@example.com',
        'firstname': 'John',
        'lastname': 'Doe',
        'type': 'employee',
        'gander': 'male',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      }),
      RecordModel.fromJson({
        'id': 'user456',
        'email': 'test2@example.com',
        'firstname': 'Jane',
        'lastname': 'Doe',
        'type': 'client',
        'gander': 'female',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      }),
    ];
  }
} 