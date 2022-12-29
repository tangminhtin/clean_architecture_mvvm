import 'package:flutter/material.dart';

enum LanguageType {
  english,
  arabic,
}

const String english = 'en';
const String arabic = 'ar';
const Locale englishLocal = Locale('en', 'US');
const Locale arabicLocal = Locale('ar', 'SA');
const String assetsPathLocalizations = 'assets/translations';

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.english:
        return english;
      case LanguageType.arabic:
        return arabic;
    }
  }
}
