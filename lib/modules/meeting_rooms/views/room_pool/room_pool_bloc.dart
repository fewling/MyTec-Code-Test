import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../../data/room_info/room_info.dart';
import '../../services/meeting_room_service.dart';

part 'room_pool_bloc.freezed.dart';
part 'room_pool_event.dart';
part 'room_pool_state.dart';

class RoomPoolBloc extends Bloc<RoomPoolEvent, RoomPoolState> {
  RoomPoolBloc({required MeetingRoomService meetingRoomService})
    : _meetingRoomService = meetingRoomService,
      super(const RoomPoolState()) {
    on<RoomPoolEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
      },
    );
  }

  final MeetingRoomService _meetingRoomService;

  Future<void> _onStarted(_Started event, Emitter<RoomPoolState> emit) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: RequestStatus.loading));

    final result = await _meetingRoomService.getAllRooms();
    switch (result) {
      case Success<List<RoomInfo>, CustomException>():
        final roomsByRoomCode = <RoomCode, RoomInfo>{};
        final roomsByCentreCode = <CentreCode, List<RoomInfo>>{};

        for (final room in result.value) {
          roomsByRoomCode[room.roomCode] = room;

          if (roomsByCentreCode.containsKey(room.centreCode)) {
            roomsByCentreCode[room.centreCode]!.add(room);
          } else {
            roomsByCentreCode[room.centreCode] = [room];
          }
        }

        emit(
          state.copyWith(
            status: RequestStatus.loaded,
            roomsByCentre: roomsByCentreCode,
            allRooms: roomsByRoomCode,
          ),
        );

      case Failure<List<RoomInfo>, CustomException>():
        emit(
          state.copyWith(
            status: RequestStatus.error,
            exception: result.exception,
          ),
        );
    }
  }
}
