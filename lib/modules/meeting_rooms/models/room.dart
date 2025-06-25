import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/room_availability/room_availability.dart';
import '../data/room_info/room_info.dart';
import '../data/room_price/room_price.dart';

part 'room.freezed.dart';

@freezed
sealed class Room with _$Room {
  const factory Room({
    required RoomInfo info,
    required RoomAvailability availability,
    required RoomPrice price,
  }) = _Room;
}
