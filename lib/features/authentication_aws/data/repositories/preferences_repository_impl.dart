import 'dart:ui';

import 'package:appdriver/features/authentication_aws/domain/repositories/preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  static const String _localeLanguageCodeKey = 'localeLanguageCode';
  static const String _localeCountryCodeKey = 'localeCountryCode';
  static const String _theme = 'theme';

  @override
  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_localeLanguageCodeKey, locale.languageCode);
    await prefs.setString(_localeCountryCodeKey, locale.countryCode!);
  }

  @override
  Future<Locale?> get locale async {
    final prefs = await SharedPreferences.getInstance();

    final languageCode = prefs.getString(_localeLanguageCodeKey);
    final countryCode = prefs.getString(_localeCountryCodeKey);

    if (languageCode != null) {
      return Locale.fromSubtags(
        languageCode: languageCode,
        countryCode: countryCode,
      );
    }

    return null;
  }

  @override
  Future<bool> saveTheme(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_theme, dark);
    return true;
  }

  @override
  Future<bool?> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_theme);
  }
}
