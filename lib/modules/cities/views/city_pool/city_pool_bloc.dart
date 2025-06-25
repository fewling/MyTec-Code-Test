import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../../data/city.dart';
import '../../services/city_service.dart';

part 'city_pool_bloc.freezed.dart';
part 'city_pool_event.dart';
part 'city_pool_state.dart';

class CityPoolBloc extends Bloc<CityPoolEvent, CityPoolState> {
  CityPoolBloc({required CityService cityService})
    : _cityService = cityService,
      super(const CityPoolState()) {
    on<CityPoolEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _CitySelected() => _onCitySelected(event, emit),
        _RetryRequested() => _onRetryRequested(event, emit),
      },
    );
  }

  final CityService _cityService;

  Future<void> _onStarted(_Started event, Emitter<CityPoolState> emit) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: RequestStatus.loading));

    final result = await _cityService.getAllCities();
    switch (result) {
      case Success<List<City>, CustomException>():
        final citiesByRegion = <RegionId, List<City>>{};
        final allCities = <CityCode, City>{};

        for (final city in result.value) {
          allCities[city.code] = city;

          final regionId = city.region.id;
          if (citiesByRegion.containsKey(regionId)) {
            citiesByRegion[regionId]!.add(city);
          } else {
            citiesByRegion[regionId] = [city];
          }
        }

        emit(
          state.copyWith(
            status: RequestStatus.loaded,
            citiesByRegion: citiesByRegion,
            allCities: allCities,
            selectedCity:
                allCities[state.selectedCity?.code] ??
                allCities.values.firstOrNull,
          ),
        );

      case Failure<List<City>, CustomException>():
        emit(
          state.copyWith(
            status: RequestStatus.error,
            exception: result.exception,
          ),
        );
    }
  }

  void _onCitySelected(_CitySelected event, Emitter<CityPoolState> emit) =>
      emit(state.copyWith(selectedCity: event.city));

  void _onRetryRequested(_RetryRequested event, Emitter<CityPoolState> emit) =>
      add(const CityPoolEvent.started());
}
