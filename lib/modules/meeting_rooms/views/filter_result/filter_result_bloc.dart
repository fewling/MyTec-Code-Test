import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../centre_groups/data/centre_group.dart';
import '../../models/room.dart';

part 'filter_result_bloc.freezed.dart';
part 'filter_result_event.dart';
part 'filter_result_state.dart';

class FilterResultBloc extends Bloc<FilterResultEvent, FilterResultState> {
  FilterResultBloc() : super(const FilterResultState()) {
    on<FilterResultEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _Sorted() => _onSorted(event, emit),
      },
    );
  }

  void _onStarted(_Started event, Emitter<FilterResultState> emit) {}

  void _onSorted(_Sorted event, Emitter<FilterResultState> emit) =>
      emit(state.copyWith(rooms: event.sortedRooms));
}
