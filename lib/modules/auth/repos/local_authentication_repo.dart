class LocalAuthenticationRepo {
  // Checks if device supports local authentication (biometrics or PIN)
  Future<bool> isDeviceSupported() => throw UnimplementedError();

  // Checks if biometrics are available
  Future<bool> canCheckBiometrics() => throw UnimplementedError();

  // Returns a list of available biometric types
  Future<List<String>> getAvailableBiometrics() => throw UnimplementedError();

  // Initiates authentication (biometrics or PIN)
  Future<bool> authenticate({String reason = 'Authenticate to continue'}) =>
      throw UnimplementedError();

  // Cancels ongoing authentication
  Future<void> cancelAuthentication() => throw UnimplementedError();
}
