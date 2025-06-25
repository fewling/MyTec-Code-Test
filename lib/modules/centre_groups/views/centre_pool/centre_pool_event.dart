part of 'centre_pool_bloc.dart';

@freezed
sealed class CentrePoolEvent with _$CentrePoolEvent {
  const factory CentrePoolEvent.started() = _Started;
  const factory CentrePoolEvent.retryRequested() = _RetryRequested;
}
