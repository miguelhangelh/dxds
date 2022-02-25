import 'package:appdriver/features/offline/data/models/checkpoints_local.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';

abstract class ConnectivityRepository {
  Future<bool> synchronizedServices();
  Future<bool> synchronizedServicesCheckPoints();
  bool getAllTask();
  bool getAllCheckPointsExist();
  List<TaskLocal> getAllTaskPending();
  List<CheckPointsLocal> getAllCheckPoints();
  Future<bool> setTask(TaskLocal task);
  Future<bool> setCheckPoints(CheckPointsLocal task);
}
