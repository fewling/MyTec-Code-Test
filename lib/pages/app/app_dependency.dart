import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configs/routes/app_router.dart';
import '../../modules/auth/repos/local_authentication_repo.dart';
import '../../modules/auth/repos/remote_authentication_repo.dart';
import '../../modules/auth/services/authentication_service.dart';
import '../../modules/auth/views/authentication/authentication_bloc.dart';
import '../../modules/centre_groups/repos/remote_centre_group_repo.dart';
import '../../modules/centre_groups/services/centre_group_service.dart';
import '../../modules/centre_groups/views/centre_pool/centre_pool_bloc.dart';
import '../../modules/cities/repos/remote_city_repo.dart';
import '../../modules/cities/services/city_service.dart';
import '../../modules/cities/views/city_pool/city_pool_bloc.dart';
import '../../modules/meeting_rooms/repos/remote_meeting_room_repo.dart';
import '../../modules/meeting_rooms/services/meeting_room_service.dart';
import '../../modules/meeting_rooms/views/room_pool/room_pool_bloc.dart';

class AppDependency extends StatefulWidget {
  const AppDependency({super.key, required this.builder});

  final Widget Function(BuildContext context, AppRouter appRouter) builder;

  @override
  State<AppDependency> createState() => _AppDependencyState();
}

class _AppDependencyState extends State<AppDependency> {
  late final AppRouter _appRouter;

  late final LocalAuthenticationRepo _localAuthenticationRepo;
  late final RemoteAuthenticationRepo _remoteAuthenticationRepo;
  late final AuthenticationService _authenticationService;
  late final AuthenticationBloc _authenticationBloc;

  late final RemoteCityRepo _remoteCityRepo;
  late final CityService _cityService;
  late final CityPoolBloc _cityPoolBloc;

  late final RemoteCentreGroupRepo _remoteCentreGroupRepo;
  late final CentreGroupService _centreGroupService;
  late final CentrePoolBloc _centrePoolBloc;

  late final RemoteMeetingRoomRepo _remoteMeetingRoomRepo;
  late final MeetingRoomService _meetingRoomService;
  late final RoomPoolBloc _roomPoolBloc;

  @override
  void initState() {
    super.initState();

    // Global-level Repo initialization
    _localAuthenticationRepo = LocalAuthenticationRepo();
    _remoteAuthenticationRepo = RemoteAuthenticationRepo();
    _remoteCityRepo = RemoteCityRepo();
    _remoteCentreGroupRepo = RemoteCentreGroupRepo();
    _remoteMeetingRoomRepo = RemoteMeetingRoomRepo();

    // Global-level Service initialization
    _authenticationService = AuthenticationService(
      remoteAuthenticationRepo: _remoteAuthenticationRepo,
      localAuthenticationRepo: _localAuthenticationRepo,
    );
    _cityService = CityService(remoteCityRepo: _remoteCityRepo);
    _centreGroupService = CentreGroupService(
      remoteCentreGroupRepo: _remoteCentreGroupRepo,
    );
    _meetingRoomService = MeetingRoomService(
      remoteMeetingRoomRepo: _remoteMeetingRoomRepo,
    );

    // Global-level Bloc initialization
    _authenticationBloc = AuthenticationBloc(
      authenticationService: _authenticationService,
    )..add(const AuthenticationEvent.started());

    _cityPoolBloc = CityPoolBloc(cityService: _cityService)
      ..add(const CityPoolEvent.started());

    _centrePoolBloc = CentrePoolBloc(centreGroupService: _centreGroupService)
      ..add(const CentrePoolEvent.started());

    _roomPoolBloc = RoomPoolBloc(meetingRoomService: _meetingRoomService)
      ..add(const RoomPoolEvent.started());

    _appRouter = AppRouter(
      authenticationBloc: _authenticationBloc,
      cityPoolBloc: _cityPoolBloc,
      centrePoolBloc: _centrePoolBloc,
      roomPoolBloc: _roomPoolBloc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _localAuthenticationRepo),
        RepositoryProvider.value(value: _remoteAuthenticationRepo),
        RepositoryProvider.value(value: _remoteCityRepo),
        RepositoryProvider.value(value: _remoteCentreGroupRepo),
        RepositoryProvider.value(value: _remoteMeetingRoomRepo),

        RepositoryProvider.value(value: _authenticationService),
        RepositoryProvider.value(value: _cityService),
        RepositoryProvider.value(value: _centreGroupService),
        RepositoryProvider.value(value: _meetingRoomService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authenticationBloc),
          BlocProvider.value(value: _cityPoolBloc),
          BlocProvider.value(value: _centrePoolBloc),
          BlocProvider.value(value: _roomPoolBloc),
        ],
        child: widget.builder(context, _appRouter),
      ),
    );
  }
}
