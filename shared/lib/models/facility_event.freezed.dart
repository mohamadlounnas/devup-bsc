// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FacilityEvent _$FacilityEventFromJson(Map<String, dynamic> json) {
  return _FacilityEvent.fromJson(json);
}

/// @nodoc
mixin _$FacilityEvent {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'body')
  String? get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  String? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'started')
  DateTime? get started => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended')
  DateTime? get ended => throw _privateConstructorUsedError;
  @JsonKey(name: 'seats')
  double? get seats => throw _privateConstructorUsedError;
  @JsonKey(name: 'location')
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'address')
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_seats')
  double? get remainingSeats => throw _privateConstructorUsedError;
  @JsonKey(name: 'attended')
  DateTime? get attended => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  DateTime get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  DateTime get updated => throw _privateConstructorUsedError;

  /// Serializes this FacilityEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FacilityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacilityEventCopyWith<FacilityEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacilityEventCopyWith<$Res> {
  factory $FacilityEventCopyWith(
          FacilityEvent value, $Res Function(FacilityEvent) then) =
      _$FacilityEventCopyWithImpl<$Res, FacilityEvent>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'body') String? body,
      @JsonKey(name: 'image') String? image,
      @JsonKey(name: 'started') DateTime? started,
      @JsonKey(name: 'ended') DateTime? ended,
      @JsonKey(name: 'seats') double? seats,
      @JsonKey(name: 'location') String? location,
      @JsonKey(name: 'address') String? address,
      @JsonKey(name: 'remaining_seats') double? remainingSeats,
      @JsonKey(name: 'attended') DateTime? attended,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});
}

/// @nodoc
class _$FacilityEventCopyWithImpl<$Res, $Val extends FacilityEvent>
    implements $FacilityEventCopyWith<$Res> {
  _$FacilityEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FacilityEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? body = freezed,
    Object? image = freezed,
    Object? started = freezed,
    Object? ended = freezed,
    Object? seats = freezed,
    Object? location = freezed,
    Object? address = freezed,
    Object? remainingSeats = freezed,
    Object? attended = freezed,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      started: freezed == started
          ? _value.started
          : started // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ended: freezed == ended
          ? _value.ended
          : ended // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      seats: freezed == seats
          ? _value.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as double?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      remainingSeats: freezed == remainingSeats
          ? _value.remainingSeats
          : remainingSeats // ignore: cast_nullable_to_non_nullable
              as double?,
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
}

/// @nodoc
abstract class _$$FacilityEventImplCopyWith<$Res>
    implements $FacilityEventCopyWith<$Res> {
  factory _$$FacilityEventImplCopyWith(
          _$FacilityEventImpl value, $Res Function(_$FacilityEventImpl) then) =
      __$$FacilityEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'body') String? body,
      @JsonKey(name: 'image') String? image,
      @JsonKey(name: 'started') DateTime? started,
      @JsonKey(name: 'ended') DateTime? ended,
      @JsonKey(name: 'seats') double? seats,
      @JsonKey(name: 'location') String? location,
      @JsonKey(name: 'address') String? address,
      @JsonKey(name: 'remaining_seats') double? remainingSeats,
      @JsonKey(name: 'attended') DateTime? attended,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});
}

/// @nodoc
class __$$FacilityEventImplCopyWithImpl<$Res>
    extends _$FacilityEventCopyWithImpl<$Res, _$FacilityEventImpl>
    implements _$$FacilityEventImplCopyWith<$Res> {
  __$$FacilityEventImplCopyWithImpl(
      _$FacilityEventImpl _value, $Res Function(_$FacilityEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of FacilityEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? body = freezed,
    Object? image = freezed,
    Object? started = freezed,
    Object? ended = freezed,
    Object? seats = freezed,
    Object? location = freezed,
    Object? address = freezed,
    Object? remainingSeats = freezed,
    Object? attended = freezed,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_$FacilityEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      started: freezed == started
          ? _value.started
          : started // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ended: freezed == ended
          ? _value.ended
          : ended // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      seats: freezed == seats
          ? _value.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as double?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      remainingSeats: freezed == remainingSeats
          ? _value.remainingSeats
          : remainingSeats // ignore: cast_nullable_to_non_nullable
              as double?,
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
class _$FacilityEventImpl implements _FacilityEvent {
  _$FacilityEventImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'body') this.body,
      @JsonKey(name: 'image') this.image,
      @JsonKey(name: 'started') this.started,
      @JsonKey(name: 'ended') this.ended,
      @JsonKey(name: 'seats') this.seats,
      @JsonKey(name: 'location') this.location,
      @JsonKey(name: 'address') this.address,
      @JsonKey(name: 'remaining_seats') this.remainingSeats,
      @JsonKey(name: 'attended') this.attended,
      @JsonKey(name: 'created') required this.created,
      @JsonKey(name: 'updated') required this.updated});

  factory _$FacilityEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacilityEventImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'body')
  final String? body;
  @override
  @JsonKey(name: 'image')
  final String? image;
  @override
  @JsonKey(name: 'started')
  final DateTime? started;
  @override
  @JsonKey(name: 'ended')
  final DateTime? ended;
  @override
  @JsonKey(name: 'seats')
  final double? seats;
  @override
  @JsonKey(name: 'location')
  final String? location;
  @override
  @JsonKey(name: 'address')
  final String? address;
  @override
  @JsonKey(name: 'remaining_seats')
  final double? remainingSeats;
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
    return 'FacilityEvent(id: $id, name: $name, description: $description, body: $body, image: $image, started: $started, ended: $ended, seats: $seats, location: $location, address: $address, remainingSeats: $remainingSeats, attended: $attended, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacilityEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.started, started) || other.started == started) &&
            (identical(other.ended, ended) || other.ended == ended) &&
            (identical(other.seats, seats) || other.seats == seats) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.remainingSeats, remainingSeats) ||
                other.remainingSeats == remainingSeats) &&
            (identical(other.attended, attended) ||
                other.attended == attended) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      body,
      image,
      started,
      ended,
      seats,
      location,
      address,
      remainingSeats,
      attended,
      created,
      updated);

  /// Create a copy of FacilityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacilityEventImplCopyWith<_$FacilityEventImpl> get copyWith =>
      __$$FacilityEventImplCopyWithImpl<_$FacilityEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacilityEventImplToJson(
      this,
    );
  }
}

abstract class _FacilityEvent implements FacilityEvent {
  factory _FacilityEvent(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'body') final String? body,
          @JsonKey(name: 'image') final String? image,
          @JsonKey(name: 'started') final DateTime? started,
          @JsonKey(name: 'ended') final DateTime? ended,
          @JsonKey(name: 'seats') final double? seats,
          @JsonKey(name: 'location') final String? location,
          @JsonKey(name: 'address') final String? address,
          @JsonKey(name: 'remaining_seats') final double? remainingSeats,
          @JsonKey(name: 'attended') final DateTime? attended,
          @JsonKey(name: 'created') required final DateTime created,
          @JsonKey(name: 'updated') required final DateTime updated}) =
      _$FacilityEventImpl;

  factory _FacilityEvent.fromJson(Map<String, dynamic> json) =
      _$FacilityEventImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'body')
  String? get body;
  @override
  @JsonKey(name: 'image')
  String? get image;
  @override
  @JsonKey(name: 'started')
  DateTime? get started;
  @override
  @JsonKey(name: 'ended')
  DateTime? get ended;
  @override
  @JsonKey(name: 'seats')
  double? get seats;
  @override
  @JsonKey(name: 'location')
  String? get location;
  @override
  @JsonKey(name: 'address')
  String? get address;
  @override
  @JsonKey(name: 'remaining_seats')
  double? get remainingSeats;
  @override
  @JsonKey(name: 'attended')
  DateTime? get attended;
  @override
  @JsonKey(name: 'created')
  DateTime get created;
  @override
  @JsonKey(name: 'updated')
  DateTime get updated;

  /// Create a copy of FacilityEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacilityEventImplCopyWith<_$FacilityEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
