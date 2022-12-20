import 'package:clean_architecture_mvvm/presentation/resources/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefsKeyLanguage = 'PREFS_KEY_LANGUAGE';
const String prefsKeyOnBoardingScreen = 'PREFS_KEY_ONBOARDING_SCREEN';
const String prefsKeyIsUserLoggedIn = 'PREFS_KEY_IS_USER_LOGGED_IN';

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

  Future<void> setOnBoardingScreenView() async {
    _sharedPreferences.setBool(prefsKeyOnBoardingScreen, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(prefsKeyOnBoardingScreen) ?? false;
  }

  Future<void> setIsUserLoggedIn() async {
    _sharedPreferences.setBool(prefsKeyIsUserLoggedIn, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(prefsKeyIsUserLoggedIn) ?? false;
  }
}
