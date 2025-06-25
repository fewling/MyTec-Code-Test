import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/constants/constants.dart';
import '../../../utils/serialization/serialization.dart';

part 'centre_group.freezed.dart';
part 'centre_group.g.dart';

@freezed
sealed class CentreGroup with _$CentreGroup {
  const factory CentreGroup({
    required String id,
    required String country,
    required String cityCode,

    @JsonKey(name: 'newCentreCodesForMtCore') required List<String> centreCodes,

    @JsonKey(
      name: 'localizedName',
      fromJson: regionMapFromJson,
      toJson: regionMapToJson,
    )
    @Default(<RegionCode, String>{})
    Map<RegionCode, String> name,

    @JsonKey(fromJson: regionMapFromJson, toJson: regionMapToJson)
    @Default(<RegionCode, String>{})
    Map<RegionCode, String> displayAddressWithLevel,

    // many fields are omitted for brevity...
  }) = _CentreGroup;

  factory CentreGroup.fromJson(Map<String, dynamic> json) =>
      _$CentreGroupFromJson(json);
}
