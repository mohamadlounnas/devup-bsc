/// A model representing a user in the application.
class User {
  final String id;
  final String phone;
  final String firstName;
  final String lastName;
  final String? email;
  final String? address;
  final String? avatar;
  final DateTime created;
  final DateTime updated;

  User({
    required this.id,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.email,
    this.address,
    this.avatar,
    required this.created,
    required this.updated,
  });

  /// Creates a User instance from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      phone: json['phone'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      avatar: json['avatar'] as String?,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );
  }

  /// Converts the User instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'avatar': avatar,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
} 