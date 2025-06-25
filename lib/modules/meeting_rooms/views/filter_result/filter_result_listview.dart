import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../utils/extensions/extensions.dart';
import '../../../../widgets/custom_exception_text.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../centre_groups/data/centre_group.dart';
import '../../../cities/views/city_pool/city_pool_bloc.dart';
import '../../models/room.dart';
import '../available_rooms/available_rooms_bloc.dart';
import '../room_filter/room_filter_bloc.dart';
import '../room_price/room_price_bloc.dart';
import 'filter_result_bloc.dart';

class FilterResultListView extends StatelessWidget {
  const FilterResultListView({super.key});

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;

    return BlocSelector<AvailableRoomsBloc, AvailableRoomsState, RequestStatus>(
      selector: (state) => state.status,
      builder: (context, status) => switch (status) {
        RequestStatus.initial => const Center(
          child: Text('Please select a date and time to see available rooms.'),
        ),
        RequestStatus.loading => const LoadingWidget(),
        RequestStatus.error => CustomExceptionText(
          exception: context.select(
            (AvailableRoomsBloc bloc) => bloc.state.exception,
          ),
        ),
        RequestStatus.loaded =>
          BlocBuilder<FilterResultBloc, FilterResultState>(
            builder: (context, state) => state.rooms.isEmpty
                ? Center(child: Text(HardcodedLabels.noRoomsFound.label))
                : RefreshIndicator(
                    onRefresh: () => _onRefresh(context),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.rooms.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16.0),
                      itemBuilder: (context, index) {
                        final centreGroup = state.rooms.keys.elementAt(index);
                        final rooms = state.rooms[centreGroup] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(
                              centreGroup.name[RegionCode.en] ?? '???',
                              style: txtTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            for (final room in rooms)
                              RoomCard(room: room, centre: centreGroup),
                          ],
                        );
                      },
                    ),
                  ),
          ),
      },
    );
  }

  Future<void> _onRefresh(BuildContext context) {
    final city = context.read<CityPoolBloc>().state.selectedCity;
    if (city == null) return Future.value();

    final filterState = context.read<RoomFilterBloc>().state;

    context.read<AvailableRoomsBloc>().add(
      AvailableRoomsEvent.requested(
        cityCode: city.code,
        date: filterState.date,
        startTime: filterState.startTime,
        endTime: filterState.endTime,
      ),
    );
    context.read<RoomPriceBloc>().add(
      RoomPriceEvent.requested(
        cityCode: city.code,
        date: filterState.date,
        startTime: filterState.startTime,
        endTime: filterState.endTime,
        isVcBooking: filterState.needVideoConference,
      ),
    );
    return Future.value();
  }
}

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room, required this.centre});

  final CentreGroup centre;
  final Room room;

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final info = room.info;
    final url = info.photoUrls.firstOrNull;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (url != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                            ? child.animate().fadeIn()
                            : LoadingWidget(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                    : null,
                                showNumber: false,
                              ),
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                      ),
                    ),
                  )
                else
                  const Placeholder(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${HardcodedLabels.floorIndicator.label}${info.floor}, ${info.roomName}',
                        style: txtTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),

                      Text(
                        '${centre.name[RegionCode.en]}',
                        style: txtTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),

                      Text(
                        '${info.capacity} ${HardcodedLabels.seatPickerChip.label}',
                        style: txtTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (!room.availability.isAvailable)
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                elevation: 2,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    HardcodedLabels.roomUnavailable.label,
                    style: txtTheme.labelLarge?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(),
                ),
              ),
            ),

          Positioned(
            bottom: 16,
            right: 16,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${room.price.currencyCode} ',
                    style: txtTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: room.price.finalPrice.toCurrency(),
                    style: txtTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: HardcodedLabels.pricePerHour.label,
                    style: txtTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
