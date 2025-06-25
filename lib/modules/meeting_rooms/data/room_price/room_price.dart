import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_price.freezed.dart';
part 'room_price.g.dart';

@freezed
sealed class RoomPrice with _$RoomPrice {
  const factory RoomPrice({
    required String roomCode,
    required String bestPricingStrategyName,
    required num initialPrice,
    required num finalPrice,
    required String currencyCode,
    required bool isPackageApplicable,
  }) = _RoomPrice;

  factory RoomPrice.fromJson(Map<String, dynamic> json) =>
      _$RoomPriceFromJson(json);
}
