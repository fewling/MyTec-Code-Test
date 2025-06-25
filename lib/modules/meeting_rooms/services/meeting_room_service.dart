import '../../../utils/logging/logger.dart';
import '../../../utils/mixins/api_clients/tec/tec_api_client.dart';
import '../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../data/room_availability/room_availability.dart';
import '../data/room_info/room_info.dart';
import '../data/room_price/room_price.dart';
import '../repos/remote_meeting_room_repo.dart';

class MeetingRoomService with CustomExceptionHandler {
  MeetingRoomService({required RemoteMeetingRoomRepo remoteMeetingRoomRepo})
    : _remoteMeetingRoomRepo = remoteMeetingRoomRepo;

  final RemoteMeetingRoomRepo _remoteMeetingRoomRepo;

  Future<Result<List<RoomAvailability>, CustomException>> getAvailableRooms({
    required DateTime startDate,
    required DateTime endDate,
    required String cityCode,
  }) => _remoteMeetingRoomRepo.getAvailableRooms(
    startDate: startDate,
    endDate: endDate,
    cityCode: cityCode,
  );

  Future<Result<List<RoomPrice>, CustomException>> getRoomPrice({
    required DateTime startDate,
    required DateTime endDate,
    required String cityCode,
    bool isVcBooking = false,
  }) {
    return _remoteMeetingRoomRepo.getRoomPrices(
      startDate: startDate,
      endDate: endDate,
      cityCode: cityCode,
      isVcBooking: isVcBooking,
    );
  }

  Future<Result<TecPaginatedResponse, CustomException>> getRoomInfoPage({
    required int pageNumber,
    required int pageSize,
    String? cityCode,
  }) => _remoteMeetingRoomRepo.getRoomInfos(
    pageNumber: pageNumber,
    pageSize: pageSize,
    cityCode: cityCode,
  );

  Future<Result<List<RoomInfo>, CustomException>>
  getAllRooms() => tryRunAsync(() async {
    final allRooms = <RoomInfo>[];

    var pageNumber = 1;
    var isLastPage = false;

    while (!isLastPage) {
      final result = await _remoteMeetingRoomRepo.getRoomInfos(
        pageNumber: pageNumber,
        pageSize: 100,
      );

      switch (result) {
        case Success<TecPaginatedResponse, CustomException>():
          final paginatedResponse = result.value;
          allRooms.addAll(
            paginatedResponse.items
                .map((item) => RoomInfo.fromJson(item as Map<String, dynamic>))
                .toList(),
          );
          isLastPage = paginatedResponse.isLastPage;
          pageNumber++;
        case Failure<TecPaginatedResponse, CustomException>():
          logger.e(
            'getAllRooms: Failed to fetch page $pageNumber: ${result.exception}',
          );
          // Handle the error, or break/throw
          isLastPage = true;
          throw result.exception;
      }
    }

    return allRooms;
  });

  Future<Result<List<RoomInfo>, CustomException>> getAllRoomsByCityCode(
    String cityCode,
  ) => tryRunAsync(() async {
    final allRooms = <RoomInfo>[];

    var pageNumber = 1;
    var isLastPage = false;

    while (!isLastPage) {
      final result = await _remoteMeetingRoomRepo.getRoomInfos(
        pageNumber: pageNumber,
        pageSize: 100,
        cityCode: cityCode,
      );

      switch (result) {
        case Success<TecPaginatedResponse, CustomException>():
          final paginatedResponse = result.value;
          allRooms.addAll(
            paginatedResponse.items
                .map((item) => RoomInfo.fromJson(item as Map<String, dynamic>))
                .toList(),
          );
          isLastPage = paginatedResponse.isLastPage;
          pageNumber++;
        case Failure<TecPaginatedResponse, CustomException>():
          logger.e(
            'getAllRoomsByCityCode: Failed to fetch page $pageNumber: ${result.exception}',
          );
          // Handle the error, or break/throw
          isLastPage = true;
          throw result.exception;
      }
    }

    return allRooms;
  });
}
