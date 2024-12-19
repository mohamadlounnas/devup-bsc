import 'package:shared/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('UserType', () {
    test('should serialize to correct string values', () {
      expect(UserType.employee.toString(), 'UserType.employee');
      expect(UserType.client.toString(), 'UserType.client');
    });

    test('should deserialize from string values', () {
      expect(UserType.values.byName('employee'), UserType.employee);
      expect(UserType.values.byName('client'), UserType.client);
    });
  });

  group('Gender', () {
    test('should serialize to correct string values', () {
      expect(Gender.male.toString(), 'Gender.male');
      expect(Gender.female.toString(), 'Gender.female');
    });

    test('should deserialize from string values', () {
      expect(Gender.values.byName('male'), Gender.male);
      expect(Gender.values.byName('female'), Gender.female);
    });
  });

  group('FacilityType', () {
    test('should serialize to correct string values', () {
      expect(FacilityType.sportClub.toString(), 'FacilityType.sportClub');
      expect(FacilityType.touristAgency.toString(), 'FacilityType.touristAgency');
      expect(FacilityType.hotel.toString(), 'FacilityType.hotel');
      expect(FacilityType.museum.toString(), 'FacilityType.museum');
      expect(FacilityType.restaurant.toString(), 'FacilityType.restaurant');
    });

    test('should deserialize from string values', () {
      expect(FacilityType.values.byName('sportClub'), FacilityType.sportClub);
      expect(FacilityType.values.byName('touristAgency'), FacilityType.touristAgency);
      expect(FacilityType.values.byName('hotel'), FacilityType.hotel);
      expect(FacilityType.values.byName('museum'), FacilityType.museum);
      expect(FacilityType.values.byName('restaurant'), FacilityType.restaurant);
    });
  });

  group('HostelStatus', () {
    test('should serialize to correct string values', () {
      expect(HostelStatus.active.toString(), 'HostelStatus.active');
      expect(HostelStatus.inactive.toString(), 'HostelStatus.inactive');
      expect(HostelStatus.partially.toString(), 'HostelStatus.partially');
    });

    test('should deserialize from string values', () {
      expect(HostelStatus.values.byName('active'), HostelStatus.active);
      expect(HostelStatus.values.byName('inactive'), HostelStatus.inactive);
      expect(HostelStatus.values.byName('partially'), HostelStatus.partially);
    });
  });
} 