import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/centre_groups/views/centre_pool/centre_pool_bloc.dart';
import '../../modules/cities/views/city_pool/city_pool_bloc.dart';
import '../../modules/meeting_rooms/views/room_pool/room_pool_bloc.dart';
import '../../widgets/breathing.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cityStatus = context.select((CityPoolBloc b) => b.state.status);
    final centresStatus = context.select((CentrePoolBloc b) => b.state.status);
    final roomsStatus = context.select((RoomPoolBloc b) => b.state.status);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            const Breathing(child: FlutterLogo(size: 100)),

            ...[
              ('City', cityStatus),
              ('Centres', centresStatus),
              ('Rooms', roomsStatus),
            ].map((e) => Text('${e.$1} Status: ${e.$2.name}')),

            if ([cityStatus, centresStatus, roomsStatus].any((e) => e.isError))
              TextButton.icon(
                onPressed: () => _retryAll(context),
                label: const Text('Retry'),
                icon: const Icon(Icons.refresh),
              ),
          ],
        ),
      ),
    );
  }

  void _retryAll(BuildContext context) {
    context.read<CityPoolBloc>().add(const CityPoolEvent.retryRequested());
    context.read<CentrePoolBloc>().add(const CentrePoolEvent.retryRequested());
    context.read<RoomPoolBloc>().add(const RoomPoolEvent.retryRequested());
  }
}
