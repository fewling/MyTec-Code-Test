import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/constants/constants.dart';
import '../../../../widgets/custom_exception_text.dart';
import '../../../../widgets/loading_widget.dart';
import '../../data/city.dart';
import 'city_pool_bloc.dart';
import 'select_city_form.dart';

class SelectCityButton extends StatelessWidget {
  const SelectCityButton({super.key});

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;

    final status = context.select((CityPoolBloc b) => b.state.status);

    return switch (status) {
      RequestStatus.initial => const SizedBox(),
      RequestStatus.loading => const LoadingWidget(),
      RequestStatus.error => IconButton(
        icon: const Icon(Icons.error_outline_rounded),
        onPressed: () => _onErrorPressed(context),
      ),
      RequestStatus.loaded => TextButton.icon(
        iconAlignment: IconAlignment.end,
        icon: Transform.rotate(
          angle: -pi / 8,
          child: const Icon(Icons.send_rounded),
        ),
        label: BlocSelector<CityPoolBloc, CityPoolState, City?>(
          selector: (state) => state.selectedCity,
          builder: (context, selectedCity) => Text(switch (selectedCity) {
            null => 'Select City',
            City() => selectedCity.name,
          }, style: txtTheme.titleLarge),
        ),
        onPressed: () => _onPressed(context),
      ),
    };
  }

  Future<dynamic> _onErrorPressed(BuildContext context) {
    final exception = context.read<CityPoolBloc>().state.exception;

    return showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Error'),
        content: CustomExceptionText(exception: exception),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CityPoolBloc>().add(
                const CityPoolEvent.retryRequested(),
              );
              Navigator.of(dialogCtx).pop();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _onPressed(BuildContext context) {
    final selectedCity = context.read<CityPoolBloc>().state.selectedCity;

    showDialog(
      context: context,
      builder: (dialogCtx) => BlocProvider.value(
        value: context.read<CityPoolBloc>(),
        child: SelectCityForm(
          initialSelection: selectedCity,
          onCitySelected: (city) {
            context.read<CityPoolBloc>().add(CityPoolEvent.citySelected(city));
            Navigator.of(dialogCtx).pop();
          },
        ),
      ),
    );
  }
}
