import '../logging/logger.dart';

DateTime dateTimeFromJson(dynamic json) =>
    nullableDateTimeFromJson(json) ??
    (throw ArgumentError('Invalid DateTime value: $json'));

DateTime? nullableDateTimeFromJson(dynamic json) {
  try {
    if (json == null) return null;
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    if (json is String) {
      if (json.isEmpty) return null;
      return DateTime.parse(json);
    }
  } catch (e) {
    logger.e(
      'Error parsing DateTime from JSON: $json\n'
      'Error: $e',
    );
  }

  return null;
}

String dateTimeToJson(DateTime dateTime) =>
    nullableDateTimeToJson(dateTime) ??
    (throw ArgumentError('Invalid DateTime value: $dateTime'));

String? nullableDateTimeToJson(DateTime? dateTime) {
  if (dateTime == null) return null;

  try {
    return dateTime.toIso8601String();
  } catch (e) {
    logger.e(
      'Error converting DateTime to JSON: $dateTime\n'
      'Error: $e',
    );
    return null;
  }
}
