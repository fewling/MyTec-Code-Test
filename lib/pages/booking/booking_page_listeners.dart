import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/centre_groups/data/centre_group.dart';
import '../../modules/centre_groups/views/centre_pool/centre_pool_bloc.dart';
import '../../modules/cities/views/city_pool/city_pool_bloc.dart';
import '../../modules/meeting_rooms/models/room.dart';
import '../../modules/meeting_rooms/views/available_rooms/available_rooms_bloc.dart';
import '../../modules/meeting_rooms/views/filter_result/filter_result_bloc.dart';
import '../../modules/meeting_rooms/views/room_filter/room_filter_bloc.dart';
import '../../modules/meeting_rooms/views/room_pool/room_pool_bloc.dart';
import '../../modules/meeting_rooms/views/room_price/room_price_bloc.dart';
import '../../utils/logging/logger.dart';

class BookingPageListeners extends StatelessWidget {
  const BookingPageListeners({super.key, required this.builder});

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // When city is changed, reset the room filters
        BlocListener<CityPoolBloc, CityPoolState>(
          listenWhen: (previous, current) =>
              previous.selectedCity != current.selectedCity &&
              current.selectedCity != null,
          listener: (context, state) {
            final city = context.read<CityPoolBloc>().state.selectedCity;
            final centres = context.read<CentrePoolBloc>().state.centresByCity;

            if (city != null) {
              context.read<RoomFilterBloc>().add(
                RoomFilterEvent.started(
                  initialState: context.read<RoomFilterBloc>().state.copyWith(
                    selectedCentres: Set.from(centres[city.code] ?? []),
                  ),
                ),
              );
            }
          },
        ),

        // when city is changed, get new available rooms
        BlocListener<CityPoolBloc, CityPoolState>(
          listenWhen: (previous, current) =>
              previous.selectedCity != current.selectedCity &&
              current.selectedCity != null,
          listener: (context, state) => _requestAvailableRooms(context),
        ),

        // when filters are changed, get new available rooms
        BlocListener<RoomFilterBloc, RoomFilterState>(
          listener: (context, state) => _requestAvailableRooms(context),
        ),

        // when filters are changed, get new prices
        BlocListener<RoomFilterBloc, RoomFilterState>(
          listener: (context, state) => _requestPrices(context),
        ),

        // when available rooms updated, sort and group them with centre info
        BlocListener<AvailableRoomsBloc, AvailableRoomsState>(
          listenWhen: (previous, current) =>
              previous.status != current.status && current.status.isLoaded,
          listener: (context, state) => _sortFilterResult(context),
        ),

        // when available rooms updated, sort and group them with centre info
        BlocListener<RoomPriceBloc, RoomPriceState>(
          listenWhen: (previous, current) =>
              previous.status != current.status && current.status.isLoaded,
          listener: (context, state) => _sortFilterResult(context),
        ),
      ],
      child: Builder(builder: (context) => builder(context)),
    );
  }

  void _requestAvailableRooms(BuildContext context) {
    final city = context.read<CityPoolBloc>().state.selectedCity;
    if (city == null) return;

    final filterState = context.read<RoomFilterBloc>().state;
    context.read<AvailableRoomsBloc>().add(
      AvailableRoomsEvent.requested(
        cityCode: city.code,
        date: filterState.date,
        startTime: filterState.startTime,
        endTime: filterState.endTime,
      ),
    );
  }

  void _requestPrices(BuildContext context) {
    final city = context.read<CityPoolBloc>().state.selectedCity;
    if (city == null) return;

    final filterState = context.read<RoomFilterBloc>().state;
    context.read<RoomPriceBloc>().add(
      RoomPriceEvent.requested(
        cityCode: city.code,
        date: filterState.date,
        startTime: filterState.startTime,
        endTime: filterState.endTime,
        isVcBooking: filterState.needVideoConference,
      ),
    );
  }

  void _sortFilterResult(BuildContext context) {
    final centres = context.read<CentrePoolBloc>().state.allCentres;
    final allRooms = context.read<RoomPoolBloc>().state.allRooms;
    final available = context.read<AvailableRoomsBloc>().state.availableRooms;
    final prices = context.read<RoomPriceBloc>().state.prices;

    final filterState = context.read<RoomFilterBloc>().state;
    final selectedCentres = filterState.selectedCentres;
    final needVideoConference = filterState.needVideoConference;
    final capacity = filterState.capacity;

    final sortedRooms = <CentreGroup, List<Room>>{};
    for (final ava in available) {
      final info = allRooms[ava.roomCode];
      if (info == null) continue;

      final centre = centres[info.centreCode];
      if (centre == null) continue;

      if (!selectedCentres.contains(centre)) continue;
      if (needVideoConference && !info.hasVideoConference) continue;
      if (info.capacity != capacity) continue;

      final price = prices[ava.roomCode];
      if (price == null) continue;

      sortedRooms
          .putIfAbsent(centre, () => [])
          .add(Room(info: info, availability: ava, price: price));
    }

    logger.i(
      'Sorted rooms: ${sortedRooms.length} centres, '
      '${sortedRooms.values.fold(0, (sum, list) => sum + list.length)} rooms',
    );

    context.read<FilterResultBloc>().add(
      FilterResultEvent.sorted(sortedRooms: sortedRooms),
    );
  }
}
