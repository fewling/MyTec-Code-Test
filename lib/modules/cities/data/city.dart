import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../utils/serialization/serialization.dart';

part 'city.freezed.dart';
part 'city.g.dart';

@freezed
sealed class City with _$City {
  const factory City({
    required int cityId,
    required int countryId,
    required String code,
    required String name,
    int? sequence,
    required Region region,

    // many fields are omitted for brevity...
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@freezed
sealed class Region with _$Region {
  const factory Region({
    required String id,

    @JsonKey(fromJson: regionMapFromJson, toJson: regionMapToJson)
    @Default(<RegionCode, String>{})
    Map<RegionCode, String> name,
  }) = _Region;

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
}
