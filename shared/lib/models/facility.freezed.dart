// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Facility _$FacilityFromJson(Map<String, dynamic> json) {
  return _Facility.fromJson(json);
}

/// @nodoc
mixin _$Facility {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager')
  String? get managerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_expand')
  User? get manager => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo')
  String? get logo => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover')
  String? get cover => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  FacilityType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'location')
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  DateTime get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  DateTime get updated => throw _privateConstructorUsedError;

  /// Serializes this Facility to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Facility
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacilityCopyWith<Facility> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacilityCopyWith<$Res> {
  factory $FacilityCopyWith(Facility value, $Res Function(Facility) then) =
      _$FacilityCopyWithImpl<$Res, Facility>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'manager') String? managerId,
      @JsonKey(name: 'manager_expand') User? manager,
      @JsonKey(name: 'logo') String? logo,
      @JsonKey(name: 'cover') String? cover,
      @JsonKey(name: 'type') FacilityType type,
      @JsonKey(name: 'location') String? location,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});

  $UserCopyWith<$Res>? get manager;
}

/// @nodoc
class _$FacilityCopyWithImpl<$Res, $Val extends Facility>
    implements $FacilityCopyWith<$Res> {
  _$FacilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Facility
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? managerId = freezed,
    Object? manager = freezed,
    Object? logo = freezed,
    Object? cover = freezed,
    Object? type = null,
    Object? location = freezed,
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
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _value.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as User?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      cover: freezed == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FacilityType,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of Facility
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get manager {
    if (_value.manager == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.manager!, (value) {
      return _then(_value.copyWith(manager: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FacilityImplCopyWith<$Res>
    implements $FacilityCopyWith<$Res> {
  factory _$$FacilityImplCopyWith(
          _$FacilityImpl value, $Res Function(_$FacilityImpl) then) =
      __$$FacilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'manager') String? managerId,
      @JsonKey(name: 'manager_expand') User? manager,
      @JsonKey(name: 'logo') String? logo,
      @JsonKey(name: 'cover') String? cover,
      @JsonKey(name: 'type') FacilityType type,
      @JsonKey(name: 'location') String? location,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});

  @override
  $UserCopyWith<$Res>? get manager;
}

/// @nodoc
class __$$FacilityImplCopyWithImpl<$Res>
    extends _$FacilityCopyWithImpl<$Res, _$FacilityImpl>
    implements _$$FacilityImplCopyWith<$Res> {
  __$$FacilityImplCopyWithImpl(
      _$FacilityImpl _value, $Res Function(_$FacilityImpl) _then)
      : super(_value, _then);

  /// Create a copy of Facility
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? managerId = freezed,
    Object? manager = freezed,
    Object? logo = freezed,
    Object? cover = freezed,
    Object? type = null,
    Object? location = freezed,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_$FacilityImpl(
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
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _value.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as User?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      cover: freezed == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FacilityType,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
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
class _$FacilityImpl implements _Facility {
  const _$FacilityImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'manager') this.managerId,
      @JsonKey(name: 'manager_expand') this.manager,
      @JsonKey(name: 'logo') this.logo,
      @JsonKey(name: 'cover') this.cover,
      @JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'location') this.location,
      @JsonKey(name: 'created') required this.created,
      @JsonKey(name: 'updated') required this.updated});

  factory _$FacilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacilityImplFromJson(json);

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
  @JsonKey(name: 'manager')
  final String? managerId;
  @override
  @JsonKey(name: 'manager_expand')
  final User? manager;
  @override
  @JsonKey(name: 'logo')
  final String? logo;
  @override
  @JsonKey(name: 'cover')
  final String? cover;
  @override
  @JsonKey(name: 'type')
  final FacilityType type;
  @override
  @JsonKey(name: 'location')
  final String? location;
  @override
  @JsonKey(name: 'created')
  final DateTime created;
  @override
  @JsonKey(name: 'updated')
  final DateTime updated;

  @override
  String toString() {
    return 'Facility(id: $id, name: $name, description: $description, managerId: $managerId, manager: $manager, logo: $logo, cover: $cover, type: $type, location: $location, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacilityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.manager, manager) || other.manager == manager) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, managerId,
      manager, logo, cover, type, location, created, updated);

  /// Create a copy of Facility
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacilityImplCopyWith<_$FacilityImpl> get copyWith =>
      __$$FacilityImplCopyWithImpl<_$FacilityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacilityImplToJson(
      this,
    );
  }
}

abstract class _Facility implements Facility {
  const factory _Facility(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'manager') final String? managerId,
          @JsonKey(name: 'manager_expand') final User? manager,
          @JsonKey(name: 'logo') final String? logo,
          @JsonKey(name: 'cover') final String? cover,
          @JsonKey(name: 'type') required final FacilityType type,
          @JsonKey(name: 'location') final String? location,
          @JsonKey(name: 'created') required final DateTime created,
          @JsonKey(name: 'updated') required final DateTime updated}) =
      _$FacilityImpl;

  factory _Facility.fromJson(Map<String, dynamic> json) =
      _$FacilityImpl.fromJson;

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
  @JsonKey(name: 'manager')
  String? get managerId;
  @override
  @JsonKey(name: 'manager_expand')
  User? get manager;
  @override
  @JsonKey(name: 'logo')
  String? get logo;
  @override
  @JsonKey(name: 'cover')
  String? get cover;
  @override
  @JsonKey(name: 'type')
  FacilityType get type;
  @override
  @JsonKey(name: 'location')
  String? get location;
  @override
  @JsonKey(name: 'created')
  DateTime get created;
  @override
  @JsonKey(name: 'updated')
  DateTime get updated;

  /// Create a copy of Facility
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacilityImplCopyWith<_$FacilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
