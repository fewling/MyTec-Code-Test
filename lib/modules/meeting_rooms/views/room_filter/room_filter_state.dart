part of 'room_filter_bloc.dart';

@freezed
sealed class RoomFilterState with _$RoomFilterState {
  const factory RoomFilterState({
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    @Default(4) int capacity,
    @Default({}) Set<CentreGroup> selectedCentres,
    @Default(false) bool needVideoConference,

    CustomException? exception,
  }) = _RoomFilterState;
}
