import 'dart:async';
import 'package:appdriver/features/operation/data/supcriptions/task_subscriptions_operation.dart';
import 'package:background_fetch/background_fetch.dart' as bf;
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
import 'package:appdriver/features/offline/data/models/checkpoints_local.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/offline/data/supcriptions/supcription_conectivity.dart';
import 'package:appdriver/features/offline/domain/usecases/get_all_checkpoints_usecase.dart';
import 'package:appdriver/features/offline/domain/usecases/get_task_all_usecase.dart';
import 'package:appdriver/features/offline/domain/usecases/set_checkpoints_usecase.dart';
import 'package:appdriver/features/offline/domain/usecases/set_task_usecase.dart';
import 'package:appdriver/features/offline/domain/usecases/sincronized_checkpoints_usecases.dart';
import 'package:appdriver/features/offline/domain/usecases/sincronized_usecases.dart';

part 'conectivity_event.dart';
part 'conectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final SynchronizedConnectivityUseCase sincronizedConectivityUseCase;
  final SynchronizedCheckPointsUseCase sincronizedCheckPointsUseCase;
  final GetAllTaskUsecase getAllTaskUsecse;
  final GetAllCheckPointsUsecase getAllCheckPointsUsecase;
  final SetTaskUsecase setTaskUsecase;
  final SetCheckPointsUsecase setCheckPointsUsecase;
  Dio dio = Dio(); // with default Options
  bool run = false;

  final StreamController<bool> _connectionStreamController = StreamController<bool>.broadcast();
  Stream<bool> get streamBloc => _connectionStreamController.stream;

  ConnectivityBloc({
    required this.sincronizedConectivityUseCase,
    required this.sincronizedCheckPointsUseCase,
    required this.getAllTaskUsecse,
    required this.getAllCheckPointsUsecase,
    required this.setTaskUsecase,
    required this.setCheckPointsUsecase,
  }) : super(ConnectivityState());

  final Connectivity _connectivity = Connectivity();

  Cron? _cron;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  void initialize() {
    dio.options.connectTimeout = 5000; //5s
    Connectivity().checkConnectivity().then((ConnectivityResult connectivityResult) async {
      if (connectivityResult == ConnectivityResult.none) {
        add(OnOffline());
        run = false;
        _cron?.close();
      }
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_initConnectivity);

      SubscriptionConnectivity.instance.stream.listen((TaskLocal task) {
        setTaskUsecase(task).then((bool result) {
          if (result) {
            add(SuccessTask());
          } else {
            add(CancelTask());
          }
        }).catchError((onError) {
          add(CancelTask());
        });
      });
      SubscriptionConnectivity.instance.streamCheckPoints.listen((CheckPointsLocal checkPointsLocal) {
        setCheckPointsUsecase(checkPointsLocal).then((bool result) {}).catchError((onError) {});
      });
      streamBloc.listen((event) {
        if (event) {}
      });
    });
  }

  Future<void> initPlatformState() async {
    try {
      await bf.BackgroundFetch.configure(
          bf.BackgroundFetchConfig(
            minimumFetchInterval: 15,
            forceAlarmManager: false,
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: bf.NetworkType.NONE,
          ),
          _onBackgroundFetch,
          _onBackgroundFetchTimeout);
      bf.BackgroundFetch.scheduleTask(bf.TaskConfig(
        taskId: "periodic",
        delay: 5000,
        periodic: true,
        forceAlarmManager: false,
        stopOnTerminate: false,
        enableHeadless: true,
      ));
      bf.BackgroundFetch.start().then((int status) {}).catchError((e) {});
      bf.BackgroundFetch.status.then((value) => value);
    } catch (_) {}
  }

  void _onBackgroundFetch(String taskId) async {}

  void _onBackgroundFetchTimeout(String taskId) {
    bf.BackgroundFetch.finish(taskId);
  }

  void dispose() {
    _connectivitySubscription!.cancel();
    _connectionStreamController.close();
  }

  void _initConnectivity(ConnectivityResult connectivityResult) async {
    await Future.delayed(const Duration(seconds: 2));

    Connectivity().checkConnectivity().then((ConnectivityResult connectivityResult) async {
      if (connectivityResult == ConnectivityResult.none) {
        add(OnOffline());
        run = false;
        _cron?.close();
      }
      try {
        var response = await dio.get(
          'https://www.google.com/',
        );
        if (response.statusCode == 200) {
          if (!run) {
            add(OnOnline());
            initServiceAll();
            // workManager();
          } else {}
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectTimeout) {
          add(OnOffline());
          run = false;
          _cron?.close();
        }
        if (e.type == DioErrorType.receiveTimeout) {
          add(OnOffline());
          run = false;
          _cron?.close();
        }
        if (e.type == DioErrorType.other) {
          add(OnOffline());
          run = false;

          _cron?.close();
        }
      }
    });
  }

  initServiceAll() {
    _cron = Cron();
    run = true;
    _cron!.schedule(Schedule.parse('*/2 * * * *'), () async {
      if (getAllTaskUsecse()) {
        await sincronizedConectivityUseCase();
        TaskSubscriptionsOperation.instance.streamAdd = true;
      } else {}
      if (getAllCheckPointsUsecase()) {
        sincronizedCheckPointsUseCase().then((value) {});
      } else {}
    });
  }

  @override
  Stream<ConnectivityState> mapEventToState(ConnectivityEvent event) async* {
    if (event is OnOnline) {
      yield state.copyWith(online: true, offline: false);
    } else if (event is OnOffline) {
      yield state.copyWith(
        online: false,
        offline: true,
      );
    } else if (event is OnConnecting) {
    } else if (event is SuccessTask) {
      yield state.copyWith(
        successTask: true,
      );
    } else if (event is CancelTask) {
      yield state.copyWith(
        successTask: false,
      );
    }
  }
}
