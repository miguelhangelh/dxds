import 'dart:ui';

import 'package:flutter/material.dart';

abstract class PreferencesRepository {
  Future<void> saveLocale(Locale locale);
  Future<bool> saveTheme(bool dark);

  Future<Locale?> get locale;
  Future<bool?>  themeMode();
}
