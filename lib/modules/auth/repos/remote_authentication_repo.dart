import '../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../data/app_user.dart';

class RemoteAuthenticationRepo with CustomExceptionHandler {
  Future<Result<AppUser, CustomException>> guestLogin() =>
      tryRunAsync(() async {
        // Maybe send some device info to server to create a guest user.
        // Yet, for demo purpose and simplicity, just use timestamp as ID.
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        return AppUser.guest(id: id);
      });

  Future<Result<bool, CustomException>> logout() => tryRunAsync(() {
    // Here you would typically call an API to log out the user.
    // For demo purposes, we just return true to indicate success.
    return Future.value(true);
  });
}
