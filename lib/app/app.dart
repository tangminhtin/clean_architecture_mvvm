import 'package:clean_architecture_mvvm/presentation/resources/routes_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/theme_manager.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashRoute,
      onGenerateRoute: RouteGenerator.getRoute,
      theme: getApplicationTheme(),
    );
  }
}
