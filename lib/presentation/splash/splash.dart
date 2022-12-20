import 'dart:async';

import 'package:clean_architecture_mvvm/app/app_prefs.dart';
import 'package:clean_architecture_mvvm/app/di.dart';
import 'package:clean_architecture_mvvm/presentation/resources/assets_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/color_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  void _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  void _goNext() {
    _appPreferences.isUserLoggedIn().then(
      (isUserLoggedIn) {
        if (isUserLoggedIn) {
          // Navigate to main screen
          Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
        } else {
          _appPreferences.isOnBoardingScreenViewed().then(
            (isOnBoardingScreenViewed) {
              if (isOnBoardingScreenViewed) {
                Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(Routes.onBoardingRoute);
              }
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: const Center(
        child: Image(
          image: AssetImage(ImageAssets.splashLogo),
        ),
      ),
    );
  }
}
