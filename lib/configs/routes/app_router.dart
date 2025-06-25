import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../modules/auth/views/authentication/authentication_bloc.dart';
import '../../modules/centre_groups/views/centre_pool/centre_pool_bloc.dart';
import '../../modules/cities/views/city_pool/city_pool_bloc.dart';
import '../../modules/meeting_rooms/views/room_pool/room_pool_bloc.dart';
import '../../pages/base/base_shell_layout.dart';
import '../../pages/booking/booking_page.dart';
import '../../pages/splash/splash_page.dart';
import '../../utils/constants/constants.dart';

part 'app_route_params.dart';
part 'app_routes.dart';

final class AppRouter {
  AppRouter({
    required AuthenticationBloc authenticationBloc,
    required CityPoolBloc cityPoolBloc,
    required CentrePoolBloc centrePoolBloc,
    required RoomPoolBloc roomPoolBloc,
  }) {
    _authenticationBloc = authenticationBloc;
    _cityPoolBloc = cityPoolBloc;
    _centrePoolBloc = centrePoolBloc;
    _roomPoolBloc = roomPoolBloc;

    _router = GoRouter(
      navigatorKey: _rootKey,
      refreshListenable: _StreamToListenable([
        _authenticationBloc.stream,
        _cityPoolBloc.stream,
        _centrePoolBloc.stream,
        _roomPoolBloc.stream,
      ]),
      redirect: (context, state) {
        switch (_authenticationBloc.state.status) {
          case AuthenticationStatus.initial:
          case AuthenticationStatus.loading:
          case AuthenticationStatus.unauthenticated:
          case AuthenticationStatus.error:
            return AppRoutes.splash.path;

          case AuthenticationStatus.authenticated:
            switch (_cityPoolBloc.state.status) {
              case RequestStatus.initial:
              case RequestStatus.loading:
              case RequestStatus.error:
                return AppRoutes.splash.path;

              case RequestStatus.loaded:
                break;
            }

            switch (_centrePoolBloc.state.status) {
              case RequestStatus.initial:
              case RequestStatus.loading:
              case RequestStatus.error:
                return AppRoutes.splash.path;

              case RequestStatus.loaded:
                break;
            }

            switch (_roomPoolBloc.state.status) {
              case RequestStatus.initial:
              case RequestStatus.loading:
              case RequestStatus.error:
                return AppRoutes.splash.path;

              case RequestStatus.loaded:
                break;
            }

            if (state.uri.path == AppRoutes.splash.path) {
              return AppRoutes.booking.path;
            }
        }

        // no need to redirect programmatically
        return null;
      },
      routes: [
        ShellRoute(
          parentNavigatorKey: _rootKey,
          navigatorKey: _baseShellKey,
          pageBuilder: (context, state, child) => CupertinoPage(
            key: state.pageKey,
            child: BaseShellLayout(child: child),
          ),
          routes: [
            GoRoute(
              path: AppRoutes.splash.path,
              name: AppRoutes.splash.name,
              pageBuilder: (context, state) =>
                  CupertinoPage(key: state.pageKey, child: const SplashPage()),
            ),
            GoRoute(
              path: AppRoutes.booking.path,
              name: AppRoutes.booking.name,
              pageBuilder: (context, state) =>
                  CupertinoPage(key: state.pageKey, child: const BookingPage()),
            ),
          ],
        ),
      ],
    );
  }

  static final _rootKey = GlobalKey<NavigatorState>();
  static final _baseShellKey = GlobalKey<NavigatorState>();

  late final GoRouter _router;

  late final AuthenticationBloc _authenticationBloc;
  late final CityPoolBloc _cityPoolBloc;
  late final CentrePoolBloc _centrePoolBloc;
  late final RoomPoolBloc _roomPoolBloc;

  GoRouterDelegate get routerDelegate => _router.routerDelegate;

  RouteInformationParser<Object> get routeInformationParser =>
      _router.routeInformationParser;

  RouteInformationProvider get routeInformationProvider =>
      _router.routeInformationProvider;
}

final class _StreamToListenable extends ChangeNotifier {
  _StreamToListenable(List<Stream<dynamic>> streams) {
    subscriptions = [];
    for (final e in streams) {
      final s = e.asBroadcastStream().listen(_tt);
      subscriptions.add(s);
    }
    notifyListeners();
  }
  late final List<StreamSubscription<dynamic>> subscriptions;

  @override
  void dispose() {
    for (final e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _tt(event) => notifyListeners();
}
