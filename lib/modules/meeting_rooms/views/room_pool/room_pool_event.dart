part of 'room_pool_bloc.dart';

@freezed
sealed class RoomPoolEvent with _$RoomPoolEvent {
  const factory RoomPoolEvent.started() = _Started;
  const factory RoomPoolEvent.retryRequested() = _RetryRequested;
}
