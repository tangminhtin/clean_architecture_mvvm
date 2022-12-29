import 'package:clean_architecture_mvvm/presentation/resources/language_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture_mvvm/app/di.dart';
import 'package:clean_architecture_mvvm/app/app.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  runApp(EasyLocalization(
    supportedLocales: const [englishLocal, arabicLocal],
    path: assetsPathLocalizations,
    child: Phoenix(child: MyApp()),
  ));
}
