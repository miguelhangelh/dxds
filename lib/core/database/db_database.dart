import 'package:hive/hive.dart';
import 'package:appdriver/features/location/data/datasource/local/location.dart';
import 'package:appdriver/features/offline/data/models/checkpoints_local.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/tasks/data/datasources/local/tasks_local.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DatabaseConfiguration {
  static final DatabaseConfiguration _instance = DatabaseConfiguration._();

  factory DatabaseConfiguration() {
    return _instance;
  }

  DatabaseConfiguration._();
  final LocationDatabaseLocal _dbLocation = LocationDatabaseLocal();
  final TasksLocalDB _dbTasksLocal = TasksLocalDB();

  initHiveDB() async {
    try {
      final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
      Hive
        ..init(appDocumentDir.path)
        ..registerAdapter(TaskLocalAdapter())
        ..registerAdapter(CheckPointsLocalAdapter());
      await _dbLocation.initHiveDB();
      await _dbTasksLocal.initHiveDB();
    } catch (e) {
      print("ERROR HIVE-> $e");
    }
  }

  closeHiveDB() {
    _dbLocation.dataBaseLocation?.close();
    _dbTasksLocal.dbTaskLocal?.close();
  }
}

// flutter packages pub run build_runner build
