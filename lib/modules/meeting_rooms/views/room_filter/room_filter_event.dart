part of 'room_filter_bloc.dart';

@freezed
sealed class RoomFilterEvent with _$RoomFilterEvent {
  const factory RoomFilterEvent.started({
    /// This is useful for initializing the TempRoomFilterBloc
    /// or updating the state of the RoomFilterBloc by TempRoomFilterBloc.
    RoomFilterState? initialState,
  }) = _Started;

  const factory RoomFilterEvent.datePicked(DateTime date) = _DatePicked;

  const factory RoomFilterEvent.startTimePicked(DateTime startTime) =
      _StartedTimePicked;

  const factory RoomFilterEvent.endTimePicked(DateTime endTime) =
      _EndTimePicked;

  const factory RoomFilterEvent.capacityPicked(int capacity) = _CapacityPicked;

  const factory RoomFilterEvent.centreSelected(CentreGroup centre) =
      _CentreSelected;

  const factory RoomFilterEvent.videoConferenceToggled(
    bool needVideoConference,
  ) = _VideoConferenceToggled;

  const factory RoomFilterEvent.reset({
    required Iterable<CentreGroup> selectedCentres,
  }) = _Reset;

  const factory RoomFilterEvent.newCitySelected(List<CentreGroup> centres) =
      _NewCitySelected;
}
