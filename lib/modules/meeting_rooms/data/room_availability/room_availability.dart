import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_availability.freezed.dart';
part 'room_availability.g.dart';

@freezed
sealed class RoomAvailability with _$RoomAvailability {
  const factory RoomAvailability({
    required String roomCode,
    required bool isAvailable,
    required bool isWithinOfficeHour,
    required bool isPast,

    // ? Could not find out the type of nextAvailablities items from the API.
    // ? Assuming it is a list of dynamic objects for now.
    @Default(<dynamic>[]) List<dynamic> nextAvailablities,
  }) = _RoomAvailability;

  factory RoomAvailability.fromJson(Map<String, dynamic> json) =>
      _$RoomAvailabilityFromJson(json);
}
