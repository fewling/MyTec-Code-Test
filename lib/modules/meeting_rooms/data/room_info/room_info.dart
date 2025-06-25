import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_info.freezed.dart';
part 'room_info.g.dart';

@freezed
sealed class RoomInfo with _$RoomInfo {
  const factory RoomInfo({
    required String centreCode,
    required String roomCode,
    required String roomName,
    required String floor,
    required int capacity,
    required bool hasVideoConference,
    @Default(<String>[]) List<String> amenities,
    @Default(<String>[]) List<String> photoUrls,
    required bool isBookable,
    required bool isFromNewObs,
    required bool isClosed,
    required bool isInternal,
    @Default(<RoomTerm>[]) List<RoomTerm> terms,
  }) = _RoomInfo;

  factory RoomInfo.fromJson(Map<String, dynamic> json) =>
      _$RoomInfoFromJson(json);
}

@freezed
sealed class RoomTerm with _$RoomTerm {
  const factory RoomTerm({
    required String languageCode,
    required String value,
  }) = _RoomTerm;

  factory RoomTerm.fromJson(Map<String, dynamic> json) =>
      _$RoomTermFromJson(json);
}
