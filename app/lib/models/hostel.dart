/// A model class representing a hostel with its properties
class Hostel {
  /// The unique identifier of the hostel
  final String id;

  /// The name of the hostel
  final String name;

  /// The description of the hostel
  final String? description;

  /// The address of the hostel
  final String? address;

  /// The URL of the hostel's image
  final String? image;

  /// The rating of the hostel (0-5)
  final double? rating;

  /// The distance from campus in kilometers
  final double? distance;

  /// The list of amenities available at the hostel
  final List<String>? amenities;

  /// Creates a new [Hostel] instance
  const Hostel({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.image,
    this.rating,
    this.distance,
    this.amenities,
  });

  /// Creates a [Hostel] instance from a JSON map
  factory Hostel.fromJson(Map<String, dynamic> json) {
    return Hostel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      image: json['image'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
      amenities: (json['amenities'] as List<dynamic>?)?.cast<String>(),
    );
  }

  /// Converts this [Hostel] instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (image != null) 'image': image,
      if (rating != null) 'rating': rating,
      if (distance != null) 'distance': distance,
      if (amenities != null) 'amenities': amenities,
    };
  }
} 