part of 'room_price_bloc.dart';

@freezed
sealed class RoomPriceEvent with _$RoomPriceEvent {
  const factory RoomPriceEvent.started() = _Started;

  const factory RoomPriceEvent.requested({
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String cityCode,
    @Default(false) bool isVcBooking,
  }) = _Requested;
}
