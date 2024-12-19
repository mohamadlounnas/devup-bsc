import 'package:shared/models/models.dart';
import 'package:shared/services/api_service.dart';
import 'package:test/test.dart';

import 'mock_pb_client.dart';

void main() {
  late ApiService apiService;

  setUp(() {
    apiService = ApiService(MockPocketBase());
  });

  group('ApiService', () {
    group('getUser', () {
      test('should return a User instance', () async {
        final user = await apiService.getUser('user123');

        expect(user, isA<User>());
        expect(user.id, 'user123');
        expect(user.email, 'test@example.com');
        expect(user.firstname, 'John');
        expect(user.lastname, 'Doe');
        expect(user.type, UserType.employee);
        expect(user.gender, Gender.male);
      });

      test('should throw exception for non-existent user', () {
        expect(
          () => apiService.getUser('nonexistent'),
          throwsException,
        );
      });
    });

    group('getUsers', () {
      test('should return a list of User instances', () async {
        final users = await apiService.getUsers();

        expect(users, isA<List<User>>());
        expect(users.length, 2);

        expect(users[0].id, 'user123');
        expect(users[0].type, UserType.employee);
        expect(users[0].gender, Gender.male);

        expect(users[1].id, 'user456');
        expect(users[1].type, UserType.client);
        expect(users[1].gender, Gender.female);
      });
    });

    group('getFacility', () {
      test('should return a Facility instance', () async {
        final facility = await apiService.getFacility('facility123');

        expect(facility, isA<Facility>());
        expect(facility.id, 'facility123');
        expect(facility.name, 'Test Facility');
        expect(facility.type, FacilityType.sportClub);
      });

      test('should throw exception for non-existent facility', () {
        expect(
          () => apiService.getFacility('nonexistent'),
          throwsException,
        );
      });
    });

    group('getHostel', () {
      test('should return a Hostel instance', () async {
        final hostel = await apiService.getHostel('hostel123');

        expect(hostel, isA<Hostel>());
        expect(hostel.id, 'hostel123');
        expect(hostel.name, 'Test Hostel');
        expect(hostel.address, '123 Main St');
        expect(hostel.status, HostelStatus.active);
      });

      test('should throw exception for non-existent hostel', () {
        expect(
          () => apiService.getHostel('nonexistent'),
          throwsException,
        );
      });
    });
  });
} 