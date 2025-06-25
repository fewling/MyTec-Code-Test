import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../../data/centre_group.dart';
import '../../services/centre_group_service.dart';

part 'centre_pool_bloc.freezed.dart';
part 'centre_pool_event.dart';
part 'centre_pool_state.dart';

class CentrePoolBloc extends Bloc<CentrePoolEvent, CentrePoolState> {
  CentrePoolBloc({required CentreGroupService centreGroupService})
    : _centreGroupService = centreGroupService,
      super(const CentrePoolState()) {
    on<CentrePoolEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _RetryRequested() => _onRetryRequested(event, emit),
      },
    );
  }

  final CentreGroupService _centreGroupService;

  Future<void> _onStarted(_Started event, Emitter<CentrePoolState> emit) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: RequestStatus.loading));

    final result = await _centreGroupService.getCentreGroups();
    switch (result) {
      case Success<List<CentreGroup>, CustomException>():
        final centresByCentreCode = <CentreCode, CentreGroup>{};
        final centresByCityCode = <CityCode, List<CentreGroup>>{};

        for (final centre in result.value) {
          for (final code in centre.centreCodes) {
            centresByCentreCode[code] = centre;
          }

          if (centresByCityCode.containsKey(centre.cityCode)) {
            centresByCityCode[centre.cityCode]!.add(centre);
          } else {
            centresByCityCode[centre.cityCode] = [centre];
          }
        }

        emit(
          state.copyWith(
            status: RequestStatus.loaded,
            centresByCity: centresByCityCode,
            allCentres: centresByCentreCode,
          ),
        );

      case Failure<List<CentreGroup>, CustomException>():
        emit(
          state.copyWith(
            status: RequestStatus.error,
            exception: result.exception,
          ),
        );
    }
  }

  void _onRetryRequested(
    _RetryRequested event,
    Emitter<CentrePoolState> emit,
  ) => add(const CentrePoolEvent.started());
}
