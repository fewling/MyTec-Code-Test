import 'dart:convert';

import '../../../utils/mixins/api_clients/tec/tec_api_client.dart';
import '../../../utils/mixins/exceptions/custom_exception_handler.dart';

class RemoteCityRepo with CustomExceptionHandler, TecApiClient {
  Future<Result<TecPaginatedResponse, CustomException>> getCities({
    int pageSize = 100,
    int pageNumber = 1,
  }) => tryRunAsync(() async {
    final response = await requestTEC(
      request: TecApiRequest.getCity(
        query: CityQuery(pageSize: pageSize, pageNumber: pageNumber),
      ),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return TecPaginatedResponse.fromJson(json);
  });
}
