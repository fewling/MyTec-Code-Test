import 'dart:convert';

import '../constants/constants.dart';

Map<RegionCode, String> regionMapFromJson(Map<String, dynamic> json) =>
    json.map(
      (key, value) => MapEntry(
        RegionCode.values.firstWhere(
          (code) => code.toString() == 'RegionCode.$key',
          orElse: () => RegionCode.unknown,
        ),
        '$value',
      ),
    );

String regionMapToJson(Map<RegionCode, String> map) =>
    jsonEncode(map.map((key, value) => MapEntry(key.name, value)));
