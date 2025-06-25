import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../utils/extensions/extensions.dart';
import '../../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../../data/room_availability/room_availability.dart';
import '../../services/meeting_room_service.dart';

part 'available_rooms_bloc.freezed.dart';
part 'available_rooms_event.dart';
part 'available_rooms_state.dart';

class AvailableRoomsBloc
    extends Bloc<AvailableRoomsEvent, AvailableRoomsState> {
  AvailableRoomsBloc({required MeetingRoomService meetingRoomService})
    : _meetingRoomService = meetingRoomService,
      super(const AvailableRoomsState()) {
    on<AvailableRoomsEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _Requested() => _onRequested(event, emit),
      },
    );
  }

  final MeetingRoomService _meetingRoomService;

  void _onStarted(_Started event, Emitter<AvailableRoomsState> emit) {}

  Future<void> _onRequested(
    _Requested event,
    Emitter<AvailableRoomsState> emit,
  ) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: RequestStatus.loading));

    final date = event.date;
    final startTime = event.startTime;
    final endTime = event.endTime;

    final minuteDiff = endTime.differenceInMinutes(startTime);
    final startDate = DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );
    final endDate = DateTime(
      date.year,
      date.month,
      date.day,
      endTime.hour,
      endTime.minute,
    );
    if (minuteDiff < 0) endDate.add(const Duration(days: 1));

    final result = await _meetingRoomService.getAvailableRooms(
      startDate: startDate,
      endDate: endDate,
      cityCode: event.cityCode,
    );

    switch (result) {
      case Success<List<RoomAvailability>, CustomException>():
        emit(
          state.copyWith(
            status: RequestStatus.loaded,
            availableRooms: result.value,
          ),
        );

      case Failure<List<RoomAvailability>, CustomException>():
        emit(
          state.copyWith(
            status: RequestStatus.error,
            exception: result.exception,
          ),
        );
    }
  }
}
