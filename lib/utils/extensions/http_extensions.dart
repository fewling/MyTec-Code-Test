part of 'extensions.dart';

extension ResponseX on Response {
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  bool get isFailure => !isSuccess;

  bool get isUnauthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isNotFound => statusCode == 404;

  bool get isServerError => statusCode >= 500 && statusCode < 600;
}
