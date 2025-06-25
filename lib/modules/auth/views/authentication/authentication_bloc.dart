import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../../data/app_user.dart';
import '../../services/authentication_service.dart';

part 'authentication_bloc.freezed.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required AuthenticationService authenticationService})
    : _authenticationService = authenticationService,
      super(const AuthenticationState()) {
    on<AuthenticationEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
      },
    );
  }

  final AuthenticationService _authenticationService;

  Future<void> _onStarted(
    _Started event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: AuthenticationStatus.loading));

    // await Future.delayed(const Duration(seconds: 1));

    final result = await _authenticationService.guestLogin();
    switch (result) {
      case Success<AppUser, CustomException>():
        emit(
          state.copyWith(
            status: AuthenticationStatus.authenticated,
            user: result.value,
          ),
        );
      case Failure<AppUser, CustomException>():
        emit(
          state.copyWith(
            status: AuthenticationStatus.error,
            exception: result.exception,
          ),
        );
    }
  }
}
