import 'package:shared/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('HostelReservation', () {
    test('should create HostelReservation instance from JSON', () {
      final json = {
        'id': '123',
        'user': 'user123',
        'user_expand': {
          'id': 'user123',
          'email': 'user@example.com',
          'firstname': 'User',
          'lastname': 'Test',
          'type': 'client',
          'gander': 'male',
          'created': '2023-01-01T00:00:00.000Z',
          'updated': '2023-01-01T00:00:00.000Z',
        },
        'parental_license': 'license.pdf',
        'login_at': '2023-01-01T10:00:00.000Z',
        'logout_at': '2023-01-01T18:00:00.000Z',
        'payment_amount': 100.0,
        'payment_receipt': 'payment.pdf',
        'food_amount': 50.0,
        'food_receipt': 'food.pdf',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final reservation = HostelReservation.fromJson(json);

      expect(reservation.id, '123');
      expect(reservation.userId, 'user123');
      expect(reservation.user?.id, 'user123');
      expect(reservation.user?.email, 'user@example.com');
      expect(reservation.parentalLicense, 'license.pdf');
      expect(reservation.loginAt, DateTime.parse('2023-01-01T10:00:00.000Z'));
      expect(reservation.logoutAt, DateTime.parse('2023-01-01T18:00:00.000Z'));
      expect(reservation.paymentAmount, 100.0);
      expect(reservation.paymentReceipt, 'payment.pdf');
      expect(reservation.foodAmount, 50.0);
      expect(reservation.foodReceipt, 'food.pdf');
      expect(reservation.created, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(reservation.updated, DateTime.parse('2023-01-01T00:00:00.000Z'));
    });

    test('should handle null optional fields', () {
      final json = {
        'id': '123',
        'user': 'user123',
        'created': '2023-01-01T00:00:00.000Z',
        'updated': '2023-01-01T00:00:00.000Z',
      };

      final reservation = HostelReservation.fromJson(json);

      expect(reservation.user, null);
      expect(reservation.parentalLicense, null);
      expect(reservation.loginAt, null);
      expect(reservation.logoutAt, null);
      expect(reservation.paymentAmount, null);
      expect(reservation.paymentReceipt, null);
      expect(reservation.foodAmount, null);
      expect(reservation.foodReceipt, null);
    });

    test('should convert HostelReservation to JSON', () {
      final reservation = HostelReservation(
        id: '123',
        userId: 'user123',
        created: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final json = reservation.toJson();

      expect(json['id'], '123');
      expect(json['user'], 'user123');
      expect(json['created'], '2023-01-01T00:00:00.000Z');
      expect(json['updated'], '2023-01-01T00:00:00.000Z');
    });
  });
} 