part of 'city_pool_bloc.dart';

@freezed
sealed class CityPoolEvent with _$CityPoolEvent {
  const factory CityPoolEvent.started() = _Started;
  const factory CityPoolEvent.retryRequested() = _RetryRequested;
  const factory CityPoolEvent.citySelected(City? city) = _CitySelected;
}
