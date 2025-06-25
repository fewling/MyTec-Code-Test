import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import 'app_dependency.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDependency(
      builder: (context, appRouter) => MaterialApp.router(
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerDelegate: appRouter.routerDelegate,
        routeInformationParser: appRouter.routeInformationParser,
        routeInformationProvider: appRouter.routeInformationProvider,
      ),
    );
  }
}
