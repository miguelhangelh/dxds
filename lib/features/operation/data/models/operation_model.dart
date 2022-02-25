// To parse this JSON data, do
//
//     final operation = operationFromJson(jsonString);

import 'dart:convert';

import 'package:appdriver/features/models/travel_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Operation operationFromJson(String str) => Operation.fromJson(json.decode(str));

String operationToJson(Operation data) => json.encode(data.toJson());

class Operation {
  Operation({
    this.dates,
    this.volumeUnit,
    this.weightUnit,
    this.categoryLoad,
    this.boardingMode,
    this.freightValues,
    this.loadingOrder,
    this.row,
    this.id,
    this.operationId,
    this.routeId,
    this.publish,
    this.typeTransportUnit,
    this.stages,
    this.route,
    this.authUsers,
    this.distanceTravel,
  });

  Dates? dates;
  Unit? volumeUnit;
  Unit? weightUnit;
  CategoryLoad? categoryLoad;
  BoardingMode? boardingMode;
  FreightValues? freightValues;
  LoadingOrder? loadingOrder;
  Row? row;
  String? id;
  String? operationId;
  String? routeId;
  bool? publish;
  List<TypeTransportUnit>? typeTransportUnit;
  AuthUsers? authUsers;
  List<Stage>? stages;
  Route? route;
  DistanceUnit? distanceTravel;
  factory Operation.fromJson(Map<String, dynamic> json) => Operation(
        dates: json["dates"] == null ? null : Dates.fromJson(json["dates"]),
        volumeUnit: json["volumeUnit"] == null ? null : Unit.fromJson(json["volumeUnit"]),
        weightUnit: json["weightUnit"] == null ? null : Unit.fromJson(json["weightUnit"]),
        categoryLoad: json["categoryLoad"] == null ? null : CategoryLoad.fromJson(json["categoryLoad"]),
        boardingMode: json["boardingMode"] == null ? null : BoardingMode.fromJson(json["boardingMode"]),
        freightValues: json["freightValues"] == null ? null : FreightValues.fromJson(json["freightValues"]),
        authUsers: json["authUsers"] == null ? null : AuthUsers.fromJson(json["authUsers"]),
        loadingOrder: json["loadingOrder"] == null ? null : LoadingOrder.fromJson(json["loadingOrder"]),
        row: json["row"] == null ? null : Row.fromJson(json["row"]),
        id: json["_id"] == null ? null : json["_id"],
        operationId: json["operationId"] == null ? null : json["operationId"],
        routeId: json["routeId"] == null ? null : json["routeId"],
        publish: json["publish"] == null ? null : json["publish"],
        distanceTravel: json["distanceTravel"] == null ? null : DistanceUnit.fromJson(json["distanceTravel"]),
        typeTransportUnit: json["typeTransportUnit"] == null
            ? null
            : List<TypeTransportUnit>.from(json["typeTransportUnit"].map((x) => TypeTransportUnit.fromJson(x))),
        stages: json["stages"] == null ? null : List<Stage>.from(json["stages"].map((x) => Stage.fromJson(x))),
        route: json["route"] == null ? null : Route.fromJson(json["route"]),
      );

  Map<String, dynamic> toJson() => {
        "dates": dates == null ? null : dates!.toJson(),
        "volumeUnit": volumeUnit == null ? null : volumeUnit!.toJson(),
        "weightUnit": weightUnit == null ? null : weightUnit!.toJson(),
        "categoryLoad": categoryLoad == null ? null : categoryLoad!.toJson(),
        "authUsers": authUsers == null ? null : authUsers!.toJson(),
        "boardingMode": boardingMode == null ? null : boardingMode!.toJson(),
        "freightValues": freightValues == null ? null : freightValues!.toJson(),
        "loadingOrder": loadingOrder == null ? null : loadingOrder!.toJson(),
        "row": row == null ? null : row!.toJson(),
        "_id": id == null ? null : id,
        "operationId": operationId == null ? null : operationId,
        "distanceTravel": distanceTravel == null ? null : distanceTravel!.toJson(),
        "routeId": routeId == null ? null : routeId,
        "publish": publish == null ? null : publish,
        "typeTransportUnit": typeTransportUnit == null ? null : List<dynamic>.from(typeTransportUnit!.map((x) => x.toJson())),
        "stages": stages == null ? null : List<dynamic>.from(stages!.map((x) => x.toJson())),
        "route": route == null ? null : route!.toJson(),
      };
}

class AuthUsers {
  AuthUsers({
    this.countryCode,
    this.phone,
    this.confirmed,
    this.email,
  });

  String? countryCode;
  String? phone;
  bool? confirmed;
  String? email;
  factory AuthUsers.fromJson(Map<String, dynamic> json) => AuthUsers(
        countryCode: json["countryCode"] == null ? null : json["countryCode"],
        phone: json["phone"] == null ? null : json["phone"],
        confirmed: json["confirmed"] == null ? null : json["confirmed"],
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toJson() => {
        "countryCode": countryCode == null ? null : countryCode,
        "phone": phone == null ? null : phone,
        "confirmed": confirmed == null ? null : confirmed,
        "email": email == null ? null : email,
      };
}

class BoardingMode {
  BoardingMode({
    this.boardingModeId,
    this.name,
  });

  String? boardingModeId;
  String? name;

  factory BoardingMode.fromJson(Map<String, dynamic> json) => BoardingMode(
        boardingModeId: json["boardingModeId"] == null ? null : json["boardingModeId"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "boardingModeId": boardingModeId == null ? null : boardingModeId,
        "name": name == null ? null : name,
      };
}

class MyPosition {
  MyPosition({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory MyPosition.fromJson(Map<String, dynamic> json) => MyPosition(
        lat: json["lat"] == null ? null : json["lat"],
        lng: json["lng"] == null ? null : json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
      };
}

class PolylineCoordinates {
  PolylineCoordinates({
    this.latLng,
  });

  List<LatLng>? latLng;

  factory PolylineCoordinates.fromJson(Map<String, dynamic> json) => PolylineCoordinates(
        latLng: json["latLng"] == null ? null : List<LatLng>.from(json["latLng"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "latLng": latLng == null ? null : latLng,
      };
}

class CategoryLoad {
  CategoryLoad({
    this.categoryLoadId,
    this.name,
  });

  String? categoryLoadId;
  String? name;

  factory CategoryLoad.fromJson(Map<String, dynamic> json) => CategoryLoad(
        categoryLoadId: json["categoryLoadId"] == null ? null : json["categoryLoadId"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "categoryLoadId": categoryLoadId == null ? null : categoryLoadId,
        "name": name == null ? null : name,
      };
}

class Dates {
  Dates({
    this.loadingDate,
    this.deliveryDate,
    this.publishDate,
  });

  DateTime? loadingDate;
  DateTime? deliveryDate;
  DateTime? publishDate;

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        loadingDate: json["loadingDate"] == null ? null : DateTime.parse(json["loadingDate"]),
        deliveryDate: json["deliveryDate"] == null ? null : DateTime.parse(json["deliveryDate"]),
        publishDate: json["publishDate"] == null ? null : DateTime.parse(json["publishDate"]),
      );

  Map<String, dynamic> toJson() => {
        "loadingDate": loadingDate == null ? null : loadingDate!.toIso8601String(),
        "deliveryDate": deliveryDate == null ? null : deliveryDate!.toIso8601String(),
        "publishDate": publishDate == null ? null : publishDate!.toIso8601String(),
      };
}

class FreightValues {
  FreightValues({
    this.clientFreight,
    this.freightOffered,
  });

  ClientFreight? clientFreight;
  FreightOffered? freightOffered;

  factory FreightValues.fromJson(Map<String, dynamic> json) => FreightValues(
        clientFreight: json["clientFreight"] == null ? null : ClientFreight.fromJson(json["clientFreight"]),
        freightOffered: json["freightOffered"] == null ? null : FreightOffered.fromJson(json["freightOffered"]),
      );

  Map<String, dynamic> toJson() => {
        "clientFreight": clientFreight == null ? null : clientFreight!.toJson(),
        "freightOffered": freightOffered == null ? null : freightOffered!.toJson(),
      };
}
class ClientFreight {
  ClientFreight({
    this.typeCurrencyFreightId,
    this.abbreviationtypeCurrency,
    this.typeMeasurementUnit,
    this.abbreviationUnit,
    this.freightValue,
    this.marginGain,
    this.invoice,
  });

  String? typeCurrencyFreightId;
  String? abbreviationtypeCurrency;
  String? typeMeasurementUnit;
  String? abbreviationUnit;
  double? freightValue;
  double? marginGain;
  bool? invoice;

  factory ClientFreight.fromJson(Map<String, dynamic> json) => ClientFreight(
    typeCurrencyFreightId: json["typeCurrencyFreightId"] == null ? null : json["typeCurrencyFreightId"],
    abbreviationtypeCurrency: json["abbreviationtypeCurrency"] == null ? null : json["abbreviationtypeCurrency"],
    typeMeasurementUnit: json["typeMeasurementUnit"] == null ? null : json["typeMeasurementUnit"],
    abbreviationUnit: json["abbreviationUnit"] == null ? null : json["abbreviationUnit"],
    freightValue: json["freightValue"] == null ? null : json["freightValue"].toDouble(),
    marginGain: json["marginGain"] == null ? null : json["marginGain"].toDouble(),
    invoice: json["invoice"] == null ? null : json["invoice"],
  );

  Map<String, dynamic> toJson() => {
    "typeCurrencyFreightId": typeCurrencyFreightId == null ? null : typeCurrencyFreightId,
    "abbreviationtypeCurrency": abbreviationtypeCurrency == null ? null : abbreviationtypeCurrency,
    "typeMeasurementUnit": typeMeasurementUnit == null ? null : typeMeasurementUnit,
    "abbreviationUnit": abbreviationUnit == null ? null : abbreviationUnit,
    "freightValue": freightValue == null ? null : freightValue,
    "marginGain": marginGain == null ? null : marginGain,
    "invoice": invoice == null ? null : invoice,
  };
}
class CarrierFreight {
  CarrierFreight({
    this.typeCurrencyFreightId,
    this.abbreviationtypeCurrencyFreight,
    this.typeMeasurementUnit,
    this.typeUnitMeasurement,
    this.abbreviationUnit,
    this.freightValue,
    this.invoice,
  });

  String? typeCurrencyFreightId;
  String? abbreviationtypeCurrencyFreight;
  String? typeMeasurementUnit;
  String? typeUnitMeasurement;
  String? abbreviationUnit;
  double? freightValue;
  bool? invoice;

  factory CarrierFreight.fromJson(Map<String, dynamic> json) => CarrierFreight(
    typeCurrencyFreightId: json["typeCurrencyFreightId"] == null ? null : json["typeCurrencyFreightId"],
    abbreviationtypeCurrencyFreight: json["abbreviationtypeCurrencyFreight"] == null ? null : json["abbreviationtypeCurrencyFreight"],
    typeMeasurementUnit: json["typeMeasurementUnit"] == null ? null : json["typeMeasurementUnit"],
    typeUnitMeasurement: json["typeUnitMeasurement"] == null ? null : json["typeUnitMeasurement"],
    abbreviationUnit: json["abbreviationUnit"] == null ? null : json["abbreviationUnit"],
    freightValue: json["freightValue"] == null ? null : json["freightValue"].toDouble(),
    invoice: json["invoice"] == null ? null : json["invoice"],
  );

  Map<String, dynamic> toJson() => {
    "typeCurrencyFreightId": typeCurrencyFreightId == null ? null : typeCurrencyFreightId,
    "abbreviationtypeCurrencyFreight": abbreviationtypeCurrencyFreight == null ? null : abbreviationtypeCurrencyFreight,
    "typeMeasurementUnit": typeMeasurementUnit == null ? null : typeMeasurementUnit,
    "typeUnitMeasurement": typeUnitMeasurement == null ? null : typeUnitMeasurement,
    "abbreviationUnit": abbreviationUnit == null ? null : abbreviationUnit,
    "freightValue": freightValue == null ? null : freightValue,
    "invoice": invoice == null ? null : invoice,
  };
}

class FreightOffered {
  FreightOffered({
    this.typeCurrencyOfferedId,
    this.abbreviationTypeCurrency,
    this.typeMeasurementUnit,
    this.abbreviationUnit,
    this.typeUnitMeasurement,
    this.invoice,
    this.value,
  });

  String? typeCurrencyOfferedId;
  String? abbreviationTypeCurrency;
  String? typeMeasurementUnit;
  String? abbreviationUnit;
  String? typeUnitMeasurement;
  bool? invoice;
  double? value;

  factory FreightOffered.fromJson(Map<String, dynamic> json) => FreightOffered(
    typeCurrencyOfferedId: json["typeCurrencyOfferedId"] == null ? null : json["typeCurrencyOfferedId"],
    typeUnitMeasurement: json["typeUnitMeasurement"] == null ? null : json["typeUnitMeasurement"],
    abbreviationTypeCurrency: json["abbreviationtypeCurrency"] == null ? null : json["abbreviationtypeCurrency"],
    typeMeasurementUnit: json["typeMeasurementUnit"] == null ? null : json["typeMeasurementUnit"],
    abbreviationUnit: json["abbreviationUnit"] == null ? null : json["abbreviationUnit"],
    invoice: json["invoice"] == null ? false : json["invoice"],
    value: json["value"] == null ? null : json["value"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "typeCurrencyOfferedId": typeCurrencyOfferedId == null ? null : typeCurrencyOfferedId,
    "typeUnitMeasurement": typeUnitMeasurement == null ? null : typeUnitMeasurement,
    "abbreviationtypeCurrency": abbreviationTypeCurrency == null ? null : abbreviationTypeCurrency,
    "typeMeasurementUnit": typeMeasurementUnit == null ? null : typeMeasurementUnit,
    "abbreviationUnit": abbreviationUnit == null ? null : abbreviationUnit,
    "invoice": invoice == null ? false : invoice,
    "value": value == null ? null : value,
  };
}

class LoadingOrder {
  LoadingOrder({
    this.carrierFreight,
    this.datesDone,
    this.originDone,
    this.destinationDone,
    this.assignment,
    this.distanceTraveled,
    this.weightUnit,
    this.volumeUnit,
    this.packaging,
    this.loadingOrderStatus,
    this.loadingOrderId,
  });

  CarrierFreight? carrierFreight;
  DatesDone? datesDone;
  DatesDone? originDone;
  DatesDone? destinationDone;
  Assignment? assignment;
  DatesDone? distanceTraveled;
  Unit? weightUnit;
  Unit? volumeUnit;
  String? packaging;
  List<LoadingOrderStatus>? loadingOrderStatus;
  String? loadingOrderId;

  factory LoadingOrder.fromJson(Map<String, dynamic> json) => LoadingOrder(
        carrierFreight: json["carrierFreight"] == null ? null : CarrierFreight.fromJson(json["carrierFreight"]),
        datesDone: json["datesDone"] == null ? null : DatesDone.fromJson(json["datesDone"]),
        originDone: json["originDone"] == null ? null : DatesDone.fromJson(json["originDone"]),
        destinationDone: json["destinationDone"] == null ? null : DatesDone.fromJson(json["destinationDone"]),
        assignment: json["assignment"] == null ? null : Assignment.fromJson(json["assignment"]),
        distanceTraveled: json["distanceTraveled"] == null ? null : DatesDone.fromJson(json["distanceTraveled"]),
        weightUnit: json["weightUnit"] == null ? null : Unit.fromJson(json["weightUnit"]),
        volumeUnit: json["VolumeUnit"] == null ? null : Unit.fromJson(json["VolumeUnit"]),
        packaging: json["packaging"] == null ? null : json["packaging"],
        loadingOrderStatus: json["LoadingOrderStatus"] == null
            ? null
            : List<LoadingOrderStatus>.from(json["LoadingOrderStatus"].map((x) => LoadingOrderStatus.fromJson(x))),
        loadingOrderId: json["loadingOrderId"] == null ? null : json["loadingOrderId"],
      );

  Map<String, dynamic> toJson() => {
        "carrierFreight": carrierFreight == null ? null : carrierFreight!.toJson(),
        "datesDone": datesDone == null ? null : datesDone!.toJson(),
        "originDone": originDone == null ? null : originDone!.toJson(),
        "destinationDone": destinationDone == null ? null : destinationDone!.toJson(),
        "assignment": assignment == null ? null : assignment!.toJson(),
        "distanceTraveled": distanceTraveled == null ? null : distanceTraveled!.toJson(),
        "weightUnit": weightUnit == null ? null : weightUnit!.toJson(),
        "VolumeUnit": volumeUnit == null ? null : volumeUnit!.toJson(),
        "packaging": packaging == null ? null : packaging,
        "LoadingOrderStatus": loadingOrderStatus == null ? null : List<dynamic>.from(loadingOrderStatus!.map((x) => x.toJson())),
        "loadingOrderId": loadingOrderId == null ? null : loadingOrderId,
      };
}

class Assignment {
  Assignment({
    this.assignmentStatus,
    this.transportUnitId,
  });

  int? assignmentStatus;
  String? transportUnitId;

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
        assignmentStatus: json["assignmentStatus"] == null ? null : json["assignmentStatus"],
        transportUnitId: json["transportUnitId"] == null ? null : json["transportUnitId"],
      );

  Map<String, dynamic> toJson() => {
        "assignmentStatus": assignmentStatus == null ? null : assignmentStatus,
        "transportUnitId": transportUnitId == null ? null : transportUnitId,
      };
}

class DatesDone {
  DatesDone();

  factory DatesDone.fromJson(Map<String, dynamic>? json) => DatesDone();

  Map<String, dynamic> toJson() => {};
}

class LoadingOrderStatus {
  LoadingOrderStatus({
    this.id,
    this.statusId,
    this.name,
    this.order,
    this.date,
  });

  String? id;
  String? statusId;
  String? name;
  int? order;
  DateTime? date;

  factory LoadingOrderStatus.fromJson(Map<String, dynamic> json) => LoadingOrderStatus(
        id: json["_id"] == null ? null : json["_id"],
        statusId: json["statusId"] == null ? null : json["statusId"],
        name: json["name"] == null ? null : json["name"],
        order: json["order"] == null ? null : json["order"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "statusId": statusId == null ? null : statusId,
        "name": name == null ? null : name,
        "order": order == null ? null : order,
        "date": date == null ? null : date!.toIso8601String(),
      };
}

class Unit {
  Unit({
    this.volumeUnitId,
    this.name,
    this.abbreviation,
    this.value,
    this.weightUnitId,
    this.unitVolumeUnitId,
  });

  String? volumeUnitId;
  String? name;
  String? abbreviation;
  double? value;
  String? weightUnitId;
  String? unitVolumeUnitId;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        volumeUnitId: json["VolumeUnitId"] == null ? null : json["VolumeUnitId"],
        name: json["name"] == null ? null : json["name"],
        abbreviation: json["abbreviation"] == null ? null : json["abbreviation"],
        value: json["value"] == null ? null : json["value"].toDouble(),
        weightUnitId: json["weightUnitId"] == null ? null : json["weightUnitId"],
        unitVolumeUnitId: json["volumeUnitId"] == null ? null : json["volumeUnitId"],
      );

  Map<String, dynamic> toJson() => {
        "VolumeUnitId": volumeUnitId == null ? null : volumeUnitId,
        "name": name == null ? null : name,
        "abbreviation": abbreviation == null ? null : abbreviation,
        "value": value == null ? null : value,
        "weightUnitId": weightUnitId == null ? null : weightUnitId,
        "volumeUnitId": unitVolumeUnitId == null ? null : unitVolumeUnitId,
      };
}

class Route {
  Route({
    this.origin,
    this.destination,
    this.id,
    this.checkPoints,
  });

  Origin? origin;
  Destination? destination;
  String? id;
  List<CheckPoint>? checkPoints;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        origin: json["origin"] == null ? null : Origin.fromJson(json["origin"]),
        destination: json["destination"] == null ? null : Destination.fromJson(json["destination"]),
        id: json["_id"] == null ? null : json["_id"],
        checkPoints: json["checkPoints"] == null ? [] : List<CheckPoint>.from(json["checkPoints"].map((x) => CheckPoint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "origin": origin == null ? null : origin!.toJson(),
        "destination": destination == null ? null : destination!.toJson(),
        "_id": id == null ? null : id,
        "checkPoints": checkPoints == null ? [] : List<dynamic>.from(checkPoints!.map((x) => x.toJson())),
      };
}

class CheckPoint {
  CheckPoint({
    this.id,
    this.lat,
    this.lng,
    this.name,
    this.km,
    this.type,
  });

  String? id;
  double? lat;
  double? lng;
  String? name;
  int? km;
  String? type;

  factory CheckPoint.fromJson(Map<String, dynamic> json) => CheckPoint(
        id: json["_id"] == null ? null : json["_id"],
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lng: json["lng"] == null ? null : json["lng"].toDouble(),
        name: json["name"] == null ? null : json["name"],
        km: json["km"] == null ? null : json["km"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
        "name": name == null ? null : name,
        "km": km == null ? null : km,
        "type": type == null ? null : type,
      };
}

class Destination {
  Destination({
    this.placeId,
    this.countryDestination,
    this.cityDestination,
    this.directionDestination,
  });

  String? placeId;
  String? countryDestination;
  String? cityDestination;
  String? directionDestination;

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        placeId: json["PlaceId"] == null ? null : json["PlaceId"],
        countryDestination: json["countryDestination"] == null ? null : json["countryDestination"],
        cityDestination: json["cityDestination"] == null ? null : json["cityDestination"],
        directionDestination: json["directionDestination"] == null ? null : json["directionDestination"],
      );

  Map<String, dynamic> toJson() => {
        "PlaceId": placeId == null ? null : placeId,
        "countryDestination": countryDestination == null ? null : countryDestination,
        "cityDestination": cityDestination == null ? null : cityDestination,
        "directionDestination": directionDestination == null ? null : directionDestination,
      };
}

class Origin {
  Origin({
    this.placeId,
    this.countryOrigin,
    this.cityOrigin,
    this.direction,
  });

  String? placeId;
  String? countryOrigin;
  String? cityOrigin;
  String? direction;

  factory Origin.fromJson(Map<String, dynamic> json) => Origin(
        placeId: json["PlaceId"] == null ? null : json["PlaceId"],
        countryOrigin: json["countryOrigin"] == null ? null : json["countryOrigin"],
        cityOrigin: json["cityOrigin"] == null ? null : json["cityOrigin"],
        direction: json["direction"] == null ? null : json["direction"],
      );

  Map<String, dynamic> toJson() => {
        "PlaceId": placeId == null ? null : placeId,
        "countryOrigin": countryOrigin == null ? null : countryOrigin,
        "cityOrigin": cityOrigin == null ? null : cityOrigin,
        "direction": direction == null ? null : direction,
      };
}

class Row {
  Row({
    this.createDate,
  });

  DateTime? createDate;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
      );

  Map<String, dynamic> toJson() => {
        "createDate": createDate == null ? null : createDate!.toIso8601String(),
      };
}

class Stage {
  Stage({
    this.row,
    this.id,
    this.name,
    this.order,
    this.tasks,
    this.loadingOrderId,
    this.active,
  });

  Row? row;
  String? id;
  String? name;
  int? order;
  List<Task>? tasks;
  String? loadingOrderId;
  int? active;

  factory Stage.fromJson(Map<String, dynamic> json) => Stage(
        row: json["row"] == null ? null : Row.fromJson(json["row"]),
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        order: json["order"] == null ? null : json["order"],
        tasks: json["tasks"] == null ? null : List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
        loadingOrderId: json["loadingOrderId"] == null ? null : json["loadingOrderId"],
        active: json["active"] == null ? null : json["active"],
      );

  Map<String, dynamic> toJson() => {
        "row": row == null ? null : row!.toJson(),
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "order": order == null ? null : order,
        "tasks": tasks == null ? null : List<dynamic>.from(tasks!.map((x) => x.toJson())),
        "loadingOrderId": loadingOrderId == null ? null : loadingOrderId,
        "active": active == null ? null : active,
      };
}

class Task {
  Task({
    this.validation,
    this.allow,
    this.action = const [],
    this.id,
    this.taskId,
    this.name,
    this.changeStage,
    this.order,
    this.viewCarrier,
    this.viewClient,
    this.allowFiles,
    this.pushNotification,
    this.emailNotification,
    this.smsNotification,
    this.file,
  });

  Allow? validation;
  Allow? allow;
  List<Action> action;
  String? id;
  String? taskId;
  String? name;
  bool? changeStage;
  int? order;
  bool? viewCarrier;
  bool? viewClient;
  bool? allowFiles;
  bool? pushNotification;
  bool? emailNotification;
  bool? smsNotification;
  List<File>? file;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        validation: json["validation"] == null ? null : Allow.fromJson(json["validation"]),
        allow: json["allow"] == null ? null : Allow.fromJson(json["allow"]),
        action: json["action"] == null ? [] : List<Action>.from(json["action"].map((x) => Action.fromJson(x))),
        // action: json["action"] == null ? null : Action.fromJson(json["action"]),
        id: json["_id"] == null ? null : json["_id"],
        taskId: json["taskId"] == null ? null : json["taskId"],
        name: json["name"] == null ? null : json["name"],
        changeStage: json["changeStage"] == null ? null : json["changeStage"],
        order: json["order"] == null ? null : json["order"],
        viewCarrier: json["viewCarrier"] == null ? null : json["viewCarrier"],
        viewClient: json["viewClient"] == null ? null : json["viewClient"],
        allowFiles: json["allowFiles"] == null ? null : json["allowFiles"],
        pushNotification: json["pushNotification"] == null ? null : json["pushNotification"],
        emailNotification: json["emailNotification"] == null ? null : json["emailNotification"],
        smsNotification: json["smsNotification"] == null ? null : json["smsNotification"],
        file: json["file"] == null ? null : List<File>.from(json["file"].map((x) => File.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "validation": validation == null ? null : validation!.toJson(),
        "allow": allow == null ? null : allow!.toJson(),
        // "action": action == null ? null : action!.toJson(),
        "_id": id == null ? null : id,
        "taskId": taskId == null ? null : taskId,
        "name": name == null ? null : name,
        "changeStage": changeStage == null ? null : changeStage,
        "order": order == null ? null : order,
        "viewCarrier": viewCarrier == null ? null : viewCarrier,
        "viewClient": viewClient == null ? null : viewClient,
        "allowFiles": allowFiles == null ? null : allowFiles,
        "pushNotification": pushNotification == null ? null : pushNotification,
        "emailNotification": emailNotification == null ? null : emailNotification,
        "smsNotification": smsNotification == null ? null : smsNotification,
        "file": file == null ? null : List<dynamic>.from(file!.map((x) => x)),
        "action": file == null ? [] : List<dynamic>.from(action.map((x) => x)),
      };
}

class File {
  File({
    this.type,
    this.thumbnailPath,
    this.largePath,
    this.loadDate,
  });

  String? type;
  String? thumbnailPath;
  String? largePath;
  DateTime? loadDate;

  factory File.fromJson(Map<String, dynamic> json) => File(
        type: json["type"] == null ? null : json["type"],
        thumbnailPath: json["thumbnailPath"] == null ? null : json["thumbnailPath"],
        largePath: json["largePath"] == null ? null : json["largePath"],
        loadDate: json["loadDate"] == null ? null : DateTime.parse(json["loadDate"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "thumbnailPath": thumbnailPath == null ? null : thumbnailPath,
        "largePath": largePath == null ? null : largePath,
        "loadDate": loadDate == null ? null : loadDate!.toIso8601String(),
      };
}

class Validation {
  bool? ifValidation;
  bool? approve;
  Validation({
    this.ifValidation,
    this.approve,
  });
  factory Validation.fromJson(Map<String, dynamic> json) => Validation(
        approve: json["approve"] == null ? null : json["approve"],
        ifValidation: json["ifValidation"] == null ? null : json["ifValidation"],
      );

  Map<String, dynamic> toJson() => {
        "approve": approve == null ? null : approve,
        "ifValidation": ifValidation == null ? null : ifValidation,
      };
}

class Action {
  Action({
    this.dateAction,
    this.userId,
    this.comment,
    this.validation,
  });

  DateTime? dateAction;
  String? userId;
  String? comment;
  Validation? validation;

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        dateAction: json["dateAction"] == null ? null : DateTime.parse(json["dateAction"]),
        userId: json["userId"] == null ? null : json["userId"],
        comment: json["comment"] == null ? null : json["comment"],
        validation: json["Validation"] == null ? null : Validation.fromJson(json["Validation"]),
      );

  Map<String, dynamic> toJson() => {
        "dateAction": dateAction == null ? null : dateAction!.toIso8601String(),
        "userId": userId == null ? null : userId,
        "comment": comment == null ? null : comment,
        "Validation": validation == null ? null : validation!.toJson(),
      };
}

class Allow {
  Allow({
    this.operator,
    this.carrier,
    this.client,
  });

  bool? operator;
  bool? carrier;
  bool? client;

  factory Allow.fromJson(Map<String, dynamic> json) => Allow(
        operator: json["operator"] == null ? null : json["operator"],
        carrier: json["carrier"] == null ? null : json["carrier"],
        client: json["client"] == null ? null : json["client"],
      );

  Map<String, dynamic> toJson() => {
        "operator": operator == null ? null : operator,
        "carrier": carrier == null ? null : carrier,
        "client": client == null ? null : client,
      };
}

class TypeTransportUnit {
  TypeTransportUnit({
    this.id,
    this.typeTransportUnitId,
    this.name,
  });

  String? id;
  String? typeTransportUnitId;
  String? name;

  factory TypeTransportUnit.fromJson(Map<String, dynamic> json) => TypeTransportUnit(
        id: json["_id"] == null ? null : json["_id"],
        typeTransportUnitId: json["typeTransportUnitId"] == null ? null : json["typeTransportUnitId"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "typeTransportUnitId": typeTransportUnitId == null ? null : typeTransportUnitId,
        "name": name == null ? null : name,
      };
}
