import '../../../utils/logging/logger.dart';
import '../../../utils/mixins/api_clients/tec/tec_api_client.dart';
import '../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../data/city.dart';
import '../repos/remote_city_repo.dart';

class CityService with CustomExceptionHandler {
  CityService({required RemoteCityRepo remoteCityRepo})
    : _remoteCityRepo = remoteCityRepo;

  final RemoteCityRepo _remoteCityRepo;

  Future<Result<TecPaginatedResponse, CustomException>> getCityPage({
    required int pageNumber,
    required int pageSize,
  }) => _remoteCityRepo.getCities(pageNumber: pageNumber, pageSize: pageSize);

  Future<Result<List<City>, CustomException>>
  getAllCities() => tryRunAsync(() async {
    final allCities = <City>[];

    var pageNumber = 1;
    var isLastPage = false;

    while (!isLastPage) {
      final result = await getCityPage(pageNumber: pageNumber, pageSize: 100);
      switch (result) {
        case Success<TecPaginatedResponse, CustomException>():
          final paginatedResponse = result.value;
          allCities.addAll(
            paginatedResponse.items
                .map((item) => City.fromJson(item as Map<String, dynamic>))
                .toList(),
          );
          isLastPage = paginatedResponse.isLastPage;
          pageNumber++;
        case Failure<TecPaginatedResponse, CustomException>():
          logger.e(
            'getAllCities: Failed to fetch page $pageNumber: ${result.exception}',
          );
          // Optionally handle the error, or break/throw
          isLastPage = true;
          throw result.exception;
      }
    }
    return allCities;
  });
}
