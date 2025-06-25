part of 'custom_exception_handler.dart';

enum AppExceptionCode {
  invalidTimeSlot(10001, 'Invalid time slot.');

  const AppExceptionCode(this.code, this.label);

  final int code;
  final String label;
}

// May need a better name for this, too generic
enum TecExceptionCode {
  unAuthenticated(20000, 'User is not authenticated.');

  const TecExceptionCode(this.code, this.label);

  final int code;
  final String label;
}

enum UnknownExceptionCode {
  unknown(999999, 'An unknown error occurred.');

  const UnknownExceptionCode(this.code, this.label);

  final int code;
  final String label;
}
