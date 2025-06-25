part of 'room_price_bloc.dart';

typedef RoomCode = String;

@freezed
sealed class RoomPriceState with _$RoomPriceState {
  const factory RoomPriceState({
    @Default(RequestStatus.initial) RequestStatus status,

    @Default(<RoomCode, RoomPrice>{}) Map<RoomCode, RoomPrice> prices,

    CustomException? exception,
  }) = _RoomPriceState;
}
