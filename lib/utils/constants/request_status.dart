part of 'constants.dart';

enum RequestStatus {
  initial,
  loading,
  loaded,
  error;

  bool get isInitial => this == RequestStatus.initial;
  bool get isLoading => this == RequestStatus.loading;
  bool get isLoaded => this == RequestStatus.loaded;
  bool get isError => this == RequestStatus.error;
}
