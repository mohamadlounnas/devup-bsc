 import 'package:freezed_annotation/freezed_annotation.dart';
 
 part 'facility_event.freezed.dart';
 part 'facility_event.g.dart';
 
 @freezed
 class FacilityEvent with _$FacilityEvent {
 
  factory FacilityEvent({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'body') String? body,
    @JsonKey(name: 'started') DateTime? started,
    @JsonKey(name: 'ended') DateTime? ended,
    @JsonKey(name: 'seats') double? seats,
    @JsonKey(name: 'remaining_seats') double? remainingSeats,
    @JsonKey(name: 'created') required DateTime created,
    @JsonKey(name: 'updated') required DateTime updated,
  }) = _FacilityEvent;
 
  factory FacilityEvent.fromJson(Map<String, dynamic> json) => _$FacilityEventFromJson(json);
 }