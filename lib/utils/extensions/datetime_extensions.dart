part of 'extensions.dart';

extension DateTimeX on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isSameMomentAs(DateTime other) =>
      year == other.year &&
      month == other.month &&
      day == other.day &&
      hour == other.hour &&
      minute == other.minute;

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  DateTime toMinuteInterval({Duration interval = const Duration(minutes: 15)}) {
    final minutes = (minute ~/ interval.inMinutes) * interval.inMinutes;
    return DateTime(year, month, day, hour, minutes);
  }

  DateTime changeDateTo(DateTime other) =>
      DateTime(other.year, other.month, other.day, hour, minute);

  DateTime fromTimeOfDay(TimeOfDay timeOfDay) =>
      DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);

  String get asDDMMYYYY =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';

  String get asYYYYMMDD =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);
}
