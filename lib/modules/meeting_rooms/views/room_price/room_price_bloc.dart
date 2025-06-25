import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../utils/extensions/extensions.dart';
import '../../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../../data/room_price/room_price.dart';
import '../../services/meeting_room_service.dart';

part 'room_price_bloc.freezed.dart';
part 'room_price_event.dart';
part 'room_price_state.dart';

class RoomPriceBloc extends Bloc<RoomPriceEvent, RoomPriceState> {
  RoomPriceBloc({required MeetingRoomService meetingRoomService})
    : _meetingRoomService = meetingRoomService,
      super(const RoomPriceState()) {
    on<RoomPriceEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _Requested() => _onRequested(event, emit),
      },
    );
  }

  final MeetingRoomService _meetingRoomService;

  void _onStarted(_Started event, Emitter<RoomPriceState> emit) {}

  Future<void> _onRequested(
    _Requested event,
    Emitter<RoomPriceState> emit,
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

    final result = await _meetingRoomService.getRoomPrice(
      startDate: startDate,
      endDate: endDate,
      cityCode: event.cityCode,
      isVcBooking: event.isVcBooking,
    );

    switch (result) {
      case Success<List<RoomPrice>, CustomException>():
        final prices = {for (final e in result.value) e.roomCode: e};
        emit(state.copyWith(status: RequestStatus.loaded, prices: prices));

      case Failure<List<RoomPrice>, CustomException>():
        emit(
          state.copyWith(
            status: RequestStatus.error,
            exception: result.exception,
          ),
        );
    }
  }
}
