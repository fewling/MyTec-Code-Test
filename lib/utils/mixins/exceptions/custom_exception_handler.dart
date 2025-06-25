import '../../logging/logger.dart';

part 'custom_exception.dart';
part 'exception_code.dart';
part 'result.dart';

mixin CustomExceptionHandler {
  /// Run the operation and catch any exceptions.
  ///
  /// If an exception is caught, it will be handled and rethrown as a [CustomException].
  Result<T, CustomException> tryRun<T>(T Function() operation) {
    try {
      final result = operation();
      return Success(result);
    } on CustomException catch (e) {
      logger.e('tryRun: CustomException: $e');
      return Failure(e);
    } catch (e) {
      logger.e('tryRun: UnknownException: $e');
      return Failure(_handleUnknownException(e));
    }
  }

  /// Run the operation and catch any exceptions.
  ///
  /// If an exception is caught, it will be handled and rethrown as a [CustomException].
  Future<Result<T, CustomException>> tryRunAsync<T>(
    Future<T> Function() operation,
  ) async {
    try {
      return Success(await operation());
    } on CustomException catch (e) {
      logger.e('tryRunAsync: CustomException: $e');
      return Failure(e);
    } catch (e) {
      logger.e('tryRunAsync: UnknownException: $e');
      return Failure(_handleUnknownException(e));
    }
  }

  /// A helper function to convert an object to a [CustomException].
  ///
  /// This is useful when you want to catch an exception where the type could not be inferred.
  ///
  /// For example, when catching an exception from stream using `onError` where the type is `Object`.
  /// ```dart
  /// stream.listen(
  ///   (data) {},
  ///   onError: (Object e) {
  ///     final exception = exceptionFromObject(e);
  ///     // Handle the exception...
  ///   },
  /// );
  /// ```
  CustomException exceptionFromObject(dynamic object) {
    logger.i('exceptionFromObject: object: $object (${object.runtimeType})');

    if (object is CustomException) return object;

    return UnknownException(message: '$object');
  }

  CustomException _handleUnknownException(dynamic e) =>
      UnknownException(message: '$e');
}
