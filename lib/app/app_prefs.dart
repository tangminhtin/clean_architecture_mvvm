import 'package:clean_architecture_mvvm/presentation/resources/language_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefsKeyLanguage = 'PREFS_KEY_LANGUAGE';
const String prefsKeyOnBoardingScreen = 'PREFS_KEY_ONBOARDING_SCREEN';
const String prefsKeyIsUserLoggedIn = 'PREFS_KEY_IS_USER_LOGGED_IN';
const String prefsKeyToken = 'PREFS_KEY_TOKEN';

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(prefsKeyLanguage);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.english.getValue();
    }
  }

  Future<void> setLanguageChanged() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.arabic.getValue()) {
      // Save prefs with english lang
      _sharedPreferences.setString(
          prefsKeyLanguage, LanguageType.english.getValue());
    } else {
      // Save prefs with arabic lang
      _sharedPreferences.setString(
          prefsKeyLanguage, LanguageType.arabic.getValue());
    }
  }

  Future<Locale> getLocal() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.arabic.getValue()) {
      // Return arabic local
      return arabicLocal;
    } else {
      // Return english local
      return englishLocal;
    }
  }

  Future<void> setOnBoardingScreenView() async {
    _sharedPreferences.setBool(prefsKeyOnBoardingScreen, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(prefsKeyOnBoardingScreen) ?? false;
  }

  Future<void> setUserToken(String token) async {
    _sharedPreferences.setString(prefsKeyToken, token);
  }

  Future<String> getUserToken() async {
    return _sharedPreferences.getString(prefsKeyToken) ?? '';
  }

  Future<void> setIsUserLoggedIn() async {
    _sharedPreferences.setBool(prefsKeyIsUserLoggedIn, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(prefsKeyIsUserLoggedIn) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(prefsKeyIsUserLoggedIn);
  }
}
