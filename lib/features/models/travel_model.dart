// To parse this JSON data, do
//
//     final travelModel = travelModelFromJson(jsonString);

import 'dart:convert';

import 'package:appdriver/features/models/rating_model.dart';

TravelModel travelModelFromJson(String str) => TravelModel.fromJson(json.decode(str));

String travelModelToJson(TravelModel data) => json.encode(data.toJson());

class TravelModel {
  TravelModel({
    this.code,
    this.dates,
    this.volumeUnit,
    this.weightUnit,
    this.distanceTravel,
    this.categoryLoad,
    this.boardingMode,
    this.freightValues,
    this.loadingOrder,
    this.row,
    this.id,
    this.operationId,
    this.linkApp,
    this.linkClient,
    this.initialTravel,
    this.publish,
    this.travelFms,
    this.typeTransportUnitLabel,
    this.features,
    this.travelstatus,
    this.comment,
    this.route,
    this.postulation,
    this.company,
    this.quantityTransportUnit,
    this.distanceUnit,
    this.timeUnit,
    this.rating,
    this.priceDifference,
  });
  String? code;
  Rating? rating;
  Dates? dates;
  VolumeUnit? volumeUnit;
  WeightUnit? weightUnit;
  DistanceUnit? distanceUnit;
  DistanceTravel? distanceTravel;
  TimeUnit? timeUnit;
  CategoryLoad? categoryLoad;
  BoardingMode? boardingMode;
  FreightValues? freightValues;
  LoadingOrder? loadingOrder;
  PriceDifference? priceDifference;
  Row? row;
  String? id;
  String? operationId;
  String? linkApp;
  String? linkClient;
  String? initialTravel;
  String? comment;
  bool? publish;
  bool? travelFms;
  String? typeTransportUnitLabel;
  int? quantityTransportUnit;
  List<Feature>? features;
  List<Status>? travelstatus;
  Route? route;
  List<Postulation>? postulation;
  Company? company;

  factory TravelModel.fromJson(Map<String, dynamic> json) => TravelModel(
        code: json["code"] == null ? null : json["code"],
        dates: json["dates"] == null ? null : Dates.fromJson(json["dates"]),
        volumeUnit: json["volumeUnit"] == null ? null : VolumeUnit.fromJson(json["volumeUnit"]),
        priceDifference: json["priceDifference"] == null ? null : PriceDifference.fromJson(json["priceDifference"]),
        weightUnit: json["weightUnit"] == null ? null : WeightUnit.fromJson(json["weightUnit"]),
        company: json["company"] == null ? null : Company.fromJson(json["company"]),
        distanceUnit: json["distanceUnit"] == null ? null : DistanceUnit.fromJson(json["distanceUnit"]),
        distanceTravel: json["distanceTravel"] == null ? null : DistanceTravel.fromJson(json["distanceTravel"]),
        timeUnit: json["timeUnit"] == null ? null : TimeUnit.fromJson(json["timeUnit"]),
        categoryLoad: json["categoryLoad"] == null ? null : CategoryLoad.fromJson(json["categoryLoad"]),
        boardingMode: json["boardingMode"] == null ? null : BoardingMode.fromJson(json["boardingMode"]),
        freightValues: json["freightValues"] == null ? null : FreightValues.fromJson(json["freightValues"]),
        loadingOrder: json["loadingOrder"] == null ? null : LoadingOrder.fromJson(json["loadingOrder"]),
        row: json["row"] == null ? null : Row.fromJson(json["row"]),
        id: json["_id"] == null ? null : json["_id"],
        operationId: json["operationId"] == null ? null : json["operationId"],
        linkApp: json["linkApp"] == null ? null : json["linkApp"],
        linkClient: json["linkClient"] == null ? null : json["linkClient"],
        initialTravel: json["initialTravel"] == null ? null : json["initialTravel"],
        publish: json["publish"] == null ? null : json["publish"],
        travelFms: json["travelFms"] == null ? null : json["travelFms"],
        quantityTransportUnit: json["quantityTransportUnit"] == null ? null : json["quantityTransportUnit"],
        comment: json["comment"] == null ? null : json["comment"],
        typeTransportUnitLabel: json["typeTransportUnitLabel"] == null ? null : json["typeTransportUnitLabel"],
        features: json["features"] == null ? null : List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
        travelstatus: json["travelstatus"] == null ? null : List<Status>.from(json["travelstatus"].map((x) => Status.fromJson(x))),
        route: json["route"] == null ? null : Route.fromJson(json["route"]),
        postulation: json["postulation"] == null ? null : List<Postulation>.from(json["postulation"].map((x) => Postulation.fromJson(x))),
        rating: json['rating'] == null ? null : Rating.fromJson(json['rating']),
      );

  Map<String, dynamic> toJson() => {
        "dates": dates == null ? null : dates!.toJson(),
        "volumeUnit": volumeUnit == null ? null : volumeUnit!.toJson(),
        "priceDifference": priceDifference == null ? null : priceDifference!.toJson(),
        "weightUnit": weightUnit == null ? null : weightUnit!.toJson(),
        "distanceTravel": distanceTravel == null ? null : distanceTravel!.toJson(),
        "categoryLoad": categoryLoad == null ? null : categoryLoad!.toJson(),
        "boardingMode": boardingMode == null ? null : boardingMode!.toJson(),
        "freightValues": freightValues == null ? null : freightValues!.toJson(),
        "loadingOrder": loadingOrder == null ? null : loadingOrder!.toJson(),
        "company": company == null ? null : company!.toJson(),
        "distanceUnit": distanceUnit == null ? null : distanceUnit!.toJson(),
        "timeUnit": timeUnit == null ? null : timeUnit!.toJson(),
        "comment": comment == null ? null : comment,
        "row": row == null ? null : row!.toJson(),
        "_id": id == null ? null : id,
        "operationId": operationId == null ? null : operationId,
        "linkApp": linkApp == null ? null : linkApp,
        "linkClient": linkClient == null ? null : linkClient,
        "initialTravel": initialTravel == null ? null : initialTravel,
        "publish": publish == null ? null : publish,
        "travelFms": travelFms == null ? null : travelFms,
        "quantityTransportUnit": quantityTransportUnit == null ? null : quantityTransportUnit,
        "typeTransportUnitLabel": typeTransportUnitLabel == null ? null : typeTransportUnitLabel,
        "features": features == null ? null : List<dynamic>.from(features!.map((x) => x.toJson())),
        "travelstatus": travelstatus == null ? null : List<dynamic>.from(travelstatus!.map((x) => x.toJson())),
        "route": route == null ? null : route!.toJson(),
        "postulation": postulation == null ? null : List<dynamic>.from(postulation!.map((x) => x.toJson())),
        'rating': rating == null ? null : rating!.toJson(),
      };
}

class DistanceTravel {
  DistanceTravel({
    this.name,
    this.value,
  });

  String? name;
  double? value;

  factory DistanceTravel.fromJson(Map<String, dynamic> json) => DistanceTravel(
        name: json["name"] == null ? null : json["name"],
        value: json["value"] == null ? null : json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "value": value == null ? null : value,
      };
}

class PriceDifference {
  PriceDifference({
    this.comment,
    this.freightValue,
    this.abbreviationtypeCurrency,
    this.typeCurrencyFreightIdDifference,
  });

  String? comment;
  String? abbreviationtypeCurrency;
  String? typeCurrencyFreightIdDifference;
  double? freightValue;

  factory PriceDifference.fromJson(Map<String, dynamic> json) => PriceDifference(
        comment: json["comment"] == null ? null : json["comment"],
        abbreviationtypeCurrency: json["abbreviationtypeCurrency"] == null ? null : json["abbreviationtypeCurrency"],
        typeCurrencyFreightIdDifference: json["typeCurrencyFreightIdDifference"] == null ? null : json["typeCurrencyFreightIdDifference"],
        freightValue: json["freightValue"] == null ? null : json["freightValue"],
      );

  Map<String, dynamic> toJson() => {
        "typeCurrencyFreightIdDifference": typeCurrencyFreightIdDifference == null ? null : typeCurrencyFreightIdDifference,
        "abbreviationtypeCurrency": abbreviationtypeCurrency == null ? null : abbreviationtypeCurrency,
        "comment": comment == null ? null : comment,
        "freightValue": freightValue == null ? null : freightValue,
      };
}

class DistanceUnit {
  DistanceUnit({
    this.name,
    this.value,
    this.abbreviation,
    this.distanceUnitId,
  });

  String? name;
  String? abbreviation;
  String? distanceUnitId;
  double? value;

  factory DistanceUnit.fromJson(Map<String, dynamic> json) => DistanceUnit(
        name: json["name"] == null ? null : json["name"],
        abbreviation: json["abbreviation"] == null ? null : json["abbreviation"],
        distanceUnitId: json["distanceUnitId"] == null ? null : json["distanceUnitId"],
        value: json["value"] == null ? null : json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "distanceUnitId": distanceUnitId == null ? null : distanceUnitId,
        "abbreviation": abbreviation == null ? null : abbreviation,
        "name": name == null ? null : name,
        "value": value == null ? null : value,
      };
}

class TimeUnit {
  TimeUnit({
    this.timeUnitId,
    this.name,
    this.value,
    this.abbreviation,
  });

  String? name;
  String? abbreviation;
  String? timeUnitId;
  double? value;

  factory TimeUnit.fromJson(Map<String, dynamic> json) => TimeUnit(
        name: json["name"] == null ? null : json["name"],
        timeUnitId: json["timeUnitId"] == null ? null : json["timeUnitId"],
        abbreviation: json["abbreviation"] == null ? null : json["abbreviation"],
        value: json["value"] == null ? null : json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "timeUnitId": timeUnitId == null ? null : timeUnitId,
        "name": name == null ? null : name,
        "value": value == null ? null : value,
        "abbreviation": abbreviation == null ? null : abbreviation,
      };
}

class Company {
  Company({
    this.account,
    this.fms,
    this.self,
    this.id,
    this.name,
    this.taxId,
    this.adress,
    this.country,
    this.city,
    this.postalCode,
    this.public,
    this.access,
    this.prefix,
  });

  Account? account;
  bool? fms;
  bool? self;
  String? id;
  String? name;
  String? taxId;
  String? adress;
  String? country;
  String? city;
  String? postalCode;
  bool? public;
  List<Access>? access;
  String? prefix;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        account: json["account"] == null ? null : Account.fromJson(json["account"]),
        fms: json["fms"] == null ? null : json["fms"],
        self: json["self"] == null ? null : json["self"],
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        taxId: json["taxId"] == null ? null : json["taxId"],
        adress: json["adress"] == null ? null : json["adress"],
        country: json["country"] == null ? null : json["country"],
        city: json["city"] == null ? null : json["city"],
        postalCode: json["postalCode"] == null ? null : json["postalCode"],
        public: json["public"] == null ? null : json["public"],
        access: json["access"] == null ? null : List<Access>.from(json["access"].map((x) => Access.fromJson(x))),
        prefix: json["prefix"] == null ? null : json["prefix"],
      );

  Map<String, dynamic> toJson() => {
        "account": account == null ? null : account!.toJson(),
        "fms": fms == null ? null : fms,
        "self": self == null ? null : self,
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "taxId": taxId == null ? null : taxId,
        "adress": adress == null ? null : adress,
        "country": country == null ? null : country,
        "city": city == null ? null : city,
        "postalCode": postalCode == null ? null : postalCode,
        "public": public == null ? null : public,
        "access": access == null ? null : List<dynamic>.from(access!.map((x) => x.toJson())),
        "prefix": prefix == null ? null : prefix,
      };
}

class Access {
  Access({
    this.id,
    this.modulesId,
    this.name,
    this.code,
    this.read,
    this.write,
  });

  String? id;
  String? modulesId;
  String? name;
  String? code;
  bool? read;
  bool? write;

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        id: json["_id"] == null ? null : json["_id"],
        modulesId: json["modulesId"] == null ? null : json["modulesId"],
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        read: json["read"] == null ? null : json["read"],
        write: json["write"] == null ? null : json["write"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "modulesId": modulesId == null ? null : modulesId,
        "name": name == null ? null : name,
        "code": code == null ? null : code,
        "read": read == null ? null : read,
        "write": write == null ? null : write,
      };
}

class Account {
  Account({
    this.enable,
    this.updateDate,
    this.createDate,
  });

  bool? enable;
  DateTime? updateDate;
  DateTime? createDate;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        enable: json["enable"] == null ? null : json["enable"],
        updateDate: json["updateDate"] == null ? null : DateTime.parse(json["updateDate"]),
        createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
      );

  Map<String, dynamic> toJson() => {
        "enable": enable == null ? null : enable,
        "updateDate": updateDate == null ? null : updateDate!.toIso8601String(),
        "createDate": createDate == null ? null : createDate!.toIso8601String(),
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
    this.indefiniteDate,
    this.deliveryDate,
    this.publishDate,
  });

  DateTime? loadingDate;
  DateTime? deliveryDate;
  DateTime? publishDate;
  bool? indefiniteDate;

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        loadingDate: json["loadingDate"] == null ? null : DateTime.parse(json["loadingDate"]),
        deliveryDate: json["deliveryDate"] == null ? null : DateTime.parse(json["deliveryDate"]),
        publishDate: json["publishDate"] == null ? null : DateTime.parse(json["publishDate"]),
        indefiniteDate: json["indefiniteDate"] == null ? null : json["indefiniteDate"],
      );

  Map<String, dynamic> toJson() => {
        "loadingDate": loadingDate == null ? null : loadingDate!.toIso8601String(),
        "deliveryDate": deliveryDate == null ? null : deliveryDate!.toIso8601String(),
        "publishDate": publishDate == null ? null : publishDate!.toIso8601String(),
        "indefiniteDate": indefiniteDate == null ? null : indefiniteDate,
      };
}

class Feature {
  Feature({
    this.id,
    this.featuresTransportUnitId,
    this.name,
    this.valueQualitative,
    this.valueQuantitative,
  });

  String? id;
  String? featuresTransportUnitId;
  String? name;
  String? valueQualitative;
  int? valueQuantitative;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["_id"] == null ? null : json["_id"],
        featuresTransportUnitId: json["featuresTransportUnitId"] == null ? null : json["featuresTransportUnitId"],
        name: json["name"] == null ? null : json["name"],
        valueQualitative: json["valueQualitative"] == null ? null : json["valueQualitative"],
        valueQuantitative: json["valueQuantitative"] == null ? null : json["valueQuantitative"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "featuresTransportUnitId": featuresTransportUnitId == null ? null : featuresTransportUnitId,
        "name": name == null ? null : name,
        "valueQualitative": valueQualitative == null ? null : valueQualitative,
        "valueQuantitative": valueQuantitative == null ? null : valueQuantitative,
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
    this.distanceUnit,
    this.timeUnit,
    this.weightUnit,
    this.volumeUnit,
    this.packaging,
    this.loadingOrderStatus,
    this.loadingOrderId,
  });

  CarrierFreight? carrierFreight;
  DatesDone? datesDone;
  OriginDone? originDone;
  DestinationDone? destinationDone;
  Assignment? assignment;
  List<Status>? loadingOrderStatus;
  DistanceUnit? distanceUnit;
  WeightUnit? weightUnit;
  VolumeUnit? volumeUnit;
  TimeUnit? timeUnit;
  String? packaging;
  String? loadingOrderId;

  factory LoadingOrder.fromJson(Map<String, dynamic> json) => LoadingOrder(
        carrierFreight: json["carrierFreight"] == null ? null : CarrierFreight.fromJson(json["carrierFreight"]),
        datesDone: json["datesDone"] == null ? null : DatesDone.fromJson(json["datesDone"]),
        originDone: json["originDone"] == null ? null : OriginDone.fromJson(json["originDone"]),
        destinationDone: json["destinationDone"] == null ? null : DestinationDone.fromJson(json["destinationDone"]),
        assignment: json["assignment"] == null ? null : Assignment.fromJson(json["assignment"]),
        distanceUnit: json["distanceUnit"] == null ? null : DistanceUnit.fromJson(json["distanceUnit"]),
        timeUnit: json["timeUnit"] == null ? null : TimeUnit.fromJson(json["timeUnit"]),
        weightUnit: json["weightUnit"] == null ? null : WeightUnit.fromJson(json["weightUnit"]),
        volumeUnit: json["VolumeUnit"] == null ? null : VolumeUnit.fromJson(json["VolumeUnit"]),
        packaging: json["packaging"] == null ? null : json["packaging"],
        loadingOrderStatus: json["LoadingOrderStatus"] == null ? null : List<Status>.from(json["LoadingOrderStatus"].map((x) => Status.fromJson(x))),
        loadingOrderId: json["loadingOrderId"] == null ? null : json["loadingOrderId"],
      );

  Map<String, dynamic> toJson() => {
        "carrierFreight": carrierFreight == null ? null : carrierFreight!.toJson(),
        "datesDone": datesDone == null ? null : datesDone!.toJson(),
        "originDone": originDone == null ? null : originDone!.toJson(),
        "destinationDone": destinationDone == null ? null : destinationDone!.toJson(),
        "assignment": assignment == null ? null : assignment!.toJson(),
        "distanceUnit": distanceUnit == null ? null : distanceUnit!.toJson(),
        "timeUnit": timeUnit == null ? null : timeUnit!.toJson(),
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

class OriginDone {
  OriginDone({
    this.lat,
    this.lng,
  });

  int? lat;
  int? lng;

  factory OriginDone.fromJson(Map<String, dynamic> json) => OriginDone(
        lat: json["lat"] == null ? null : json["lat"],
        lng: json["lng"] == null ? null : json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
      };
}

class DestinationDone {
  DestinationDone({
    this.lat,
    this.lng,
  });

  int? lat;
  int? lng;

  factory DestinationDone.fromJson(Map<String, dynamic> json) => DestinationDone(
        lat: json["lat"] == null ? null : json["lat"],
        lng: json["lng"] == null ? null : json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
      };
}

class DatesDone {
  DatesDone({
    this.loadingDate,
    this.deliveryDate,
  });

  DateTime? loadingDate;
  DateTime? deliveryDate;

  factory DatesDone.fromJson(Map<String, dynamic> json) => DatesDone(
        loadingDate: json["loadingDate"] == null ? null : DateTime.parse(json["loadingDate"]),
        deliveryDate: json["deliveryDate"] == null ? null : DateTime.parse(json["deliveryDate"]),
      );

  Map<String, dynamic> toJson() => {
        "loadingDate": loadingDate == null ? null : loadingDate!.toIso8601String(),
        "deliveryDate": deliveryDate == null ? null : deliveryDate!.toIso8601String(),
      };
}

class Status {
  Status({
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

  factory Status.fromJson(Map<String, dynamic> json) => Status(
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

class VolumeUnit {
  VolumeUnit({
    this.volumeUnitId,
    this.name,
    this.abbreviation,
    this.value,
  });

  String? volumeUnitId;
  String? name;
  String? abbreviation;
  double? value;

  factory VolumeUnit.fromJson(Map<String, dynamic> json) => VolumeUnit(
        volumeUnitId: json["volumeUnitId"] == null ? null : json["volumeUnitId"],
        name: json["name"] == null ? null : json["name"],
        abbreviation: json["abbreviation"] == null ? null : json["abbreviation"],
        value: json["value"] == null ? null : json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "VolumeUnitId": volumeUnitId == null ? null : volumeUnitId,
        "name": name == null ? null : name,
        "abbreviation": abbreviation == null ? null : abbreviation,
        "value": value == null ? null : value,
      };
}

class WeightUnit {
  WeightUnit({
    this.weightUnitId,
    this.name,
    this.abbreviation,
    this.value,
  });

  String? weightUnitId;
  String? name;
  String? abbreviation;
  double? value;

  factory WeightUnit.fromJson(Map<String, dynamic> json) => WeightUnit(
        weightUnitId: json["weightUnitId"] == null ? null : json["weightUnitId"],
        name: json["name"] == null ? null : json["name"],
        abbreviation: json["abbreviation"] == null ? null : json["abbreviation"],
        value: json["value"] == null ? null : json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "weightUnitId": weightUnitId == null ? null : weightUnitId,
        "name": name == null ? null : name,
        "abbreviation": abbreviation == null ? null : abbreviation,
        "value": value == null ? null : value,
      };
}

class Postulation {
  Postulation({
    this.id,
    this.travelId,
    this.freightValue,
    this.freightValueOperator,
    this.abbreviationTypeCurrencyOperator,
    this.abbreviationUnitOperator,
    this.typeUnitMeasurementOperator,
    this.typeCurrencyFreightId,
    this.transportUnitId,
    this.invoice,
    this.invoiceOperator,
    this.postulateDate,
    this.acceptedDate,
    this.confirmedDate,
    this.cancelledDate,
    this.rejectDate,
    this.declineDate,
    this.commentReject,
    this.abbreviationTypeCurrency,
    this.typeMeasurementUnit,
    this.abbreviationUnit,
    this.typeUnitMeasurement,
  });

  String? id;
  String? travelId;
  double? freightValue;
  String? typeCurrencyFreightId;
  double? freightValueOperator;

  String? abbreviationTypeCurrencyOperator;
  String? abbreviationUnitOperator;
  String? typeUnitMeasurementOperator;

  String? transportUnitId;
  bool? invoice;
  bool? invoiceOperator;

  DateTime? postulateDate;
  DateTime? acceptedDate;
  DateTime? confirmedDate;
  DateTime? cancelledDate;
  DateTime? declineDate;
  DateTime? rejectDate;
  String? commentReject;

  String? abbreviationTypeCurrency;
  String? typeMeasurementUnit;
  String? abbreviationUnit;
  String? typeUnitMeasurement;

  factory Postulation.fromJson(Map<String, dynamic> json) => Postulation(
        id: json["_id"] == null ? null : json["_id"],
        travelId: json["travelId"] == null ? null : json["travelId"],
        freightValue: json["freightValue"] == null ? null : json["freightValue"].toDouble(),
        freightValueOperator: json["freightValueOperator"] == null ? null : json["freightValueOperator"].toDouble(),
        abbreviationTypeCurrencyOperator:
            json["abbreviationTypeCurrencyOperator"] == null ? null : json["abbreviationTypeCurrencyOperator"],
        abbreviationUnitOperator: json["abbreviationUnitOperator"] == null ? null : json["abbreviationUnitOperator"],
        typeUnitMeasurementOperator: json["typeUnitMeasurementOperator"] == null ? null : json["typeUnitMeasurementOperator"],
        typeCurrencyFreightId: json["typeCurrencyFreightId"] == null ? null : json["typeCurrencyFreightId"],
        transportUnitId: json["transportUnitId"] == null ? null : json["transportUnitId"],
        invoice: json["invoice"] == null ? null : json["invoice"],
        invoiceOperator: json["invoiceOperator"] == null ? null : json["invoiceOperator"],
        abbreviationTypeCurrency: json["abbreviationTypeCurrency"] == null ? null : json["abbreviationTypeCurrency"],
        typeMeasurementUnit: json["typeMeasurementUnit"] == null ? null : json["typeMeasurementUnit"],
        abbreviationUnit: json["abbreviationUnit"] == null ? null : json["abbreviationUnit"],
        typeUnitMeasurement: json["typeUnitMeasurement"] == null ? null : json["typeUnitMeasurement"],
        postulateDate: json["postulateDate"] == null ? null : DateTime.parse(json["postulateDate"]),
        acceptedDate: json["acceptedDate"] == null ? null : DateTime.parse(json["acceptedDate"]),
        confirmedDate: json["confirmedDate"] == null ? null : DateTime.parse(json["confirmedDate"]),
        cancelledDate: json["cancelledDate"] == null ? null : DateTime.parse(json["cancelledDate"]),
        declineDate: json["declineDate"] == null ? null : DateTime.parse(json["declineDate"]),
        rejectDate: json["rejectDate"] == null ? null : DateTime.parse(json["rejectDate"]),
        commentReject: json["commentReject"] == null ? null : json["commentReject"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "travelId": travelId == null ? null : travelId,
        "freightValue": freightValue == null ? null : freightValue,
        "freightValueOperator": freightValueOperator == null ? null : freightValueOperator,
        "abbreviationTypeCurrencyOperator": abbreviationTypeCurrencyOperator == null ? null : abbreviationTypeCurrencyOperator,
        "abbreviationUnitOperator": abbreviationUnitOperator == null ? null : abbreviationUnitOperator,
        "typeUnitMeasurementOperator": typeUnitMeasurementOperator == null ? null : typeUnitMeasurementOperator,
        "invoiceOperator": invoiceOperator == null ? null : invoiceOperator,
        "typeCurrencyFreightId": typeCurrencyFreightId == null ? null : typeCurrencyFreightId,
        "transportUnitId": transportUnitId == null ? null : transportUnitId,
        "invoice": invoice == null ? null : invoice,
        "abbreviationTypeCurrency": abbreviationTypeCurrency == null ? null : abbreviationTypeCurrency,
        "typeMeasurementUnit": typeMeasurementUnit == null ? null : typeMeasurementUnit,
        "abbreviationUnit": abbreviationUnit == null ? null : abbreviationUnit,
        "typeUnitMeasurement": typeUnitMeasurement == null ? null : typeUnitMeasurement,
        "postulateDate": postulateDate == null ? null : postulateDate!.toIso8601String(),
        "acceptedDate": acceptedDate == null ? null : acceptedDate!.toIso8601String(),
        "confirmedDate": confirmedDate == null ? null : confirmedDate!.toIso8601String(),
        "cancelledDate": cancelledDate == null ? null : cancelledDate!.toIso8601String(),
        "declineDate": declineDate == null ? null : declineDate!.toIso8601String(),
        "rejectDate": rejectDate == null ? null : rejectDate!.toIso8601String(),
        "commentReject": commentReject == null ? null : commentReject,
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
        checkPoints: json["checkPoints"] == null ? null : List<CheckPoint>.from(json["checkPoints"].map((x) => CheckPoint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "origin": origin == null ? null : origin!.toJson(),
        "destination": destination == null ? null : destination!.toJson(),
        "_id": id == null ? null : id,
        "checkPoints": checkPoints == null ? null : List<dynamic>.from(checkPoints!.map((x) => x.toJson())),
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
    this.cityDestinationId,
    this.cityDestination,
    this.directionDestination,
  });

  String? placeId;
  String? countryDestination;
  String? cityDestinationId;
  String? cityDestination;
  String? directionDestination;

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        placeId: json["PlaceId"] == null ? null : json["PlaceId"],
        countryDestination: json["countryDestination"] == null ? null : json["countryDestination"],
        cityDestinationId: json["cityDestinationId"] == null ? null : json["cityDestinationId"],
        cityDestination: json["cityDestination"] == null ? null : json["cityDestination"],
        directionDestination: json["directionDestination"] == null ? null : json["directionDestination"],
      );

  Map<String, dynamic> toJson() => {
        "PlaceId": placeId == null ? null : placeId,
        "countryDestination": countryDestination == null ? null : countryDestination,
        "cityDestinationId": cityDestinationId == null ? null : cityDestinationId,
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
    this.cityOriginId,
  });

  String? placeId;
  String? cityOriginId;
  String? countryOrigin;
  String? cityOrigin;
  String? direction;

  factory Origin.fromJson(Map<String, dynamic> json) => Origin(
        placeId: json["PlaceId"] == null ? null : json["PlaceId"],
        cityOriginId: json["cityOriginId"] == null ? null : json["cityOriginId"],
        countryOrigin: json["countryOrigin"] == null ? null : json["countryOrigin"],
        cityOrigin: json["cityOrigin"] == null ? null : json["cityOrigin"],
        direction: json["direction"] == null ? null : json["direction"],
      );

  Map<String, dynamic> toJson() => {
        "PlaceId": placeId == null ? null : placeId,
        "cityOriginId": cityOriginId == null ? null : cityOriginId,
        "countryOrigin": countryOrigin == null ? null : countryOrigin,
        "cityOrigin": cityOrigin == null ? null : cityOrigin,
        "direction": direction == null ? null : direction,
      };
}

class Row {
  Row({
    this.createDate,
    this.updateDate,
    this.disableDate,
    this.createOperatorId,
    this.updateOperatorId,
    this.disableOperatorId,
  });

  DateTime? createDate;
  DateTime? updateDate;
  DateTime? disableDate;
  String? createOperatorId;
  String? updateOperatorId;
  String? disableOperatorId;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
        updateDate: json["updateDate"] == null ? null : DateTime.parse(json["updateDate"]),
        disableDate: json["disableDate"] == null ? null : DateTime.parse(json["disableDate"]),
        createOperatorId: json["createOperatorId"] == null ? null : json["createOperatorId"],
        updateOperatorId: json["updateOperatorId"] == null ? null : json["updateOperatorId"],
        disableOperatorId: json["disableOperatorId"] == null ? null : json["disableOperatorId"],
      );

  Map<String, dynamic> toJson() => {
        "createDate": createDate == null ? null : createDate!.toIso8601String(),
        "updateDate": updateDate == null ? null : updateDate!.toIso8601String(),
        "disableDate": disableDate == null ? null : disableDate!.toIso8601String(),
        "createOperatorId": createOperatorId == null ? null : createOperatorId,
        "updateOperatorId": updateOperatorId == null ? null : updateOperatorId,
        "disableOperatorId": disableOperatorId == null ? null : disableOperatorId,
      };
}
