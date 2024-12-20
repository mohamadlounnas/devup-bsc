// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hostel_reservation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HostelReservation _$HostelReservationFromJson(Map<String, dynamic> json) {
  return _HostelReservation.fromJson(json);
}

/// @nodoc
mixin _$HostelReservation {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_expand')
  User? get user => throw _privateConstructorUsedError;

  /// The status of the reservation (pending, approved, cancelled)
  @JsonKey(name: 'status')
  ReservationStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'parental_license')
  String? get parentalLicense => throw _privateConstructorUsedError;
  @JsonKey(name: 'login_at')
  DateTime? get loginAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'logout_at')
  DateTime? get logoutAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_amount')
  double? get paymentAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_receipt')
  String? get paymentReceipt => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_amount')
  double? get foodAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_receipt')
  String? get foodReceipt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  DateTime get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  DateTime get updated => throw _privateConstructorUsedError;

  /// Serializes this HostelReservation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HostelReservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HostelReservationCopyWith<HostelReservation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostelReservationCopyWith<$Res> {
  factory $HostelReservationCopyWith(
          HostelReservation value, $Res Function(HostelReservation) then) =
      _$HostelReservationCopyWithImpl<$Res, HostelReservation>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'user') String userId,
      @JsonKey(name: 'user_expand') User? user,
      @JsonKey(name: 'status') ReservationStatus status,
      @JsonKey(name: 'parental_license') String? parentalLicense,
      @JsonKey(name: 'login_at') DateTime? loginAt,
      @JsonKey(name: 'logout_at') DateTime? logoutAt,
      @JsonKey(name: 'payment_amount') double? paymentAmount,
      @JsonKey(name: 'payment_receipt') String? paymentReceipt,
      @JsonKey(name: 'food_amount') double? foodAmount,
      @JsonKey(name: 'food_receipt') String? foodReceipt,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$HostelReservationCopyWithImpl<$Res, $Val extends HostelReservation>
    implements $HostelReservationCopyWith<$Res> {
  _$HostelReservationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HostelReservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? user = freezed,
    Object? status = null,
    Object? parentalLicense = freezed,
    Object? loginAt = freezed,
    Object? logoutAt = freezed,
    Object? paymentAmount = freezed,
    Object? paymentReceipt = freezed,
    Object? foodAmount = freezed,
    Object? foodReceipt = freezed,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReservationStatus,
      parentalLicense: freezed == parentalLicense
          ? _value.parentalLicense
          : parentalLicense // ignore: cast_nullable_to_non_nullable
              as String?,
      loginAt: freezed == loginAt
          ? _value.loginAt
          : loginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      logoutAt: freezed == logoutAt
          ? _value.logoutAt
          : logoutAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentAmount: freezed == paymentAmount
          ? _value.paymentAmount
          : paymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentReceipt: freezed == paymentReceipt
          ? _value.paymentReceipt
          : paymentReceipt // ignore: cast_nullable_to_non_nullable
              as String?,
      foodAmount: freezed == foodAmount
          ? _value.foodAmount
          : foodAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      foodReceipt: freezed == foodReceipt
          ? _value.foodReceipt
          : foodReceipt // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of HostelReservation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HostelReservationImplCopyWith<$Res>
    implements $HostelReservationCopyWith<$Res> {
  factory _$$HostelReservationImplCopyWith(_$HostelReservationImpl value,
          $Res Function(_$HostelReservationImpl) then) =
      __$$HostelReservationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'user') String userId,
      @JsonKey(name: 'user_expand') User? user,
      @JsonKey(name: 'status') ReservationStatus status,
      @JsonKey(name: 'parental_license') String? parentalLicense,
      @JsonKey(name: 'login_at') DateTime? loginAt,
      @JsonKey(name: 'logout_at') DateTime? logoutAt,
      @JsonKey(name: 'payment_amount') double? paymentAmount,
      @JsonKey(name: 'payment_receipt') String? paymentReceipt,
      @JsonKey(name: 'food_amount') double? foodAmount,
      @JsonKey(name: 'food_receipt') String? foodReceipt,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$HostelReservationImplCopyWithImpl<$Res>
    extends _$HostelReservationCopyWithImpl<$Res, _$HostelReservationImpl>
    implements _$$HostelReservationImplCopyWith<$Res> {
  __$$HostelReservationImplCopyWithImpl(_$HostelReservationImpl _value,
      $Res Function(_$HostelReservationImpl) _then)
      : super(_value, _then);

  /// Create a copy of HostelReservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? user = freezed,
    Object? status = null,
    Object? parentalLicense = freezed,
    Object? loginAt = freezed,
    Object? logoutAt = freezed,
    Object? paymentAmount = freezed,
    Object? paymentReceipt = freezed,
    Object? foodAmount = freezed,
    Object? foodReceipt = freezed,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_$HostelReservationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReservationStatus,
      parentalLicense: freezed == parentalLicense
          ? _value.parentalLicense
          : parentalLicense // ignore: cast_nullable_to_non_nullable
              as String?,
      loginAt: freezed == loginAt
          ? _value.loginAt
          : loginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      logoutAt: freezed == logoutAt
          ? _value.logoutAt
          : logoutAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paymentAmount: freezed == paymentAmount
          ? _value.paymentAmount
          : paymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentReceipt: freezed == paymentReceipt
          ? _value.paymentReceipt
          : paymentReceipt // ignore: cast_nullable_to_non_nullable
              as String?,
      foodAmount: freezed == foodAmount
          ? _value.foodAmount
          : foodAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      foodReceipt: freezed == foodReceipt
          ? _value.foodReceipt
          : foodReceipt // ignore: cast_nullable_to_non_nullable
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
class _$HostelReservationImpl implements _HostelReservation {
  const _$HostelReservationImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'user') required this.userId,
      @JsonKey(name: 'user_expand') this.user,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'parental_license') this.parentalLicense,
      @JsonKey(name: 'login_at') this.loginAt,
      @JsonKey(name: 'logout_at') this.logoutAt,
      @JsonKey(name: 'payment_amount') this.paymentAmount,
      @JsonKey(name: 'payment_receipt') this.paymentReceipt,
      @JsonKey(name: 'food_amount') this.foodAmount,
      @JsonKey(name: 'food_receipt') this.foodReceipt,
      @JsonKey(name: 'created') required this.created,
      @JsonKey(name: 'updated') required this.updated});

  factory _$HostelReservationImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostelReservationImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'user')
  final String userId;
  @override
  @JsonKey(name: 'user_expand')
  final User? user;

  /// The status of the reservation (pending, approved, cancelled)
  @override
  @JsonKey(name: 'status')
  final ReservationStatus status;
  @override
  @JsonKey(name: 'parental_license')
  final String? parentalLicense;
  @override
  @JsonKey(name: 'login_at')
  final DateTime? loginAt;
  @override
  @JsonKey(name: 'logout_at')
  final DateTime? logoutAt;
  @override
  @JsonKey(name: 'payment_amount')
  final double? paymentAmount;
  @override
  @JsonKey(name: 'payment_receipt')
  final String? paymentReceipt;
  @override
  @JsonKey(name: 'food_amount')
  final double? foodAmount;
  @override
  @JsonKey(name: 'food_receipt')
  final String? foodReceipt;
  @override
  @JsonKey(name: 'created')
  final DateTime created;
  @override
  @JsonKey(name: 'updated')
  final DateTime updated;

  @override
  String toString() {
    return 'HostelReservation(id: $id, userId: $userId, user: $user, status: $status, parentalLicense: $parentalLicense, loginAt: $loginAt, logoutAt: $logoutAt, paymentAmount: $paymentAmount, paymentReceipt: $paymentReceipt, foodAmount: $foodAmount, foodReceipt: $foodReceipt, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostelReservationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.parentalLicense, parentalLicense) ||
                other.parentalLicense == parentalLicense) &&
            (identical(other.loginAt, loginAt) || other.loginAt == loginAt) &&
            (identical(other.logoutAt, logoutAt) ||
                other.logoutAt == logoutAt) &&
            (identical(other.paymentAmount, paymentAmount) ||
                other.paymentAmount == paymentAmount) &&
            (identical(other.paymentReceipt, paymentReceipt) ||
                other.paymentReceipt == paymentReceipt) &&
            (identical(other.foodAmount, foodAmount) ||
                other.foodAmount == foodAmount) &&
            (identical(other.foodReceipt, foodReceipt) ||
                other.foodReceipt == foodReceipt) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      user,
      status,
      parentalLicense,
      loginAt,
      logoutAt,
      paymentAmount,
      paymentReceipt,
      foodAmount,
      foodReceipt,
      created,
      updated);

  /// Create a copy of HostelReservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HostelReservationImplCopyWith<_$HostelReservationImpl> get copyWith =>
      __$$HostelReservationImplCopyWithImpl<_$HostelReservationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostelReservationImplToJson(
      this,
    );
  }
}

abstract class _HostelReservation implements HostelReservation {
  const factory _HostelReservation(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'user') required final String userId,
          @JsonKey(name: 'user_expand') final User? user,
          @JsonKey(name: 'status') required final ReservationStatus status,
          @JsonKey(name: 'parental_license') final String? parentalLicense,
          @JsonKey(name: 'login_at') final DateTime? loginAt,
          @JsonKey(name: 'logout_at') final DateTime? logoutAt,
          @JsonKey(name: 'payment_amount') final double? paymentAmount,
          @JsonKey(name: 'payment_receipt') final String? paymentReceipt,
          @JsonKey(name: 'food_amount') final double? foodAmount,
          @JsonKey(name: 'food_receipt') final String? foodReceipt,
          @JsonKey(name: 'created') required final DateTime created,
          @JsonKey(name: 'updated') required final DateTime updated}) =
      _$HostelReservationImpl;

  factory _HostelReservation.fromJson(Map<String, dynamic> json) =
      _$HostelReservationImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'user')
  String get userId;
  @override
  @JsonKey(name: 'user_expand')
  User? get user;

  /// The status of the reservation (pending, approved, cancelled)
  @override
  @JsonKey(name: 'status')
  ReservationStatus get status;
  @override
  @JsonKey(name: 'parental_license')
  String? get parentalLicense;
  @override
  @JsonKey(name: 'login_at')
  DateTime? get loginAt;
  @override
  @JsonKey(name: 'logout_at')
  DateTime? get logoutAt;
  @override
  @JsonKey(name: 'payment_amount')
  double? get paymentAmount;
  @override
  @JsonKey(name: 'payment_receipt')
  String? get paymentReceipt;
  @override
  @JsonKey(name: 'food_amount')
  double? get foodAmount;
  @override
  @JsonKey(name: 'food_receipt')
  String? get foodReceipt;
  @override
  @JsonKey(name: 'created')
  DateTime get created;
  @override
  @JsonKey(name: 'updated')
  DateTime get updated;

  /// Create a copy of HostelReservation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HostelReservationImplCopyWith<_$HostelReservationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
