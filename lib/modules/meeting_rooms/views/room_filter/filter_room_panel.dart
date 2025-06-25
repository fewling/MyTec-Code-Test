import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/constants/constants.dart';
import '../../../../utils/extensions/extensions.dart';
import '../../../centre_groups/data/centre_group.dart';
import '../../../centre_groups/views/centre_pool/centre_pool_bloc.dart';
import '../../../cities/views/city_pool/city_pool_bloc.dart';
import 'filter_room_form.dart';
import 'room_filter_bloc.dart';

class FilterRoomPanel extends StatelessWidget {
  const FilterRoomPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          _PanelChip(
            label: HardcodedLabels.filterChip.label,
            avatar: Image.asset(Assets.icons.icFilter.path),
            onPressed: () => _showFilterDialog(context),
            labelStyle: txtTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          BlocSelector<RoomFilterBloc, RoomFilterState, DateTime>(
            selector: (state) => state.date,
            builder: (context, date) => _PanelChip(
              label: date.isToday
                  ? HardcodedLabels.datePickerChip.label
                  : date.asYYYYMMDD,
              avatar: Icon(
                Icons.calendar_today_rounded,
                color: colorScheme.outline,
              ),
              onPressed: () => _showFilterDialog(context),
            ),
          ),

          BlocSelector<RoomFilterBloc, RoomFilterState, (TimeOfDay, TimeOfDay)>(
            selector: (state) => (state.startTime, state.endTime),
            builder: (context, times) => _PanelChip(
              label: '${times.$1.as12Hr} - ${times.$2.as12Hr}',
              avatar: Image.asset(Assets.icons.icClock.path),
              onPressed: () => _showFilterDialog(context),
            ),
          ),

          BlocSelector<RoomFilterBloc, RoomFilterState, int>(
            selector: (state) => state.capacity,
            builder: (context, capacity) => _PanelChip(
              label: '$capacity ${HardcodedLabels.seatPickerChip.label}',
              avatar: Image.asset(Assets.icons.icGroup.path),
              onPressed: () => _showFilterDialog(context),
            ),
          ),

          BlocSelector<RoomFilterBloc, RoomFilterState, Set<CentreGroup>>(
            selector: (state) => state.selectedCentres,
            builder: (context, selectedCentres) {
              final selectedCity = context.select(
                (CityPoolBloc b) => b.state.selectedCity,
              );

              final centres = context.select(
                (CentrePoolBloc b) =>
                    b.state.centresByCity[selectedCity?.code] ?? [],
              );

              final isAllSelected = selectedCentres.length == centres.length;

              return _PanelChip(
                label: isAllSelected
                    ? '${HardcodedLabels.alLCentresSelected.label} in ${selectedCity?.name ?? '...'}'
                    : selectedCentres.length > 1
                    ? '${selectedCentres.length} ${HardcodedLabels.multipleCentresSelected.label}'
                    : selectedCentres.isNotEmpty
                    ? selectedCentres.first.name[RegionCode.en] ?? '???'
                    : 'Select Centres',
                avatar: Image.asset(Assets.icons.icBuilding.path),
                onPressed: () => _showFilterDialog(context),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) => showModalBottomSheet(
    context: context,
    clipBehavior: Clip.antiAlias,
    builder: (dialogCtx) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<CityPoolBloc>()),
        BlocProvider.value(value: context.read<CentrePoolBloc>()),
        BlocProvider.value(value: context.read<RoomFilterBloc>()),
      ],
      child: FilterRoomForm(
        onFilterApplied: (state) {
          context.read<RoomFilterBloc>().add(
            RoomFilterEvent.started(initialState: state),
          );
          Navigator.pop(dialogCtx);
        },
      ),
    ),
  );
}

class _PanelChip extends StatelessWidget {
  const _PanelChip({
    required this.label,
    required this.avatar,
    this.onPressed,
    this.labelStyle,
  });

  final String label;
  final Widget avatar;
  final void Function()? onPressed;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;

    return ActionChip(
      label: Text(label, style: labelStyle ?? txtTheme.labelMedium),
      avatar: avatar,
      shape: const StadiumBorder(),
      onPressed: onPressed,
    );
  }
}
