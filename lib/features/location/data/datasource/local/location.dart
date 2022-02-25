import 'package:hive/hive.dart';
import 'package:appdriver/features/offline/data/models/checkpoints_local.dart';

class LocationDatabaseLocal {
  static final LocationDatabaseLocal _instance = LocationDatabaseLocal._();

  factory LocationDatabaseLocal() {
    return _instance;
  }
  LocationDatabaseLocal._();

  Box<CheckPointsLocal>? _dataBasePositions;

  Box<CheckPointsLocal>? get dataBaseLocation => _dataBasePositions;

  initHiveDB() async {
    try {
      _dataBasePositions = await Hive.openBox<CheckPointsLocal>('checkPointsLocal');
    } catch (_) {}
  }

  Box<CheckPointsLocal>? getAllPositions() {
    return _dataBasePositions;
  }

  addPosition(CheckPointsLocal position) {
    _dataBasePositions!.add(position);
  }

  updatePosition(int index, CheckPointsLocal position) {
    _dataBasePositions!.putAt(index, position);
  }

  deletePosition(int index) {
    _dataBasePositions!.deleteAt(index);
  }

  deletePositionKey(key) {
    _dataBasePositions!.delete(key);
  }
}
