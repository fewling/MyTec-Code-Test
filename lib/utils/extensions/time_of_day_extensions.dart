part of 'extensions.dart';

extension TimeOfDayX on TimeOfDay {
  String get as24Hr {
    final hour24 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hour24:$minuteStr ${hour < 12 ? 'AM' : 'PM'}';
  }

  String get as12Hr {
    final hour24 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hour24:$minuteStr ${hour < 12 ? 'AM' : 'PM'}';
  }

  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  int differenceInMinutes(TimeOfDay other) {
    final thisInMinutes = hour * 60 + minute;
    final otherInMinutes = other.hour * 60 + other.minute;
    return thisInMinutes - otherInMinutes;
  }
}
