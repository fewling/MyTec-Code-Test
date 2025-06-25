part of 'extensions.dart';

extension NumX on num {
  String toCurrency({int decimalPlaces = 2}) {
    final format = NumberFormat.currency(
      decimalDigits: decimalPlaces,
      symbol: '',
    );
    return format.format(this);
  }
}
