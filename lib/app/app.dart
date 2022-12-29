import 'package:clean_architecture_mvvm/app/app_prefs.dart';
import 'package:clean_architecture_mvvm/app/di.dart';
import 'package:clean_architecture_mvvm/presentation/resources/routes_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  int appState = 0;

  MyApp._internal(); // private named constructor

  static MyApp instance = MyApp._internal(); // single instance - singleton

  factory MyApp() => instance; // factory for the class instance

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashRoute,
      onGenerateRoute: RouteGenerator.getRoute,
      theme: getApplicationTheme(),
    );
  }
}
