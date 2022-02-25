import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:appdriver/core/utils/functions.dart';
import 'package:appdriver/core/utils/notifications_type.dart';
import 'package:appdriver/extensions_methos_global/navigation/navigation_methods.dart';
import 'package:appdriver/features/operation/presentation/pages/operation_page.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appdriver/core/database/db_database.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/authentication_aws/presentation/bloc/authentication_bloc.dart';
import 'package:appdriver/features/login/presentation/pages/view_login.dart';
import 'package:appdriver/features/operation/data/supcriptions/supcription_bloc_operation.dart';
import 'package:appdriver/features/operation/presentation/pages/travels_past_page.dart';
import 'package:appdriver/features/opportunity/data/supcriptions/supcription_oportunity.dart';
import 'package:appdriver/features/authentication_aws/subcriptions/subcription_bloc_authentication.dart';
import 'package:appdriver/features/opportunity/presentation/bloc/opportunity_bloc.dart';
import 'package:appdriver/features/opportunity/presentation/pages/detail_opportunity_page.dart';
import 'package:appdriver/features/opportunity/presentation/pages/principal_opportunity_page.dart';
import 'package:appdriver/features/profile/presentation/pages/register/transport_unit/transport_unit_data_page.dart';
import 'package:appdriver/features/profile/presentation/pages/register/transport_unit/transport_unit_features_page.dart';
import 'package:appdriver/features/profile/presentation/pages/register/transport_unit/transport_unit_type_page.dart';
import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:appdriver/injection_container.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/routes/routes.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/dialogs.dart';
import 'core/version/version.dart';
import 'features/authentication_aws/data/repositories/preferences_repository_impl.dart';
import 'features/models/user_model.dart';
import 'features/on_boarding/presentation/pages/on_boarding.dart';
import 'features/phone_authentication_aws/presentation/pages/login_phone_number_view_1.dart';
import 'features/preferences/presentation/bloc/preferences_bloc.dart';
import 'features/preferences/presentation/bloc/theme/theme_cubit.dart';
import 'features/profile/presentation/pages/account/contract_profile_page.dart';
import 'features/profile/presentation/pages/register/profile/register_profile_page.dart';
import 'generated/l10n.dart';

void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  switch (headlessEvent.name) {
    case bg.Event.BOOT:
      bg.State state = await bg.BackgroundGeolocation.state;
      break;
    case bg.Event.TERMINATE:
      try {} catch (_) {}
      break;
    case bg.Event.HEARTBEAT:
      break;
    case bg.Event.LOCATION:
      bg.Location? location = headlessEvent.event;
      break;
    case bg.Event.MOTIONCHANGE:
      bg.Location? location = headlessEvent.event;
      break;
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent? geofenceEvent = headlessEvent.event;
      addLocalGeofenceGpsHeadLess(geofenceEvent);
      break;
    case bg.Event.GEOFENCESCHANGE:
      bg.GeofencesChangeEvent? event = headlessEvent.event;
      break;
    case bg.Event.SCHEDULE:
      bg.State? state = headlessEvent.event;
      break;
    case bg.Event.ACTIVITYCHANGE:
      bg.ActivityChangeEvent? event = headlessEvent.event;
      break;
    case bg.Event.HTTP:
      bg.HttpEvent? response = headlessEvent.event;
      break;
    case bg.Event.POWERSAVECHANGE:
      bool? enabled = headlessEvent.event;
      break;
    case bg.Event.CONNECTIVITYCHANGE:
      bg.ConnectivityChangeEvent? event = headlessEvent.event;
      break;
    case bg.Event.ENABLEDCHANGE:
      bool? enabled = headlessEvent.event;
      break;
    case bg.Event.AUTHORIZATION:
      bg.AuthorizationEvent? event = headlessEvent.event;
      break;
  }
}

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;
  if (timeout) {
    BackgroundFetch.finish(taskId);
    return;
  }
  if (taskId == 'com.deltaxlat.appdriver') {
    addLocalGpsHeadLess();
  }
  if (taskId == 'com.deltaxlat.appdriver.tasks') {
    syncHeadlessTasks();
  }
  if (taskId == 'com.deltaxlat.appdriver.locations') {
    syncHeadlessCheckPoints();
  }
  BackgroundFetch.finish(taskId);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  PackageInfo? packageInfo;
  UserPreference userPreference = UserPreference();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    verifyVersion();
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    bg.BackgroundGeolocation.registerHeadlessTask(backgroundGeolocationHeadlessTask);
    initPlatformStates();
    signature();
    WidgetsBinding.instance!.addObserver(this);
    AuthenticationSubcriptions.instance.stream.listen((event) async {
      switch (event) {
        case TypeRegister.operation:
          NavigatorExtension.pushAndRemoveUntilState(const OperationPage(), _navigator);
          break;
        case TypeRegister.profileRegister:
          NavigatorExtension.pushAndRemoveUntilState(const PrincipalProfilePage(), _navigator);
          break;
        case TypeRegister.transportUnitType:
          NavigatorExtension.pushAndRemoveUntilState(const TransportUnitTypePage(), _navigator);
          break;
        case TypeRegister.transportUnitData:
          NavigatorExtension.pushAndRemoveUntilState(const TransportUnitDataPage(), _navigator);
          break;
        case TypeRegister.transportUnitFeatures:
          NavigatorExtension.pushAndRemoveUntilState(const TransportUnitFeaturesPage(), _navigator);
          break;
        case TypeRegister.opportunity:
          NavigatorExtension.pushAndRemoveUntilState(const OpportunityPage(), _navigator);
          break;
        case TypeRegister.login:
          NavigatorExtension.pushAndRemoveUntilState(const LoginPhoneNumberView(), _navigator);
          break;
        default:
          NavigatorExtension.pushAndRemoveUntilState(const OpportunityPage(), _navigator);
          break;
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        print("INITIAL MESSAGE MAIN- > ${message.data}");
        if (message.data['type'] == notificationType(NOTIFICATION.POSTULATION_ACCEPTED)) {
          var travel = await postulationNewOnMessageOpenedApp(message);
          OpportunitySubcriptions.instance.streamAdd = OpportunityStream(
            travel: travel,
            notify: true,
          );
        }
        if (message.data['type'] == notificationType(NOTIFICATION.TRAVEL_NEW)) {
          var travel = await postulationNewOnMessageOpenedApp(message);
          OpportunitySubcriptions.instance.streamAdd = OpportunityStream(
            travel: travel,
            notify: true,
          );
        }
        if (message.data['type'] == notificationType(NOTIFICATION.ASSIGNED_LOAD_ORDER)) {
          OperationSubcriptions.instance.streamAdd = message.data;
        }
        if (message.data['type'] == notificationType(NOTIFICATION.NEWS)) {
          OperationSubcriptions.instance.streamAdd = message.data;
        }
        if (message.data['type'] == notificationType(NOTIFICATION.BENEFITS)) {
          OperationSubcriptions.instance.streamAdd = message.data;
        }
        if (message.data['type'] == notificationType(NOTIFICATION.TRAVEL_PAID)) {
          OperationSubcriptions.instance.streamAdd = message.data;
        }
        if (message.data['type'] == notificationType(NOTIFICATION.UPDATE_USER)) {
          updateUser();
        }
        if (message.data['type'] == notificationType(NOTIFICATION.REJECT_TASK)) {
          taskRejectedHeadLess(message.data['taskId']);
        }
        if (message.data['type'] == notificationType(NOTIFICATION.LOCATION)) {
          sendCheckPointsOnlineHeadless();
        }
        if (message.data['type'] == notificationType(NOTIFICATION.VALIDATE_TASK)) {
          taskValidateHeadless(message.data['taskId']);
        }
      }
    });
    OpportunitySubcriptions.instance.stream.listen(
      (event) async {
        print('OportunitySubcriptions->>>> $event');
        if (event.travel != null) {
          if (event.notify == true) {
            _navigator.push(
              MaterialPageRoute<DetailOpportunityPage>(
                builder: (_) => BlocProvider(
                  create: (context) => sl<OpportunityBloc>(),
                  child: DetailOpportunityPage(
                    travelItem: event.travel,
                    notification: false,
                  ),
                ),
              ),
            );
          } else {
            await showModalBottomSheet(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
              ),
              context: _navigator.overlay!.context,
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tu postulación ha sido aceptada, ingresa para confimar.',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundedButton(
                              backgroundColor: const Color(0xffFAFAFA),
                              borderColor: Colors.transparent,
                              textColor: Colors.black,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              label: S.of(context).skip,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: RoundedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _navigator.push(
                                  MaterialPageRoute<DetailOpportunityPage>(
                                    builder: (_) => BlocProvider(
                                      create: (context) => sl<OpportunityBloc>(),
                                      child: DetailOpportunityPage(
                                        travelItem: event.travel,
                                        notification: false,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              label: 'Ingresar',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      },
    );
    OperationSubcriptions.instance.stream.listen((event) async {
      print('Event OperationSubcriptions $event');

      if (event!['type'] == notificationType(NOTIFICATION.TRAVEL_NEW)) {
        _navigator.pushNamed('opportunity');
      }
      if (event['type'] == notificationType(NOTIFICATION.TRAVEL_PAID)) {
        _navigator.pushNamed('payment');
      }
      if (event['type'] == notificationType(NOTIFICATION.BENEFITS)) {
        _navigator.pushNamed('benefits');
      }
      if (event['type'] == notificationType(NOTIFICATION.NEWS)) {
        _navigator.pushNamed('notification');
      }
      if (event['type'] == notificationType(NOTIFICATION.ASSIGNED_LOAD_ORDER)) {
        await showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
          ),
          context: _navigator.overlay!.context,
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Te asignaron una orden de carga, ¿deseas ingresar?',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                          backgroundColor: const Color(0xffFAFAFA),
                          borderColor: Colors.transparent,
                          textColor: Colors.black,
                          // loading: state.formStatus is FormSubmitting ? true : false,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          label: S.of(context).skip,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: RoundedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _navigator.pushNamed(TravelPastPage.routeName);
                          },
                          label: 'Si, ingresar',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
      if (event['type'] == notificationType(NOTIFICATION.CANCEL_LOAD_ORDER)) {
        _navigator.pushNamed('opportunity');
      }
    });
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });
    initMobileNumberState();
    final Brightness currentBrightness = AppTheme.currentSystemBrightness;
    currentBrightness == Brightness.light
        ? context.read<ThemeCubit>().setTheme(ThemeMode.light)
        : context.read<ThemeCubit>().setTheme(ThemeMode.dark);
  }

  Future<void> initDynamicLinks() async {
    AuthSession res = await Amplify.Auth.fetchAuthSession();
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      if (res.isSignedIn) {
        final Uri? deepLink = dynamicLink.link;
        if (deepLink != null) {
          var c = deepLink.path;
          var j = c.replaceAll("/", "");
          if (j == "operation_page") {
            UserModel user = userPreference.getUser;
            if (!user.signedContract) {
              Navigator.pop(context);
              NavigatorExtension.pushAndRemoveUntil(const ContractProfilePage(), context);
            } else {
              Navigator.pop(context);
              NavigatorExtension.pushAndRemoveUntil(const OperationPage(), context);
            }
          }
        }
      }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  Future<void> initPlatformStates() async {
    await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 60,
          forceAlarmManager: false,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ), (String taskId) async {
      if (taskId == 'com.deltaxlat.appdriver') {
        addLocalGps();
      }
      if (taskId == 'com.deltaxlat.appdriver.tasks') {
        syncTasks();
      }
      if (taskId == 'com.deltaxlat.appdriver.locations') {
        syncCheckPoints();
      }
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      BackgroundFetch.finish(taskId);
    });
    await BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "com.deltaxlat.appdriver",
      delay: 1800000,
      periodic: true,
      forceAlarmManager: false,
      stopOnTerminate: false,
      requiredNetworkType: NetworkType.NONE,
      startOnBoot: true,
      enableHeadless: true,
    ));
    await BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "com.deltaxlat.appdriver.tasks",
      delay: 60000,
      periodic: true,
      forceAlarmManager: true,
      startOnBoot: true,
      requiredNetworkType: NetworkType.ANY,
      stopOnTerminate: false,
      enableHeadless: true,
    ));
    await BackgroundFetch.scheduleTask(TaskConfig(
      taskId: "com.deltaxlat.appdriver.locations",
      delay: 60000,
      periodic: true,
      requiredNetworkType: NetworkType.ANY,
      forceAlarmManager: true,
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
    ));
  }

  @override
  void didChangePlatformBrightness() {
    context.read<ThemeCubit>().updateAppTheme();
    super.didChangePlatformBrightness();
  }

  Future<void> verifyVersion() async {
    Version version = Version();
    try{
      bool isNewVersion = await version.version();
      if (isNewVersion) {
        await Dialogs.alert(
          _navigator.overlay!.context,
          title: 'Nueva versión!',
          description: 'Para poder usar la aplicación, es necesario actualizar a la nueva versión.',
          dismissible: false,
          okText: 'Actualizar',
          onPressed: () async {
            String urlPlayStore = 'https://play.google.com/store/apps/details?id=com.deltaxlat.appdriver';
            if (await canLaunch(urlPlayStore)) {
              await launch(urlPlayStore);
            }
          },
        );
      }
    }catch (e){
      print(e);
    }

  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    final dbHive = DatabaseConfiguration();
    dbHive.closeHiveDB();
  }

  Future<String> signature() async {
    var object = await SmsAutoFill().getAppSignature;
    return object;
  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final PreferencesState localeState = context.watch<PreferencesBloc>().state;
        return Sizer(
          builder: (context, orientation, deviceType) {
            return RefreshConfiguration(
              headerBuilder: () => ClassicHeader(
                textStyle: TextStyle(fontSize: 10.0.sp, color: Colors.grey),
                releaseText: 'Suelte para actualizar',
                idleText: 'Desliza hacia abajo para refrescar',
              ), // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
              footerBuilder: () => ClassicFooter(
                textStyle: TextStyle(fontSize: 10.0.sp, color: Colors.grey),
                noDataText: 'No hay más datos disponibles',
                idleText: 'Desliza hacia arriba carga más',
                canLoadingText: 'Suelte para cargar más',
                loadingText: "Cargando...",
              ), // Configure default bottom indicator
              enableScrollWhenRefreshCompleted:
                  true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
              enableLoadingWhenFailed: true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
              hideFooterWhenNotFull: true, // Disable pull-up to load more functionality when Viewport is less than one screen
              enableBallisticLoad: true,
              footerTriggerDistance: 20,
              maxUnderScrollExtent: 150,
              maxOverScrollExtent: 150,
              child: MaterialApp(
                localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) => locale,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                themeMode: context.select((ThemeCubit themeCubit) => themeCubit.state.themeMode),
                localizationsDelegates: const [
                  RefreshLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  S.delegate,
                ],
                builder: (BuildContext context, Widget? widget) {
                  final MediaQueryData data = MediaQuery.of(context);
                  return MediaQuery(
                    data: data.copyWith(
                      textScaleFactor: data.textScaleFactor.clamp(1, 1),
                    ),
                    child: widget!,
                  );
                },
                supportedLocales: S.delegate.supportedLocales,
                navigatorKey: _navigatorKey,
                locale: localeState.locale,
                home: const AppHome(),
                routes: appRoutes,
              ),
            );
          },
        );
      },
    );
  }
}

initPlatformState() async {
  bg.BackgroundGeolocation.onProviderChange((event) {});
  await bg.BackgroundGeolocation.ready(bg.Config(locationAuthorizationRequest: 'Always'));
  try {
    int status = await bg.BackgroundGeolocation.requestPermission();
    if (status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) {
    } else if (status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) {}
  } catch (_) {}
}

class AppHome extends StatelessWidget {
  const AppHome({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case AuthenticationUninitialized:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          case AuthenticatedOnBoardingIncompleteState:
            return const OnBoardingPage();
          case AuthenticationAuthenticated:
            return const OpportunityPage();
          case OpportunityViewState:
            return const OpportunityPage();
          case AuthenticationUnauthenticated:
            return const LoginMainView();
          case LoginMainViewState:
            return const LoginMainView();
          case OperationContractState:
            return const ContractProfilePage();
          case OperationPageState:
            return const OperationPage();
          case AuthenticationLoading:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          case PhoneAuthViewState:
            return const LoginPhoneNumberView();
          case ProfileMainViewState:
            return const PrincipalProfilePage();
          case TransportUnitTypeMainViewState:
            return const TransportUnitTypePage();
          case TransportUnitDataMainViewState:
            return const TransportUnitDataPage();
          case TransportUnitFeaturesMainViewState:
            return const TransportUnitFeaturesPage();
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
