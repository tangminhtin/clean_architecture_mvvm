import 'package:clean_architecture_mvvm/presentation/main/home/home_page.dart';
import 'package:clean_architecture_mvvm/presentation/main/notifications_page.dart';
import 'package:clean_architecture_mvvm/presentation/main/search_page.dart';
import 'package:clean_architecture_mvvm/presentation/main/settings_page.dart';
import 'package:clean_architecture_mvvm/presentation/resources/color_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/strings_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    NotificationsPage(),
    SettingsPage(),
  ];

  final List<String> titles = [
    AppStrings.home.tr(),
    AppStrings.search.tr(),
    AppStrings.notifications.tr(),
    AppStrings.settings.tr(),
  ];

  String _title = AppStrings.home.tr();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorManager.lightGrey,
              spreadRadius: AppSize.s1,
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          currentIndex: _currentIndex,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppStrings.home.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: AppStrings.search.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications),
              label: AppStrings.notifications.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppStrings.settings.tr(),
            ),
          ],
        ),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = titles[index];
    });
  }
}
