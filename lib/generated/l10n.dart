// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hola mundo`
  String get simpleText {
    return Intl.message(
      'Hola mundo',
      name: 'simpleText',
      desc: '',
      args: [],
    );
  }

  /// `Localizacion`
  String get location {
    return Intl.message(
      'Localizacion',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Tareas`
  String get task {
    return Intl.message(
      'Tareas',
      name: 'task',
      desc: '',
      args: [],
    );
  }

  /// `Idioma`
  String get language {
    return Intl.message(
      'Idioma',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Elige el idioma`
  String get Choose {
    return Intl.message(
      'Elige el idioma',
      name: 'Choose',
      desc: '',
      args: [],
    );
  }

  /// `Tema`
  String get theme {
    return Intl.message(
      'Tema',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Iniciar sesión`
  String get login {
    return Intl.message(
      'Iniciar sesión',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Ingresar como invitado`
  String get guest {
    return Intl.message(
      'Ingresar como invitado',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `Bienvenido`
  String get welcome {
    return Intl.message(
      'Bienvenido',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa tu número de celular`
  String get welcomePhoneLogin {
    return Intl.message(
      'Ingresa tu número de celular',
      name: 'welcomePhoneLogin',
      desc: '',
      args: [],
    );
  }

  /// `Para poder ingresar a DeltaX necesitamos verificar tu número de celular:`
  String get messagePhoneLogin {
    return Intl.message(
      'Para poder ingresar a DeltaX necesitamos verificar tu número de celular:',
      name: 'messagePhoneLogin',
      desc: '',
      args: [],
    );
  }

  /// `Omitir`
  String get skip {
    return Intl.message(
      'Omitir',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Ingrese el código de verificación`
  String get messagePhoneSms {
    return Intl.message(
      'Ingrese el código de verificación',
      name: 'messagePhoneSms',
      desc: '',
      args: [],
    );
  }

  /// `Te enviamos un código de verificación de 6 dígitos por SMS al número de celular:`
  String get messagePhoneSmsBody {
    return Intl.message(
      'Te enviamos un código de verificación de 6 dígitos por SMS al número de celular:',
      name: 'messagePhoneSmsBody',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es', countryCode: 'ES'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
