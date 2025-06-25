part of 'available_rooms_bloc.dart';

@freezed
sealed class AvailableRoomsState with _$AvailableRoomsState {
  const factory AvailableRoomsState({
    @Default(RequestStatus.initial) RequestStatus status,

    @Default(<RoomAvailability>[]) List<RoomAvailability> availableRooms,

    CustomException? exception,
  }) = _AvailableRoomsState;
}
