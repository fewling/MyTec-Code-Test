part of 'room_pool_bloc.dart';

typedef CentreCode = String;
typedef RoomCode = String;

@freezed
sealed class RoomPoolState with _$RoomPoolState {
  const factory RoomPoolState({
    @Default(RequestStatus.initial) RequestStatus status,

    @Default(<CentreCode, List<RoomInfo>>{})
    Map<CentreCode, List<RoomInfo>> roomsByCentre,

    @Default(<RoomCode, RoomInfo>{}) Map<RoomCode, RoomInfo> allRooms,

    CustomException? exception,
  }) = _RoomPoolState;
}
