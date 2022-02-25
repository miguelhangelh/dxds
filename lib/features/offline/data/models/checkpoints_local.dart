
import 'package:hive/hive.dart';

part 'checkpoints_local.g.dart';



@HiveType(typeId: 25)
class CheckPointsLocal extends HiveObject {

  CheckPointsLocal( {
    this.checkPointId,
    this.dateTime,
    this.loadingOrderId,
    this.transportUnitId,
    this.lat,
    this.lng,
    this.exit,
  } );

  @HiveField(0)
  String? checkPointId;
  @HiveField(1)
  String? dateTime;
  @HiveField(2)
  String? loadingOrderId;
  @HiveField(3)
  String? transportUnitId;
  @HiveField(4)
  bool? exit;
  @HiveField(5)
  double? lat;
  @HiveField(6)
  double? lng;
  

}
