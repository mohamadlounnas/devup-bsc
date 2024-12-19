# BSC (bumerdas smart city hackathon) Shared Package

A shared Dart package for the BSC project that provides models and services for interacting with PocketBase backend.

## Features

- Type-safe models with Freezed
- JSON serialization/deserialization
- PocketBase API service
- Comprehensive test coverage
- Enum support for type safety

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  shared:
    path: ../shared
```

## Models

### Available Models

- `User` - User model with authentication fields
- `Facility` - Facility model (sport clubs, tourist agencies, etc.)
- `FacilityEvent` - Events hosted by facilities
- `Hostel` - Hostel model with services
- `HostelService` - Services offered by hostels
- `HostelReservation` - Hostel reservation records

### Example Usage

```dart
// Create a user from JSON
final user = User.fromJson({
  'id': '123',
  'email': 'test@example.com',
  'firstname': 'John',
  'lastname': 'Doe',
  'type': 'employee',
  'gander': 'male',
  'created': '2023-01-01T00:00:00.000Z',
  'updated': '2023-01-01T00:00:00.000Z',
});

// Create a facility
final facility = Facility(
  id: '123',
  name: 'Sports Club',
  type: FacilityType.sportClub,
  created: DateTime.now(),
  updated: DateTime.now(),
);

// Convert to JSON
final json = facility.toJson();
```

### Enums

Type-safe enums with JSON serialization:

```dart
enum UserType {
  @JsonValue('employee')
  employee,
  @JsonValue('client')
  client
}

enum FacilityType {
  @JsonValue('sport_club')
  sportClub,
  @JsonValue('tourist_agency')
  touristAgency,
  @JsonValue('hotel')
  hotel,
  @JsonValue('museum')
  museum,
  @JsonValue('restaurant')
  restaurant
}

enum HostelStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('partially')
  partially
}
```

## API Service

The `ApiService` class provides methods for interacting with the PocketBase backend:

```dart
final pb = PocketBase('http://your-pb-url.com');
final api = ApiService(pb);

// Get a user
final user = await api.getUser('user123');

// Get all facilities
final facilities = await api.getFacilities();

// Get a hostel with expanded relations
final hostel = await api.getHostel('hostel123');
print(hostel.services); // List of expanded HostelService objects
print(hostel.admin); // Expanded User object
```

### Available Methods

- Users:
  - `getUser(String id)`
  - `getUsers()`
- Facilities:
  - `getFacility(String id)`
  - `getFacilities()`
- Facility Events:
  - `getFacilityEvent(String id)`
  - `getFacilityEvents()`
- Hostels:
  - `getHostel(String id)`
  - `getHostels()`
- Hostel Services:
  - `getHostelService(String id)`
  - `getHostelServices()`
- Hostel Reservations:
  - `getHostelReservation(String id)`
  - `getHostelReservations()`

## Testing

The package includes comprehensive tests for all models and services. Run tests with:

```bash
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart test
```

### Test Coverage

- Model serialization/deserialization
- Null handling
- Enum conversion
- API service methods
- Error handling
- Expanded relations

Example test:

```dart
test('should create User instance from JSON', () {
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

  expect(user.id, '123');
  expect(user.email, 'test@example.com');
  expect(user.type, UserType.employee);
  expect(user.gender, Gender.male);
});
```

## Development

### Prerequisites

- Dart SDK >=3.0.0 <4.0.0
- PocketBase server

### Dependencies

```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  pocketbase: ^0.18.1

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  lints: ^2.1.0
  test: ^1.24.0
```

### Code Generation

After making changes to the models, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Add tests for any new functionality
4. Ensure all tests pass
5. Create a pull request

## License

This project is licensed under the MIT License.