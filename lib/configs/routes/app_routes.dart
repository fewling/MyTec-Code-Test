part of 'app_router.dart';

enum AppRoutes {
  splash('/'),
  booking('/booking'),
  checkout('/checkout') // out of scope
  ;

  const AppRoutes(this.path);

  final String path;
}
