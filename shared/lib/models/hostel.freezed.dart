// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hostel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Hostel _$HostelFromJson(Map<String, dynamic> json) {
  return _Hostel.fromJson(json);
}

/// @nodoc
mixin _$Hostel {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'capacity')
  double? get capacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'location')
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'address')
  String get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone')
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  HostelStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'services')
  List<String>? get serviceIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'services_expand')
  List<HostelService>? get services => throw _privateConstructorUsedError;
  @JsonKey(name: 'admin')
  String? get adminId => throw _privateConstructorUsedError;
  @JsonKey(name: 'admin_expand')
  User? get admin => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  DateTime get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  DateTime get updated => throw _privateConstructorUsedError;

  /// Serializes this Hostel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Hostel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HostelCopyWith<Hostel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostelCopyWith<$Res> {
  factory $HostelCopyWith(Hostel value, $Res Function(Hostel) then) =
      _$HostelCopyWithImpl<$Res, Hostel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'capacity') double? capacity,
      @JsonKey(name: 'location') String? location,
      @JsonKey(name: 'address') String address,
      @JsonKey(name: 'phone') String? phone,
      @JsonKey(name: 'status') HostelStatus status,
      @JsonKey(name: 'services') List<String>? serviceIds,
      @JsonKey(name: 'services_expand') List<HostelService>? services,
      @JsonKey(name: 'admin') String? adminId,
      @JsonKey(name: 'admin_expand') User? admin,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});

  $UserCopyWith<$Res>? get admin;
}

/// @nodoc
class _$HostelCopyWithImpl<$Res, $Val extends Hostel>
    implements $HostelCopyWith<$Res> {
  _$HostelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Hostel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? capacity = freezed,
    Object? location = freezed,
    Object? address = null,
    Object? phone = freezed,
    Object? status = null,
    Object? serviceIds = freezed,
    Object? services = freezed,
    Object? adminId = freezed,
    Object? admin = freezed,
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
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as double?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HostelStatus,
      serviceIds: freezed == serviceIds
          ? _value.serviceIds
          : serviceIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      services: freezed == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<HostelService>?,
      adminId: freezed == adminId
          ? _value.adminId
          : adminId // ignore: cast_nullable_to_non_nullable
              as String?,
      admin: freezed == admin
          ? _value.admin
          : admin // ignore: cast_nullable_to_non_nullable
              as User?,
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

  /// Create a copy of Hostel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get admin {
    if (_value.admin == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.admin!, (value) {
      return _then(_value.copyWith(admin: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HostelImplCopyWith<$Res> implements $HostelCopyWith<$Res> {
  factory _$$HostelImplCopyWith(
          _$HostelImpl value, $Res Function(_$HostelImpl) then) =
      __$$HostelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'capacity') double? capacity,
      @JsonKey(name: 'location') String? location,
      @JsonKey(name: 'address') String address,
      @JsonKey(name: 'phone') String? phone,
      @JsonKey(name: 'status') HostelStatus status,
      @JsonKey(name: 'services') List<String>? serviceIds,
      @JsonKey(name: 'services_expand') List<HostelService>? services,
      @JsonKey(name: 'admin') String? adminId,
      @JsonKey(name: 'admin_expand') User? admin,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});

  @override
  $UserCopyWith<$Res>? get admin;
}

/// @nodoc
class __$$HostelImplCopyWithImpl<$Res>
    extends _$HostelCopyWithImpl<$Res, _$HostelImpl>
    implements _$$HostelImplCopyWith<$Res> {
  __$$HostelImplCopyWithImpl(
      _$HostelImpl _value, $Res Function(_$HostelImpl) _then)
      : super(_value, _then);

  /// Create a copy of Hostel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? capacity = freezed,
    Object? location = freezed,
    Object? address = null,
    Object? phone = freezed,
    Object? status = null,
    Object? serviceIds = freezed,
    Object? services = freezed,
    Object? adminId = freezed,
    Object? admin = freezed,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_$HostelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as double?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HostelStatus,
      serviceIds: freezed == serviceIds
          ? _value._serviceIds
          : serviceIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      services: freezed == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<HostelService>?,
      adminId: freezed == adminId
          ? _value.adminId
          : adminId // ignore: cast_nullable_to_non_nullable
              as String?,
      admin: freezed == admin
          ? _value.admin
          : admin // ignore: cast_nullable_to_non_nullable
              as User?,
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
class _$HostelImpl implements _Hostel {
  const _$HostelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'capacity') this.capacity,
      @JsonKey(name: 'location') this.location,
      @JsonKey(name: 'address') required this.address,
      @JsonKey(name: 'phone') this.phone,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'services') final List<String>? serviceIds,
      @JsonKey(name: 'services_expand') final List<HostelService>? services,
      @JsonKey(name: 'admin') this.adminId,
      @JsonKey(name: 'admin_expand') this.admin,
      @JsonKey(name: 'created') required this.created,
      @JsonKey(name: 'updated') required this.updated})
      : _serviceIds = serviceIds,
        _services = services;

  factory _$HostelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'capacity')
  final double? capacity;
  @override
  @JsonKey(name: 'location')
  final String? location;
  @override
  @JsonKey(name: 'address')
  final String address;
  @override
  @JsonKey(name: 'phone')
  final String? phone;
  @override
  @JsonKey(name: 'status')
  final HostelStatus status;
  final List<String>? _serviceIds;
  @override
  @JsonKey(name: 'services')
  List<String>? get serviceIds {
    final value = _serviceIds;
    if (value == null) return null;
    if (_serviceIds is EqualUnmodifiableListView) return _serviceIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<HostelService>? _services;
  @override
  @JsonKey(name: 'services_expand')
  List<HostelService>? get services {
    final value = _services;
    if (value == null) return null;
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'admin')
  final String? adminId;
  @override
  @JsonKey(name: 'admin_expand')
  final User? admin;
  @override
  @JsonKey(name: 'created')
  final DateTime created;
  @override
  @JsonKey(name: 'updated')
  final DateTime updated;

  @override
  String toString() {
    return 'Hostel(id: $id, name: $name, capacity: $capacity, location: $location, address: $address, phone: $phone, status: $status, serviceIds: $serviceIds, services: $services, adminId: $adminId, admin: $admin, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._serviceIds, _serviceIds) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            (identical(other.adminId, adminId) || other.adminId == adminId) &&
            (identical(other.admin, admin) || other.admin == admin) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      capacity,
      location,
      address,
      phone,
      status,
      const DeepCollectionEquality().hash(_serviceIds),
      const DeepCollectionEquality().hash(_services),
      adminId,
      admin,
      created,
      updated);

  /// Create a copy of Hostel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HostelImplCopyWith<_$HostelImpl> get copyWith =>
      __$$HostelImplCopyWithImpl<_$HostelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostelImplToJson(
      this,
    );
  }
}

abstract class _Hostel implements Hostel {
  const factory _Hostel(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'capacity') final double? capacity,
          @JsonKey(name: 'location') final String? location,
          @JsonKey(name: 'address') required final String address,
          @JsonKey(name: 'phone') final String? phone,
          @JsonKey(name: 'status') required final HostelStatus status,
          @JsonKey(name: 'services') final List<String>? serviceIds,
          @JsonKey(name: 'services_expand') final List<HostelService>? services,
          @JsonKey(name: 'admin') final String? adminId,
          @JsonKey(name: 'admin_expand') final User? admin,
          @JsonKey(name: 'created') required final DateTime created,
          @JsonKey(name: 'updated') required final DateTime updated}) =
      _$HostelImpl;

  factory _Hostel.fromJson(Map<String, dynamic> json) = _$HostelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'capacity')
  double? get capacity;
  @override
  @JsonKey(name: 'location')
  String? get location;
  @override
  @JsonKey(name: 'address')
  String get address;
  @override
  @JsonKey(name: 'phone')
  String? get phone;
  @override
  @JsonKey(name: 'status')
  HostelStatus get status;
  @override
  @JsonKey(name: 'services')
  List<String>? get serviceIds;
  @override
  @JsonKey(name: 'services_expand')
  List<HostelService>? get services;
  @override
  @JsonKey(name: 'admin')
  String? get adminId;
  @override
  @JsonKey(name: 'admin_expand')
  User? get admin;
  @override
  @JsonKey(name: 'created')
  DateTime get created;
  @override
  @JsonKey(name: 'updated')
  DateTime get updated;

  /// Create a copy of Hostel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HostelImplCopyWith<_$HostelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
