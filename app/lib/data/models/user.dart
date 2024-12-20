import 'package:shared/shared.dart';

/// Represents a user in the system
class User {
  final int? id;
  final String email;
  final String firstname;
  final String lastname;
  final String phone;
  final Gender gender;
  final UserType type;
  final String? nationalId;
  final DateTime? dateOfBirth;
  final String? placeOfBirth;

  User({
    this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.gender,
    required this.type,
    this.nationalId,
    this.dateOfBirth,
    this.placeOfBirth,
  });

  /// Creates a User instance from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      email: json['email'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      phone: json['phone'] as String,
      gender: Gender.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['gender'] as String).toLowerCase(),
      ),
      type: UserType.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['type'] as String).toLowerCase(),
      ),
      nationalId: json['national_id'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      placeOfBirth: json['place_of_birth'] as String?,
    );
  }

  /// Converts the User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'gender': gender.name.toLowerCase(),
      'type': type.name.toLowerCase(),
      'national_id': nationalId,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'place_of_birth': placeOfBirth,
    };
  }

  /// Creates a copy of the User instance with optional field updates
  User copyWith({
    int? id,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    Gender? gender,
    UserType? type,
    String? nationalId,
    DateTime? dateOfBirth,
    String? placeOfBirth,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      type: type ?? this.type,
      nationalId: nationalId ?? this.nationalId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
    );
  }
} 