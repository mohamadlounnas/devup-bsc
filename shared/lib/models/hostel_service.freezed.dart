// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hostel_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HostelService _$HostelServiceFromJson(Map<String, dynamic> json) {
  return _HostelService.fromJson(json);
}

/// @nodoc
mixin _$HostelService {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @ServiceTypeConverter()
  @JsonKey(name: 'type')
  ServiceType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon')
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  DateTime get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  DateTime get updated => throw _privateConstructorUsedError;

  /// Serializes this HostelService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HostelService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HostelServiceCopyWith<HostelService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostelServiceCopyWith<$Res> {
  factory $HostelServiceCopyWith(
          HostelService value, $Res Function(HostelService) then) =
      _$HostelServiceCopyWithImpl<$Res, HostelService>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @ServiceTypeConverter() @JsonKey(name: 'type') ServiceType type,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'icon') String? icon,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});
}

/// @nodoc
class _$HostelServiceCopyWithImpl<$Res, $Val extends HostelService>
    implements $HostelServiceCopyWith<$Res> {
  _$HostelServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HostelService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? icon = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ServiceType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
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
abstract class _$$HostelServiceImplCopyWith<$Res>
    implements $HostelServiceCopyWith<$Res> {
  factory _$$HostelServiceImplCopyWith(
          _$HostelServiceImpl value, $Res Function(_$HostelServiceImpl) then) =
      __$$HostelServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @ServiceTypeConverter() @JsonKey(name: 'type') ServiceType type,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'icon') String? icon,
      @JsonKey(name: 'created') DateTime created,
      @JsonKey(name: 'updated') DateTime updated});
}

/// @nodoc
class __$$HostelServiceImplCopyWithImpl<$Res>
    extends _$HostelServiceCopyWithImpl<$Res, _$HostelServiceImpl>
    implements _$$HostelServiceImplCopyWith<$Res> {
  __$$HostelServiceImplCopyWithImpl(
      _$HostelServiceImpl _value, $Res Function(_$HostelServiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of HostelService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_$HostelServiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ServiceType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
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
class _$HostelServiceImpl implements _HostelService {
  const _$HostelServiceImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @ServiceTypeConverter() @JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'icon') this.icon,
      @JsonKey(name: 'created') required this.created,
      @JsonKey(name: 'updated') required this.updated});

  factory _$HostelServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostelServiceImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @ServiceTypeConverter()
  @JsonKey(name: 'type')
  final ServiceType type;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'icon')
  final String? icon;
  @override
  @JsonKey(name: 'created')
  final DateTime created;
  @override
  @JsonKey(name: 'updated')
  final DateTime updated;

  @override
  String toString() {
    return 'HostelService(id: $id, name: $name, type: $type, description: $description, icon: $icon, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostelServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, type, description, icon, created, updated);

  /// Create a copy of HostelService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HostelServiceImplCopyWith<_$HostelServiceImpl> get copyWith =>
      __$$HostelServiceImplCopyWithImpl<_$HostelServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostelServiceImplToJson(
      this,
    );
  }
}

abstract class _HostelService implements HostelService {
  const factory _HostelService(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'name') required final String name,
          @ServiceTypeConverter()
          @JsonKey(name: 'type')
          required final ServiceType type,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'icon') final String? icon,
          @JsonKey(name: 'created') required final DateTime created,
          @JsonKey(name: 'updated') required final DateTime updated}) =
      _$HostelServiceImpl;

  factory _HostelService.fromJson(Map<String, dynamic> json) =
      _$HostelServiceImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @ServiceTypeConverter()
  @JsonKey(name: 'type')
  ServiceType get type;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'icon')
  String? get icon;
  @override
  @JsonKey(name: 'created')
  DateTime get created;
  @override
  @JsonKey(name: 'updated')
  DateTime get updated;

  /// Create a copy of HostelService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HostelServiceImplCopyWith<_$HostelServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
