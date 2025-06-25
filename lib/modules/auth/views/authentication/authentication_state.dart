part of 'authentication_bloc.dart';

@freezed
sealed class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @Default(AuthenticationStatus.initial) AuthenticationStatus status,
    CustomException? exception,
    AppUser? user,
  }) = _AuthenticationState;
}

enum AuthenticationStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error;

  bool get isInitial => this == AuthenticationStatus.initial;
  bool get isLoading => this == AuthenticationStatus.loading;
  bool get isAuthenticated => this == AuthenticationStatus.authenticated;
  bool get isUnauthenticated => this == AuthenticationStatus.unauthenticated;
  bool get isError => this == AuthenticationStatus.error;
}
