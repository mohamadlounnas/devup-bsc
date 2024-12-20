// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User model representing the users collection in PocketBase
@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'emailVisibility') bool? emailVisibility,
    @JsonKey(name: 'verified') bool? verified,
    @JsonKey(name: 'avatar') String? avatar,
    @JsonKey(name: 'firstname') required String firstname,
    @JsonKey(name: 'lastname') required String lastname,
    @JsonKey(name: 'national_id') String? nationalId,
    @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
    @JsonKey(name: 'place_of_birth') String? placeOfBirth,
    @JsonKey(name: 'banned') bool? banned,
    @JsonKey(name: 'grade') String? grade,
    @JsonKey(name: 'post') String? post,
    @JsonKey(name: 'type') required UserType type,
    @JsonKey(name: 'gander') required Gender gender,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'updated') required DateTime updated,
  }) = _User;

  /// Creates a User instance from JSON data
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
} 