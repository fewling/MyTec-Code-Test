import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../utils/extensions/extensions.dart';
import '../../../../widgets/cupertino_modal_container.dart';
import '../../../centre_groups/views/centre_pool/centre_pool_bloc.dart';
import '../../../cities/views/city_pool/city_pool_bloc.dart';
import 'room_filter_bloc.dart';

class FilterRoomForm extends StatefulWidget {
  const FilterRoomForm({super.key, required this.onFilterApplied});

  final void Function(RoomFilterState state) onFilterApplied;

  @override
  State<FilterRoomForm> createState() => _FilterRoomFormState();
}

class _FilterRoomFormState extends State<FilterRoomForm> {
  var _isCentresVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TempRoomFilterBloc()
        ..add(
          RoomFilterEvent.started(
            initialState: context.read<RoomFilterBloc>().state,
          ),
        ),
      child: BlocBuilder<TempRoomFilterBloc, RoomFilterState>(
        builder: (context, state) => Portal(
          child: GestureDetector(
            onTap: () => setState(() => _isCentresVisible = false),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => context.read<TempRoomFilterBloc>().add(
                      const RoomFilterEvent.reset(),
                    ),
                    child: const Text('Reset'),
                  ),

                  const Divider(height: 1, thickness: 1),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 8,
                      children: [
                        _OptionTile(
                          title: HardcodedLabels.filterDateTitle.label,
                          value: state.date.asDDMMYYYY,
                          trailing: const Icon(Icons.calendar_today_rounded),
                          onTap: () => _pickDate(context: context),
                        ),

                        _OptionTile(
                          title: HardcodedLabels.filterStartTimeTitle.label,
                          value: state.startTime.as12Hr,
                          trailing: const Icon(Icons.calendar_today_rounded),
                          onTap: () => _pickTime(
                            context: context,
                            initialTime: state.startTime.toDateTime(),
                            onTimePicked: (value) => context
                                .read<TempRoomFilterBloc>()
                                .add(RoomFilterEvent.startTimePicked(value)),
                          ),
                        ),

                        _OptionTile(
                          title: HardcodedLabels.filterEndTimeTitle.label,
                          value: state.endTime.as12Hr,
                          trailing: const Icon(Icons.calendar_today_rounded),
                          onTap: () => _pickTime(
                            context: context,
                            initialTime: state.endTime.toDateTime(),
                            onTimePicked: (value) => context
                                .read<TempRoomFilterBloc>()
                                .add(RoomFilterEvent.endTimePicked(value)),
                          ),
                        ),

                        const SizedBox(height: 120, child: Placeholder()),

                        _OptionTile(
                          title: HardcodedLabels.filterCapacityTitle.label,
                          value: '${state.capacity}',
                          trailing: const Icon(Icons.people_alt_rounded),
                          onTap: () => _pickNumber(
                            context: context,
                            initialValue: state.capacity,
                            onNumberPicked: (value) => context
                                .read<TempRoomFilterBloc>()
                                .add(RoomFilterEvent.capacityPicked(value)),
                          ),
                        ),

                        _CentreTile(
                          isOpened: _isCentresVisible,
                          onTap: () => setState(
                            () => _isCentresVisible = !_isCentresVisible,
                          ),
                        ),

                        const SizedBox(height: 32, child: Placeholder()),

                        _OptionTile(
                          title:
                              HardcodedLabels.filterVideoConferenceTitle.label,
                          valueBuilder: () => Align(
                            alignment: Alignment.centerRight,
                            child: Switch(
                              value: state.needVideoConference,
                              onChanged: (value) =>
                                  context.read<TempRoomFilterBloc>().add(
                                    RoomFilterEvent.videoConferenceToggled(
                                      value,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                        onPressed: () => widget.onFilterApplied(
                          context.read<TempRoomFilterBloc>().state,
                        ),
                        child: const Text('Apply'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate({required BuildContext context}) async {
    final filterBloc = context.read<TempRoomFilterBloc>();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;

    filterBloc.add(RoomFilterEvent.datePicked(picked));
  }

  void _pickTime({
    required BuildContext context,
    required Function(DateTime value) onTimePicked,
    DateTime? initialTime,
  }) {
    final txtTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    var pickedTime = initialTime;

    showCupertinoModalPopup(
      context: context,
      builder: (modalCtx) => CupertinoModalContainer(
        child: Column(
          spacing: 8,
          children: [
            Text(
              'Start Time',
              style: txtTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: CupertinoColors.systemGrey4.resolveFrom(modalCtx),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: initialTime,
                minuteInterval: 15,
                onDateTimeChanged: (value) => pickedTime = value,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (pickedTime != null) onTimePicked(pickedTime!);
                  Navigator.of(modalCtx).pop();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickNumber({
    required BuildContext context,
    required Function(int value) onNumberPicked,
    int? initialValue,
  }) {
    var pickedNumber = initialValue ?? 4;

    final controller = FixedExtentScrollController(
      initialItem: pickedNumber - 1, // Adjust for 0-based index
    );

    showCupertinoModalPopup(
      context: context,
      builder: (modalCtx) => CupertinoModalContainer(
        child: Column(
          spacing: 8,
          children: [
            Text(
              'Select Capacity',
              style: Theme.of(modalCtx).textTheme.titleSmall?.copyWith(
                color: Theme.of(modalCtx).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: CupertinoColors.systemGrey4.resolveFrom(modalCtx),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: controller,
                itemExtent: 32.0,
                onSelectedItemChanged: (index) => pickedNumber = index + 1,
                looping: true,
                children: List.generate(
                  100,
                  (index) => Center(child: Text('${index + 1}')),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  onNumberPicked(pickedNumber);
                  Navigator.of(modalCtx).pop();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    ).then((_) => controller.dispose());
  }
}

class _OptionTile extends StatefulWidget {
  const _OptionTile({
    required this.title,
    this.value,
    this.valueBuilder,
    this.onTap,
    this.trailing,
  });

  final String title;
  final String? value;
  final Widget Function()? valueBuilder;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  State<_OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<_OptionTile> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _OptionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.value != null || widget.valueBuilder != null,
      'Either value or valueBuilder must be provided',
    );

    final txtTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(child: Text(widget.title)),
        Expanded(
          child:
              widget.valueBuilder?.call() ??
              Material(
                elevation: 1,
                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: widget.onTap,
                  child: TextFormField(
                    controller: _controller,
                    enabled: false,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      suffixIcon: widget.trailing,
                    ),
                    readOnly: true,
                    showCursor: false,
                    style: txtTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
        ),
      ],
    );
  }
}

class _CentreTile extends StatefulWidget {
  const _CentreTile({required this.isOpened, required this.onTap});

  final bool isOpened;
  final void Function() onTap;

  @override
  State<_CentreTile> createState() => _CentreTileState();
}

class _CentreTileState extends State<_CentreTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(HardcodedLabels.filterCentreTitle.label)),
        Expanded(
          child: Material(
            elevation: 1,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) => PortalTarget(
                visible: widget.isOpened,
                anchor: const Aligned(
                  follower: Alignment.bottomCenter,
                  target: Alignment.topCenter,
                  portal: Alignment.bottomCenter,
                ),
                portalFollower: _CentreDropdownList(
                  width: constraints.maxWidth,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      if (widget.isOpened)
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.shadow.withAlpha((0.1 * 255).round()),
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: _CentreDropdownTrigger(
                    onTap: widget.onTap,
                    borderRadius: widget.isOpened
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          )
                        : BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CentreDropdownTrigger extends StatelessWidget {
  const _CentreDropdownTrigger({required this.onTap, this.borderRadius});

  final BorderRadius? borderRadius;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final txyStyle = txtTheme.labelLarge?.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    final selectedCity = context.select(
      (CityPoolBloc b) => b.state.selectedCity,
    );

    final centres = context.select(
      (CentrePoolBloc b) => b.state.centresByCity[selectedCity?.code] ?? [],
    );

    final selectedCentres = context.select(
      (TempRoomFilterBloc b) => b.state.selectedCentres,
    );

    final isAllSelected = selectedCentres.length == centres.length;

    return Container(
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
      ),
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              isAllSelected
                  ? HardcodedLabels.filterCentreSelection.label
                        .replaceFirst(
                          '{0}',
                          HardcodedLabels.alLCentresSelected.label,
                        )
                        .replaceFirst('{1}', selectedCity?.name ?? '...')
                  : selectedCentres.length > 1
                  ? '${selectedCentres.length} ${HardcodedLabels.multipleCentresSelected.label}'
                  : selectedCentres.isNotEmpty
                  ? selectedCentres.first.name[RegionCode.en] ?? '???'
                  : HardcodedLabels.filterCentreSelectPrompt.label,
              style: txyStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

class _CentreDropdownList extends StatelessWidget {
  const _CentreDropdownList({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final selectedCity = context.select(
      (CityPoolBloc b) => b.state.selectedCity,
    );

    final centres =
        context.select(
          (CentrePoolBloc b) => b.state.centresByCity[selectedCity?.code],
        ) ??
        const [];

    final selectedCentres = context.select(
      (TempRoomFilterBloc b) => b.state.selectedCentres,
    );

    return Container(
      width: width,
      constraints: const BoxConstraints(maxHeight: 300),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.1 * 255).round()),
            blurRadius: 2.0,
            spreadRadius: 2.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ListView.separated(
        itemCount: centres.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, thickness: 1),
        itemBuilder: (context, index) {
          final centre = centres[index];
          final isSelected = selectedCentres.any((e) => e.id == centre.id);

          return Material(
            color: colorScheme.surface,
            child: InkWell(
              onTap: () => context.read<TempRoomFilterBloc>().add(
                RoomFilterEvent.centreSelected(centre),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        centre.name[RegionCode.en] ?? '???',
                        style: txtTheme.labelLarge,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                        size: txtTheme.labelLarge?.fontSize ?? 16.0,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
