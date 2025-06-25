import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../utils/logging/logger.dart';
import '../../data/city.dart';
import 'city_pool_bloc.dart';

class SelectCityForm extends StatefulWidget {
  const SelectCityForm({
    super.key,
    this.initialSelection,
    required this.onCitySelected,
  });

  final City? initialSelection;
  final void Function(City? city) onCitySelected;

  @override
  State<SelectCityForm> createState() => _SelectCityFormState();
}

class _SelectCityFormState extends State<SelectCityForm> {
  late final TextEditingController _cityController;

  late City? _selectedCity;

  var _isCityListVisible = false;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
    _selectedCity = widget.initialSelection;

    logger.d('Initial selected city: ${_selectedCity?.name ?? 'None'}');

    _cityController.text = _selectedCity?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final citiesByRegion = context.select(
      (CityPoolBloc b) => b.state.citiesByRegion,
    );

    return Portal(
      child: GestureDetector(
        onTap: () => setState(() => _isCityListVisible = false),
        child: AlertDialog(
          icon: const Text('Location'),
          title: const Text('Please select your city'),
          content: SizedBox(
            width: double.maxFinite,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: DropdownButton(
                    //     value: _selectedCity,
                    //     items: widget.cities
                    //         .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                    //         .toList(),
                    //     onChanged: (city) => setState(() => _selectedCity = city),
                    //   ),
                    // ),
                    SizedBox(
                      width: double.infinity,
                      child: PortalTarget(
                        visible: _isCityListVisible,
                        anchor: const Aligned(
                          follower: Alignment.topCenter,
                          target: Alignment.bottomCenter,
                        ),
                        portalFollower: _CityList(
                          width: constraints.maxWidth,
                          citiesByRegion: citiesByRegion,
                          selectedCity: _selectedCity,
                          onCitySelected: (city) => setState(() {
                            _selectedCity = city;
                            _isCityListVisible = false;
                            _cityController.text = city?.name ?? '';
                          }),
                        ),
                        child: TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          readOnly: true,
                          onTap: () => setState(
                            () => _isCityListVisible = !_isCityListVisible,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        iconAlignment: IconAlignment.end,
                        label: const Text('Select Nearest City'),
                        icon: Transform.rotate(
                          angle: -pi / 8,
                          child: const Icon(Icons.send_rounded),
                        ),
                        onPressed: null,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => widget.onCitySelected(_selectedCity),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CityList extends StatelessWidget {
  const _CityList({
    required this.width,
    required this.citiesByRegion,
    required this.selectedCity,
    required this.onCitySelected,
  });

  final double width;
  final Map<String, List<City>> citiesByRegion;
  final void Function(City? city) onCitySelected;
  final City? selectedCity;

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        itemCount: citiesByRegion.keys.length,
        itemBuilder: (context, index) {
          final regionId = citiesByRegion.keys.elementAt(index);
          final cities = citiesByRegion[regionId] ?? [];

          if (cities.isEmpty) return const SizedBox.shrink();

          return Material(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      cities.first.region.name[RegionCode.en] ?? 'N/A',
                      style: txtTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                for (final city in cities)
                  Material(
                    child: InkWell(
                      onTap: () => onCitySelected(city),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            city.name,
                            style: txtTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
