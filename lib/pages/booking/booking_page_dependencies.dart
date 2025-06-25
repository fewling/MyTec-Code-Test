import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/centre_groups/views/centre_pool/centre_pool_bloc.dart';
import '../../modules/cities/views/city_pool/city_pool_bloc.dart';
import '../../modules/meeting_rooms/services/meeting_room_service.dart';
import '../../modules/meeting_rooms/views/available_rooms/available_rooms_bloc.dart';
import '../../modules/meeting_rooms/views/filter_result/filter_result_bloc.dart';
import '../../modules/meeting_rooms/views/room_filter/room_filter_bloc.dart';
import '../../modules/meeting_rooms/views/room_price/room_price_bloc.dart';

class BookingPageDependencies extends StatelessWidget {
  const BookingPageDependencies({super.key, required this.builder});

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = RoomFilterBloc();

            final city = context.read<CityPoolBloc>().state.selectedCity;
            final centres = context.read<CentrePoolBloc>().state.centresByCity;
            if (city != null) {
              bloc.add(
                RoomFilterEvent.started(
                  initialState: bloc.state.copyWith(
                    selectedCentres: Set.from(centres[city.code] ?? []),
                  ),
                ),
              );
            }
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final bloc = AvailableRoomsBloc(
              meetingRoomService: context.read<MeetingRoomService>(),
            );

            final city = context.read<CityPoolBloc>().state.selectedCity;
            if (city != null) {
              final filterState = context.read<RoomFilterBloc>().state;
              bloc.add(
                AvailableRoomsEvent.requested(
                  date: filterState.date,
                  startTime: filterState.startTime,
                  endTime: filterState.endTime,
                  cityCode: city.code,
                ),
              );
            }
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final bloc = RoomPriceBloc(
              meetingRoomService: context.read<MeetingRoomService>(),
            );

            final city = context.read<CityPoolBloc>().state.selectedCity;
            if (city != null) {
              final filterState = context.read<RoomFilterBloc>().state;
              bloc.add(
                RoomPriceEvent.requested(
                  date: filterState.date,
                  startTime: filterState.startTime,
                  endTime: filterState.endTime,
                  cityCode: city.code,
                  isVcBooking: filterState.needVideoConference,
                ),
              );
            }
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) =>
              FilterResultBloc()..add(const FilterResultEvent.started()),
        ),
      ],
      child: Builder(builder: (context) => builder(context)),
    );
  }
}
