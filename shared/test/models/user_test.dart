import 'package:shared/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    test('should create User instance from JSON', () {
      final json = {
        'id': '123',
        'email': 'test@example.com',
        'emailVisibility': true,
        'verified': true,
        'avatar': 'avatar.jpg',
        'firstname': 'John',
        'lastname': 'Doe',
        'national_id': '123456789',
        'date_of_birth': '2000-01-01',
        'place_of_birth': 'New York',
        'banned': false,
        'grade': 'Senior',
        'post': 'Developer',
        'type': 'employee',
        'gander': 'male',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.emailVisibility, true);
      expect(user.verified, true);
      expect(user.avatar, 'avatar.jpg');
      expect(user.firstname, 'John');
      expect(user.lastname, 'Doe');
      expect(user.nationalId, '123456789');
      expect(user.dateOfBirth, DateTime(2000, 1, 1));
      expect(user.placeOfBirth, 'New York');
      expect(user.banned, false);
      expect(user.grade, 'Senior');
      expect(user.post, 'Developer');
      expect(user.type, UserType.employee);
      expect(user.gender, Gender.male);
      expect(user.created, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(user.updated, DateTime.parse('2023-01-01T00:00:00.000Z'));
    });

    test('should handle null optional fields', () {
      final json = {
        'id': '123',
        'email': 'test@example.com',
        'firstname': 'John',
        'lastname': 'Doe',
        'type': 'employee',
        'gander': 'male',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final user = User.fromJson(json);

      expect(user.emailVisibility, null);
      expect(user.verified, null);
      expect(user.avatar, null);
      expect(user.nationalId, null);
      expect(user.dateOfBirth, null);
      expect(user.placeOfBirth, null);
      expect(user.banned, null);
      expect(user.grade, null);
      expect(user.post, null);
    });

    test('should convert User to JSON', () {
      final user = User(
        id: '123',
        email: 'test@example.com',
        firstname: 'John',
        lastname: 'Doe',
        type: UserType.employee,
        gender: Gender.male,
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['email'], 'test@example.com');
      expect(json['firstname'], 'John');
      expect(json['lastname'], 'Doe');
      expect(json['type'], 'employee');
      expect(json['gander'], 'male');
      expect(json['created'], '2023-01-01T00:00:00.000Z');
      expect(json['updated'], '2023-01-01T00:00:00.000Z');
    });
  });
} 