import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appdriver/features/authentication_aws/domain/repositories/preferences_repository.dart';

abstract class PreferencesEvent extends Equatable {}

class ChangeLocale extends PreferencesEvent {
  final Locale locale;

  ChangeLocale(this.locale);

  @override
  List<Object> get props => [locale];
}

class PreferencesState extends Equatable {
  final Locale? locale;

  const PreferencesState({required this.locale});

  @override
  List<Object?> get props => [locale];
}

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesRepository _preferencesRepository;

  PreferencesBloc({
    required PreferencesRepository preferencesRepository,
    required Locale? initialLocale,
  })  : _preferencesRepository = preferencesRepository,
        super(PreferencesState(locale: initialLocale));

  @override
  Stream<PreferencesState> mapEventToState(
    PreferencesEvent event,
  ) async* {
    if (event is ChangeLocale) {
      await _preferencesRepository.saveLocale(event.locale);
      yield PreferencesState(locale: event.locale);
    }
  }
}
