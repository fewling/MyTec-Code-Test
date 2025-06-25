part of 'available_rooms_bloc.dart';

@freezed
sealed class AvailableRoomsEvent with _$AvailableRoomsEvent {
  const factory AvailableRoomsEvent.started() = _Started;

  const factory AvailableRoomsEvent.requested({
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String cityCode,
  }) = _Requested;
}
