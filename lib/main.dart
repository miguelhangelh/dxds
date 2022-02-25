import 'dart:async';
import 'package:camera/camera.dart';
import 'package:appdriver/app.dart';
import 'package:appdriver/core/database/amplify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'core/notifications_locale/local_notification.dart';
import 'observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:appdriver/core/database/db_database.dart';
import 'package:appdriver/injection_container.dart';
import 'package:path_provider/path_provider.dart';
import 'core/share_prefs/user_pref.dart';
import 'features/authentication_aws/presentation/bloc/authentication_bloc.dart';
import 'features/preferences/presentation/bloc/preferences_bloc.dart';
import 'features/preferences/presentation/bloc/theme/theme_cubit.dart';
import 'package:appdriver/features/offline/presentation/bloc/conectivity_bloc.dart';
import 'injection_container.dart' as di;

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  await initPlatform();
  final conectivity = sl<ConnectivityBloc>();
  conectivity.initialize();
  runZonedGuarded(() async {
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
          BlocProvider<PreferencesBloc>(create: (context) => sl<PreferencesBloc>()),
          BlocProvider<AuthenticationBloc>(create: (context) => sl<AuthenticationBloc>()..add(AppStarted())),
          BlocProvider<ConnectivityBloc>(create: (BuildContext context) => conectivity),
        ],
        child: const MyApp(),
      ),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

Future<void> initPlatform() async {
  cameras = await availableCameras();
  final dbHive = DatabaseConfiguration();
  await dbHive.initHiveDB();
  LocalNotification data = LocalNotification();
  await data.setupFirebase();
  Bloc.observer = Observer();
  final prefs = UserPreference();
  var packageInfo = await PackageInfo.fromPlatform();
  await prefs.initPrefs();
  await di.init();
  final amplify = AmplifyConfigure();
  await amplify.initAmplifyConfigure();
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getTemporaryDirectory());
  await dotenv.load(fileName: "assets/.env_production", mergeWith: {"VERSION": packageInfo.version});
}
