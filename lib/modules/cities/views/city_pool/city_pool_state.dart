part of 'city_pool_bloc.dart';

typedef RegionId = String;
typedef CityCode = String;

@freezed
sealed class CityPoolState with _$CityPoolState {
  const factory CityPoolState({
    @Default(RequestStatus.initial) RequestStatus status,

    @Default(<RegionId, List<City>>{}) Map<RegionId, List<City>> citiesByRegion,

    @Default(<CityCode, City>{}) Map<CityCode, City> allCities,

    City? selectedCity,
    CustomException? exception,
  }) = _CityPoolState;
}
