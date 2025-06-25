part of 'filter_result_bloc.dart';

@freezed
sealed class FilterResultState with _$FilterResultState {
  const factory FilterResultState({
    @Default(<CentreGroup, List<Room>>{}) Map<CentreGroup, List<Room>> rooms,
  }) = _FilterResultState;
}
