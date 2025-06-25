import '../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../data/app_user.dart';
import '../repos/local_authentication_repo.dart';
import '../repos/remote_authentication_repo.dart';

class AuthenticationService {
  AuthenticationService({
    required RemoteAuthenticationRepo remoteAuthenticationRepo,
    required LocalAuthenticationRepo localAuthenticationRepo,
  }) : _remoteAuthenticationRepo = remoteAuthenticationRepo,
       _localAuthenticationRepo = localAuthenticationRepo;

  final RemoteAuthenticationRepo _remoteAuthenticationRepo;
  final LocalAuthenticationRepo _localAuthenticationRepo;

  Future<Result<AppUser, CustomException>> guestLogin() {
    // May get some device info from [LocalAuthenticationRepo],
    // then pass it to the [RemoteAuthenticationRepo] to login as a guest.

    // For demo purposes, we will just call the remote repo directly.
    return _remoteAuthenticationRepo.guestLogin();
  }
}
