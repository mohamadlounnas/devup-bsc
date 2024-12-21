// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility_event_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FacilityEventRegistration _$FacilityEventRegistrationFromJson(
    Map<String, dynamic> json) {
  return _FacilityEventRegistration.fromJson(json);
}

/// @nodoc
mixin _$FacilityEventRegistration {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_expand')
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'event')
  String get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_expand')
  FacilityEvent? get event =>
      throw _privateConstructorUsedError; // attended (datetime?)
  @JsonKey(name: 'attended')
  DateTime? get attended => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  DateTime get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  DateTime get updated => throw _privateConstructorUsedError;

  /// Serializes this FacilityEventRegistration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FacilityEventRegistration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacilityEventRegistrationCopyWith<FacilityEventRegistration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacilityEventRegistrationCopyWith<$Res> {
  factory $FacilityEventRegistrationCopyWith(FacilityEventRegistration value,
          $Res Function(FacilityEventRegistration) then) =
      _$FacilityEventRegistrationCopyWithImpl<$Res, FacilityEventRegistration>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'user') String userId,
      @JsonKey(name: 'user_expand') User? user,
      @JsonKey(name: 'event') String eventId,
      @JsonKey(name: 'event_expand') FacilityEvent? event,
      @JsonKey(name: 'attended') DateTime? attended,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});

  $UserCopyWith<$Res>? get user;
  $FacilityEventCopyWith<$Res>? get event;
}

/// @nodoc
class _$FacilityEventRegistrationCopyWithImpl<$Res,
        $Val extends FacilityEventRegistration>
    implements $FacilityEventRegistrationCopyWith<$Res> {
  _$FacilityEventRegistrationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FacilityEventRegistration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? user = freezed,
    Object? eventId = null,
    Object? event = freezed,
    Object? attended = freezed,
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
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as FacilityEvent?,
      attended: freezed == attended
          ? _value.attended
          : attended // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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

  /// Create a copy of FacilityEventRegistration
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

  /// Create a copy of FacilityEventRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FacilityEventCopyWith<$Res>? get event {
    if (_value.event == null) {
      return null;
    }

    return $FacilityEventCopyWith<$Res>(_value.event!, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FacilityEventRegistrationImplCopyWith<$Res>
    implements $FacilityEventRegistrationCopyWith<$Res> {
  factory _$$FacilityEventRegistrationImplCopyWith(
          _$FacilityEventRegistrationImpl value,
          $Res Function(_$FacilityEventRegistrationImpl) then) =
      __$$FacilityEventRegistrationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'user') String userId,
      @JsonKey(name: 'user_expand') User? user,
      @JsonKey(name: 'event') String eventId,
      @JsonKey(name: 'event_expand') FacilityEvent? event,
      @JsonKey(name: 'attended') DateTime? attended,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $FacilityEventCopyWith<$Res>? get event;
}

/// @nodoc
class __$$FacilityEventRegistrationImplCopyWithImpl<$Res>
    extends _$FacilityEventRegistrationCopyWithImpl<$Res,
        _$FacilityEventRegistrationImpl>
    implements _$$FacilityEventRegistrationImplCopyWith<$Res> {
  __$$FacilityEventRegistrationImplCopyWithImpl(
      _$FacilityEventRegistrationImpl _value,
      $Res Function(_$FacilityEventRegistrationImpl) _then)
      : super(_value, _then);

  /// Create a copy of FacilityEventRegistration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? user = freezed,
    Object? eventId = null,
    Object? event = freezed,
    Object? attended = freezed,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_$FacilityEventRegistrationImpl(
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
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as FacilityEvent?,
      attended: freezed == attended
          ? _value.attended
          : attended // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$FacilityEventRegistrationImpl implements _FacilityEventRegistration {
  const _$FacilityEventRegistrationImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'user') required this.userId,
      @JsonKey(name: 'user_expand') this.user,
      @JsonKey(name: 'event') required this.eventId,
      @JsonKey(name: 'event_expand') this.event,
      @JsonKey(name: 'attended') this.attended,
      @JsonKey(name: 'created') required this.created,
      @JsonKey(name: 'updated') required this.updated});

  factory _$FacilityEventRegistrationImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacilityEventRegistrationImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'user')
  final String userId;
  @override
  @JsonKey(name: 'user_expand')
  final User? user;
  @override
  @JsonKey(name: 'event')
  final String eventId;
  @override
  @JsonKey(name: 'event_expand')
  final FacilityEvent? event;
// attended (datetime?)
  @override
  @JsonKey(name: 'attended')
  final DateTime? attended;
  @override
  @JsonKey(name: 'created')
  final DateTime created;
  @override
  @JsonKey(name: 'updated')
  final DateTime updated;

  @override
  String toString() {
    return 'FacilityEventRegistration(id: $id, userId: $userId, user: $user, eventId: $eventId, event: $event, attended: $attended, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacilityEventRegistrationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.attended, attended) ||
                other.attended == attended) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, user, eventId, event,
      attended, created, updated);

  /// Create a copy of FacilityEventRegistration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacilityEventRegistrationImplCopyWith<_$FacilityEventRegistrationImpl>
      get copyWith => __$$FacilityEventRegistrationImplCopyWithImpl<
          _$FacilityEventRegistrationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacilityEventRegistrationImplToJson(
      this,
    );
  }
}

abstract class _FacilityEventRegistration implements FacilityEventRegistration {
  const factory _FacilityEventRegistration(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'user') required final String userId,
          @JsonKey(name: 'user_expand') final User? user,
          @JsonKey(name: 'event') required final String eventId,
          @JsonKey(name: 'event_expand') final FacilityEvent? event,
          @JsonKey(name: 'attended') final DateTime? attended,
          @JsonKey(name: 'created') required final DateTime created,
          @JsonKey(name: 'updated') required final DateTime updated}) =
      _$FacilityEventRegistrationImpl;

  factory _FacilityEventRegistration.fromJson(Map<String, dynamic> json) =
      _$FacilityEventRegistrationImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'user')
  String get userId;
  @override
  @JsonKey(name: 'user_expand')
  User? get user;
  @override
  @JsonKey(name: 'event')
  String get eventId;
  @override
  @JsonKey(name: 'event_expand')
  FacilityEvent? get event; // attended (datetime?)
  @override
  @JsonKey(name: 'attended')
  DateTime? get attended;
  @override
  @JsonKey(name: 'created')
  DateTime get created;
  @override
  @JsonKey(name: 'updated')
  DateTime get updated;

  /// Create a copy of FacilityEventRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacilityEventRegistrationImplCopyWith<_$FacilityEventRegistrationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
