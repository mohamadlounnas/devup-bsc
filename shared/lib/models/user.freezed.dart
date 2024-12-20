// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'emailVisibility')
  bool? get emailVisibility => throw _privateConstructorUsedError;
  @JsonKey(name: 'verified')
  bool? get verified => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar')
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(name: 'firstname')
  String get firstname => throw _privateConstructorUsedError;
  @JsonKey(name: 'lastname')
  String get lastname => throw _privateConstructorUsedError;
  @JsonKey(name: 'national_id')
  String? get nationalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_of_birth')
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  @JsonKey(name: 'place_of_birth')
  String? get placeOfBirth => throw _privateConstructorUsedError;
  @JsonKey(name: 'banned')
  bool? get banned => throw _privateConstructorUsedError;
  @JsonKey(name: 'grade')
  String? get grade => throw _privateConstructorUsedError;
  @JsonKey(name: 'post')
  String? get post => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  UserType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'gander')
  Gender get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone')
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  DateTime get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  DateTime get updated => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'emailVisibility') bool? emailVisibility,
      @JsonKey(name: 'verified') bool? verified,
      @JsonKey(name: 'avatar') String? avatar,
      @JsonKey(name: 'firstname') String firstname,
      @JsonKey(name: 'lastname') String lastname,
      @JsonKey(name: 'national_id') String? nationalId,
      @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
      @JsonKey(name: 'place_of_birth') String? placeOfBirth,
      @JsonKey(name: 'banned') bool? banned,
      @JsonKey(name: 'grade') String? grade,
      @JsonKey(name: 'post') String? post,
      @JsonKey(name: 'type') UserType type,
      @JsonKey(name: 'gander') Gender gender,
      @JsonKey(name: 'phone') String? phone,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? emailVisibility = freezed,
    Object? verified = freezed,
    Object? avatar = freezed,
    Object? firstname = null,
    Object? lastname = null,
    Object? nationalId = freezed,
    Object? dateOfBirth = freezed,
    Object? placeOfBirth = freezed,
    Object? banned = freezed,
    Object? grade = freezed,
    Object? post = freezed,
    Object? type = null,
    Object? gender = null,
    Object? phone = freezed,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailVisibility: freezed == emailVisibility
          ? _value.emailVisibility
          : emailVisibility // ignore: cast_nullable_to_non_nullable
              as bool?,
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      firstname: null == firstname
          ? _value.firstname
          : firstname // ignore: cast_nullable_to_non_nullable
              as String,
      lastname: null == lastname
          ? _value.lastname
          : lastname // ignore: cast_nullable_to_non_nullable
              as String,
      nationalId: freezed == nationalId
          ? _value.nationalId
          : nationalId // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      placeOfBirth: freezed == placeOfBirth
          ? _value.placeOfBirth
          : placeOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      banned: freezed == banned
          ? _value.banned
          : banned // ignore: cast_nullable_to_non_nullable
              as bool?,
      grade: freezed == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
      post: freezed == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as UserType,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'emailVisibility') bool? emailVisibility,
      @JsonKey(name: 'verified') bool? verified,
      @JsonKey(name: 'avatar') String? avatar,
      @JsonKey(name: 'firstname') String firstname,
      @JsonKey(name: 'lastname') String lastname,
      @JsonKey(name: 'national_id') String? nationalId,
      @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
      @JsonKey(name: 'place_of_birth') String? placeOfBirth,
      @JsonKey(name: 'banned') bool? banned,
      @JsonKey(name: 'grade') String? grade,
      @JsonKey(name: 'post') String? post,
      @JsonKey(name: 'type') UserType type,
      @JsonKey(name: 'gander') Gender gender,
      @JsonKey(name: 'phone') String? phone,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? emailVisibility = freezed,
    Object? verified = freezed,
    Object? avatar = freezed,
    Object? firstname = null,
    Object? lastname = null,
    Object? nationalId = freezed,
    Object? dateOfBirth = freezed,
    Object? placeOfBirth = freezed,
    Object? banned = freezed,
    Object? grade = freezed,
    Object? post = freezed,
    Object? type = null,
    Object? gender = null,
    Object? phone = freezed,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailVisibility: freezed == emailVisibility
          ? _value.emailVisibility
          : emailVisibility // ignore: cast_nullable_to_non_nullable
              as bool?,
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      firstname: null == firstname
          ? _value.firstname
          : firstname // ignore: cast_nullable_to_non_nullable
              as String,
      lastname: null == lastname
          ? _value.lastname
          : lastname // ignore: cast_nullable_to_non_nullable
              as String,
      nationalId: freezed == nationalId
          ? _value.nationalId
          : nationalId // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      placeOfBirth: freezed == placeOfBirth
          ? _value.placeOfBirth
          : placeOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      banned: freezed == banned
          ? _value.banned
          : banned // ignore: cast_nullable_to_non_nullable
              as bool?,
      grade: freezed == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String?,
      post: freezed == post
          ? _value.post
          : post // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as UserType,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'email') required this.email,
      @JsonKey(name: 'emailVisibility') this.emailVisibility,
      @JsonKey(name: 'verified') this.verified,
      @JsonKey(name: 'avatar') this.avatar,
      @JsonKey(name: 'firstname') required this.firstname,
      @JsonKey(name: 'lastname') required this.lastname,
      @JsonKey(name: 'national_id') this.nationalId,
      @JsonKey(name: 'date_of_birth') this.dateOfBirth,
      @JsonKey(name: 'place_of_birth') this.placeOfBirth,
      @JsonKey(name: 'banned') this.banned,
      @JsonKey(name: 'grade') this.grade,
      @JsonKey(name: 'post') this.post,
      @JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'gander') required this.gender,
      @JsonKey(name: 'phone') this.phone,
      @JsonKey(name: 'created') required this.created,
      @JsonKey(name: 'updated') required this.updated});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'email')
  final String email;
  @override
  @JsonKey(name: 'emailVisibility')
  final bool? emailVisibility;
  @override
  @JsonKey(name: 'verified')
  final bool? verified;
  @override
  @JsonKey(name: 'avatar')
  final String? avatar;
  @override
  @JsonKey(name: 'firstname')
  final String firstname;
  @override
  @JsonKey(name: 'lastname')
  final String lastname;
  @override
  @JsonKey(name: 'national_id')
  final String? nationalId;
  @override
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;
  @override
  @JsonKey(name: 'place_of_birth')
  final String? placeOfBirth;
  @override
  @JsonKey(name: 'banned')
  final bool? banned;
  @override
  @JsonKey(name: 'grade')
  final String? grade;
  @override
  @JsonKey(name: 'post')
  final String? post;
  @override
  @JsonKey(name: 'type')
  final UserType type;
  @override
  @JsonKey(name: 'gander')
  final Gender gender;
  @override
  @JsonKey(name: 'phone')
  final String? phone;
  @override
  @JsonKey(name: 'created')
  final DateTime created;
  @override
  @JsonKey(name: 'updated')
  final DateTime updated;

  @override
  String toString() {
    return 'User(id: $id, email: $email, emailVisibility: $emailVisibility, verified: $verified, avatar: $avatar, firstname: $firstname, lastname: $lastname, nationalId: $nationalId, dateOfBirth: $dateOfBirth, placeOfBirth: $placeOfBirth, banned: $banned, grade: $grade, post: $post, type: $type, gender: $gender, phone: $phone, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailVisibility, emailVisibility) ||
                other.emailVisibility == emailVisibility) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.firstname, firstname) ||
                other.firstname == firstname) &&
            (identical(other.lastname, lastname) ||
                other.lastname == lastname) &&
            (identical(other.nationalId, nationalId) ||
                other.nationalId == nationalId) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.placeOfBirth, placeOfBirth) ||
                other.placeOfBirth == placeOfBirth) &&
            (identical(other.banned, banned) || other.banned == banned) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.post, post) || other.post == post) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      emailVisibility,
      verified,
      avatar,
      firstname,
      lastname,
      nationalId,
      dateOfBirth,
      placeOfBirth,
      banned,
      grade,
      post,
      type,
      gender,
      phone,
      created,
      updated);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'email') required final String email,
      @JsonKey(name: 'emailVisibility') final bool? emailVisibility,
      @JsonKey(name: 'verified') final bool? verified,
      @JsonKey(name: 'avatar') final String? avatar,
      @JsonKey(name: 'firstname') required final String firstname,
      @JsonKey(name: 'lastname') required final String lastname,
      @JsonKey(name: 'national_id') final String? nationalId,
      @JsonKey(name: 'date_of_birth') final DateTime? dateOfBirth,
      @JsonKey(name: 'place_of_birth') final String? placeOfBirth,
      @JsonKey(name: 'banned') final bool? banned,
      @JsonKey(name: 'grade') final String? grade,
      @JsonKey(name: 'post') final String? post,
      @JsonKey(name: 'type') required final UserType type,
      @JsonKey(name: 'gander') required final Gender gender,
      @JsonKey(name: 'phone') final String? phone,
      @JsonKey(name: 'created') required final DateTime created,
      @JsonKey(name: 'updated') required final DateTime updated}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'email')
  String get email;
  @override
  @JsonKey(name: 'emailVisibility')
  bool? get emailVisibility;
  @override
  @JsonKey(name: 'verified')
  bool? get verified;
  @override
  @JsonKey(name: 'avatar')
  String? get avatar;
  @override
  @JsonKey(name: 'firstname')
  String get firstname;
  @override
  @JsonKey(name: 'lastname')
  String get lastname;
  @override
  @JsonKey(name: 'national_id')
  String? get nationalId;
  @override
  @JsonKey(name: 'date_of_birth')
  DateTime? get dateOfBirth;
  @override
  @JsonKey(name: 'place_of_birth')
  String? get placeOfBirth;
  @override
  @JsonKey(name: 'banned')
  bool? get banned;
  @override
  @JsonKey(name: 'grade')
  String? get grade;
  @override
  @JsonKey(name: 'post')
  String? get post;
  @override
  @JsonKey(name: 'type')
  UserType get type;
  @override
  @JsonKey(name: 'gander')
  Gender get gender;
  @override
  @JsonKey(name: 'phone')
  String? get phone;
  @override
  @JsonKey(name: 'created')
  DateTime get created;
  @override
  @JsonKey(name: 'updated')
  DateTime get updated;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
