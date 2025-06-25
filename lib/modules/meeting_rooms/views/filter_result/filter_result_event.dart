part of 'filter_result_bloc.dart';

@freezed
sealed class FilterResultEvent with _$FilterResultEvent {
  const factory FilterResultEvent.started() = _Started;
  const factory FilterResultEvent.sorted({
    required Map<CentreGroup, List<Room>> sortedRooms,
  }) = _Sorted;
}
