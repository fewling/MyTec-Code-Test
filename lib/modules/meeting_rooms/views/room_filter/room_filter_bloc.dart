import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/extensions/extensions.dart';
import '../../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../../../centre_groups/data/centre_group.dart';

part 'room_filter_bloc.freezed.dart';
part 'room_filter_event.dart';
part 'room_filter_state.dart';

final _initialState = RoomFilterState(
  date: DateTime.now(),
  startTime: DateTime.now().toMinuteInterval().timeOfDay,
  endTime: DateTime.now()
      .toMinuteInterval()
      .add(const Duration(hours: 1))
      .timeOfDay,
);

class RoomFilterBloc extends Bloc<RoomFilterEvent, RoomFilterState>
    with RoomFilterMixin {
  RoomFilterBloc() : super(_initialState) {
    on<RoomFilterEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _DatePicked() => _onDatePicked(event, emit),
        _StartedTimePicked() => _onStartTimePicked(event, emit),
        _EndTimePicked() => _onEndTimePicked(event, emit),
        _CapacityPicked() => _onCapacityPicked(event, emit),
        _CentreSelected() => _onCentreSelected(event, emit),
        _VideoConferenceToggled() => _onVideoConferenceToggled(event, emit),
        _Reset() => _onReset(event, emit),
        _NewCitySelected() => _onNewCitySelected(event, emit),
      },
    );
  }
}

class TempRoomFilterBloc extends Bloc<RoomFilterEvent, RoomFilterState>
    with RoomFilterMixin {
  TempRoomFilterBloc() : super(_initialState) {
    on<RoomFilterEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _DatePicked() => _onDatePicked(event, emit),
        _StartedTimePicked() => _onStartTimePicked(event, emit),
        _EndTimePicked() => _onEndTimePicked(event, emit),
        _CapacityPicked() => _onCapacityPicked(event, emit),
        _CentreSelected() => _onCentreSelected(event, emit),
        _VideoConferenceToggled() => _onVideoConferenceToggled(event, emit),
        _Reset() => _onReset(event, emit),
        _NewCitySelected() => _onNewCitySelected(event, emit),
      },
    );
  }
}

mixin RoomFilterMixin<E extends RoomFilterEvent, S extends RoomFilterState>
    on Bloc<E, S> {
  void _onStarted(_Started event, Emitter<RoomFilterState> emit) {
    final initialState = event.initialState;
    if (initialState != null) {
      emit(initialState);
      return;
    }

    emit(
      RoomFilterState(
        date: DateTime.now(),
        startTime: DateTime.now().toMinuteInterval().timeOfDay,
        endTime: DateTime.now()
            .toMinuteInterval()
            .add(const Duration(hours: 1))
            .timeOfDay,
      ),
    );
  }

  void _onDatePicked(_DatePicked event, Emitter<RoomFilterState> emit) =>
      emit(state.copyWith(date: event.date));

  void _onStartTimePicked(
    _StartedTimePicked event,
    Emitter<RoomFilterState> emit,
  ) {
    final startDT = event.startTime;
    final endT = state.endTime;

    if (startDT.hour > endT.hour ||
        (startDT.hour == endT.hour && startDT.minute >= endT.minute)) {
      final startTime = startDT.timeOfDay;
      final endTime = startDT.add(const Duration(hours: 1)).timeOfDay;

      emit(state.copyWith(startTime: startTime, endTime: endTime));
    } else {
      emit(state.copyWith(startTime: TimeOfDay.fromDateTime(startDT)));
    }
  }

  void _onEndTimePicked(_EndTimePicked event, Emitter<RoomFilterState> emit) {
    final endDT = event.endTime;
    final startDT = state.startTime;

    if (endDT.hour < startDT.hour ||
        (endDT.hour == startDT.hour && endDT.minute <= startDT.minute)) {
      final endTime = endDT.timeOfDay;

      var startTime = endDT.subtract(const Duration(hours: 1)).timeOfDay;
      if (startTime.hour < 0) {
        // If the start time goes before midnight, reset to 00:00
        startTime = const TimeOfDay(hour: 0, minute: 0);
      }

      emit(state.copyWith(startTime: startTime, endTime: endTime));
    } else {
      emit(state.copyWith(endTime: TimeOfDay.fromDateTime(endDT)));
    }
  }

  void _onCapacityPicked(
    _CapacityPicked event,
    Emitter<RoomFilterState> emit,
  ) => emit(state.copyWith(capacity: event.capacity));

  void _onCentreSelected(_CentreSelected event, Emitter<RoomFilterState> emit) {
    final centre = event.centre;
    final centres = {...state.selectedCentres};
    emit(state.copyWith(selectedCentres: centres.toggle(centre)));
  }

  void _onVideoConferenceToggled(
    _VideoConferenceToggled event,
    Emitter<RoomFilterState> emit,
  ) => emit(state.copyWith(needVideoConference: event.needVideoConference));

  void _onReset(_Reset event, Emitter<RoomFilterState> emit) =>
      emit(_initialState.copyWith(
        selectedCentres: Set.from(event.selectedCentres),
      ));

  void _onNewCitySelected(
    _NewCitySelected event,
    Emitter<RoomFilterState> emit,
  ) => emit(state.copyWith(selectedCentres: {...event.centres}));
}
