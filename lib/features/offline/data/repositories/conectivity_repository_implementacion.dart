import 'package:appdriver/features/offline/data/datasources/conectivity_local_repository_data_source.dart';
import 'package:appdriver/features/offline/data/models/checkpoints_local.dart';
import 'package:appdriver/features/offline/data/models/tasks_local.dart';
import 'package:appdriver/features/offline/domain/repositories/conectivity_repository.dart';


class ConnectivityRepositoryImplementation extends ConnectivityRepository {
  final ConnectivityRepositoryDataSource connectivityLocalRepository;

  ConnectivityRepositoryImplementation({
    required this.connectivityLocalRepository,
  });

  @override
  Future<bool> synchronizedServices() async {
    return await connectivityLocalRepository.synchronizedServices();
  }

  @override
  bool getAllTask() => connectivityLocalRepository.getAllTask();

  @override
  Future<bool> setTask(TaskLocal task) async {
    return await connectivityLocalRepository.sendTask(task);
  }

  @override
  List<TaskLocal> getAllTaskPending() {
    return connectivityLocalRepository.getAllTaskPending();
  }

  @override
  List<CheckPointsLocal> getAllCheckPoints() {
    return connectivityLocalRepository.getAllCheckPoints();
  }

  @override
  bool getAllCheckPointsExist() {
    return connectivityLocalRepository.getAllCheckPointsExistData();
  }

  @override
  Future<bool> setCheckPoints(CheckPointsLocal checkPointsLocal) {
    return connectivityLocalRepository.setCheckPoints(checkPointsLocal);
  }

  @override
  Future<bool> synchronizedServicesCheckPoints() {
    return connectivityLocalRepository.synchronizedServicesCheckPoints();
  }
}
