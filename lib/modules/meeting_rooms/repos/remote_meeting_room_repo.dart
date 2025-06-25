import 'dart:convert';

import '../../../utils/extensions/extensions.dart';
import '../../../utils/mixins/api_clients/tec/tec_api_client.dart';
import '../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../data/room_availability/room_availability.dart';
import '../data/room_price/room_price.dart';

class RemoteMeetingRoomRepo with CustomExceptionHandler, TecApiClient {
  Future<Result<List<RoomAvailability>, CustomException>> getAvailableRooms({
    required DateTime startDate,
    required DateTime endDate,
    required String cityCode,
  }) => tryRunAsync(() async {
    final response = await requestTEC(
      request: TecApiRequest.getRoomAvailability(
        query: RoomAvailabilityQuery(
          startDate: startDate,
          endDate: endDate,
          cityCode: cityCode,
        ),
      ),
    );

    // ! For request with:
    // start: 2025-06-29T23:30:00
    // end: 2025-06-30T00:00:00
    //
    // ! Server returns 500...
    // "'2025-06-29T23: 30: 00 to 2025-06-30T00: 00: 00' is an invalid time slot. Start date must be lower than end date and must start at 00/15/30/45."
    //
    // ! Plain error message instead of defined error code.
    // ! For demo purposes, assume that if the response is a failure,
    // ! it means the time slot is invalid.
    if (response.isFailure) {
      throw AppException(AppExceptionCode.invalidTimeSlot);
    }

    final json = jsonDecode(response.body) as List<dynamic>;
    return json
        .map((e) => RoomAvailability.fromJson(e as Map<String, dynamic>))
        .toList();
  });

  Future<Result<TecPaginatedResponse, CustomException>> getRoomInfos({
    required int pageNumber,
    required int pageSize,
    String? cityCode,
  }) => tryRunAsync(() async {
    final response = await requestTEC(
      request: TecApiRequest.getRoomInfo(
        query: RoomInfoQuery(
          pageNumber: pageNumber,
          pageSize: pageSize,
          cityCode: cityCode,
        ),
      ),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return TecPaginatedResponse.fromJson(json);
  });

  Future<Result<List<RoomPrice>, CustomException>> getRoomPrices({
    required DateTime startDate,
    required DateTime endDate,
    required String cityCode,
    bool isVcBooking = false,
  }) => tryRunAsync(() async {
    final response = await requestTEC(
      request: TecApiRequest.getRoomPrice(
        query: RoomPriceQuery(
          startDate: startDate,
          endDate: endDate,
          cityCode: cityCode,
        ),
      ),
    );

    final json = jsonDecode(response.body) as List<dynamic>;
    return json
        .map((e) => RoomPrice.fromJson(e as Map<String, dynamic>))
        .toList();
  });
}
