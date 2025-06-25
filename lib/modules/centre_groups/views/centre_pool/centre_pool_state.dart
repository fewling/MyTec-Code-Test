part of 'centre_pool_bloc.dart';

typedef CityCode = String;
typedef CentreCode = String;

@freezed
sealed class CentrePoolState with _$CentrePoolState {
  const factory CentrePoolState({
    @Default(RequestStatus.initial) RequestStatus status,
    @Default(<CityCode, List<CentreGroup>>{})
    Map<CityCode, List<CentreGroup>> centresByCity,

    @Default(<CentreCode, CentreGroup>{})
    Map<CentreCode, CentreGroup> allCentres,
    CustomException? exception,
  }) = _CentrePoolState;
}
