// To parse this JSON data, do
//
//     final transportUnitModel = transportUnitModelFromJson(jsonString);

import 'dart:convert';

TransportUnitModel transportUnitModelFromJson(String str) => TransportUnitModel.fromJson(json.decode(str));

String transportUnitModelToJson(TransportUnitModel data) => json.encode(data.toJson());

class TransportUnitModel {
  TransportUnitModel({
    this.transportUnitId,
    this.plate,
    this.advancePercentage,
    this.owner,
    this.country,
    this.color,
    this.year,
    this.typeTransportUnit,
    this.brandId,
    this.brand,
    this.features,
    this.id,
    this.engine,
    this.drivers,
    this.resources,
    this.companyGps,
    this.row,
  });

  String? transportUnitId;
  String? plate;
  double? advancePercentage;
  List<Driver>? owner;
  String? country;
  String? color;
  String? year;
  String? typeTransportUnit;
  String? brandId;
  String? brand;
  String? companyGps;
  List<Feature>? features;
  String? id;
  Engine? engine;
  List<Driver>? drivers;
  Resources? resources;
  Row? row;

  factory TransportUnitModel.fromJson(Map<String, dynamic> json) => TransportUnitModel(
        transportUnitId: json["transportUnitId"] == null ? null : json["transportUnitId"],
        plate: json["plate"] == null ? null : json["plate"],
        advancePercentage: json["advancePercentage"] == null ? 0.0 : json["advancePercentage"].toDouble(),
        owner: json["owner"] == null ? null : List<Driver>.from(json["owner"].map((x) => Driver.fromJson(x))),
        country: json["country"] == null ? null : json["country"],
        color: json["color"] == null ? null : json["color"],
        year: json["year"] == null ? null : json["year"],
        companyGps: json["companyGps"] == null ? null : json["companyGps"],
        typeTransportUnit: json["typeTransportUnit"] == null ? null : json["typeTransportUnit"],
        brandId: json["brandId"] == null ? null : json["brandId"],
        brand: json["brand"] == null ? null : json["brand"],
        features: json["features"] == null ? null : List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
        id: json["_id"] == null ? null : json["_id"],
        engine: json["engine"] == null ? null : Engine.fromJson(json["engine"]),
        drivers: json["drivers"] == null ? null : List<Driver>.from(json["drivers"].map((x) => Driver.fromJson(x))),
        resources: json["resources"] == null ? null : Resources.fromJson(json["resources"]),
        row: json["row"] == null ? null : Row.fromJson(json["row"]),
      );

  Map<String, dynamic> toJson() => {
        "transportUnitId": transportUnitId == null ? null : transportUnitId,
        "plate": plate == null ? null : plate,
        "companyGps": companyGps == null ? null : companyGps,
        "advancePercentage": advancePercentage == null ? null : advancePercentage,
        "owner": owner == null ? null : List<dynamic>.from(owner!.map((x) => x.toJson())),
        "country": country == null ? null : country,
        "color": color == null ? null : color,
        "year": year == null ? null : year,
        "typeTransportUnit": typeTransportUnit == null ? null : typeTransportUnit,
        "brandId": brandId == null ? null : brandId,
        "brand": brand == null ? null : brand,
        "features": features == null ? null : List<dynamic>.from(features!.map((x) => x.toJson())),
        "_id": id == null ? null : id,
        "engine": engine == null ? null : engine!.toJson(),
        "drivers": drivers == null ? null : List<dynamic>.from(drivers!.map((x) => x.toJson())),
        "resources": resources == null ? null : resources!.toJson(),
        "row": row == null ? null : row!.toJson(),
      };
}

class Driver {
  Driver({
    this.userId,
    this.assignationDate,
    this.active,
    this.ratings,
    this.companyId,
  });

  String? userId;
  String? assignationDate;
  bool? active;
  List<Rating>? ratings;
  String? companyId;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        userId: json["userId"] == null ? null : json["userId"],
        assignationDate: json["assignationDate"] == null ? null : json["assignationDate"],
        active: json["active"] == null ? null : json["active"],
        ratings: json["ratings"] == null ? null : List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
        companyId: json["companyId"] == null ? null : json["companyId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId == null ? null : userId,
        "assignationDate": assignationDate == null ? null : assignationDate,
        "active": active == null ? null : active,
        "ratings": ratings == null ? null : List<dynamic>.from(ratings!.map((x) => x.toJson())),
        "companyId": companyId == null ? null : companyId,
      };
}

class Rating {
  Rating({
    this.loadingOrderId,
    this.value,
    this.comment,
    this.date,
    this.userId,
  });

  String? loadingOrderId;
  int? value;
  String? comment;
  DateTime? date;
  String? userId;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        loadingOrderId: json["loadingOrderId"] == null ? null : json["loadingOrderId"],
        value: json["value"] == null ? null : json["value"],
        comment: json["comment"] == null ? null : json["comment"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        userId: json["userId"] == null ? null : json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "loadingOrderId": loadingOrderId == null ? null : loadingOrderId,
        "value": value == null ? null : value,
        "comment": comment == null ? null : comment,
        "date": date == null ? null : date!.toIso8601String(),
        "userId": userId == null ? null : userId,
      };
}

class Engine {
  Engine({
    this.engine,
    this.fuelType,
  });

  String? engine;
  String? fuelType;

  factory Engine.fromJson(Map<String, dynamic> json) => Engine(
        engine: json["engine"] == null ? null : json["engine"],
        fuelType: json["fuelType"] == null ? null : json["fuelType"],
      );

  Map<String, dynamic> toJson() => {
        "engine": engine == null ? null : engine,
        "fuelType": fuelType == null ? null : fuelType,
      };
}

class Feature {
  Feature({
    this.id,
    this.featuresTransportUnitId,
    this.name,
    this.valueQuantitative,
    this.valueQualitative,
  });

  String? featuresTransportUnitId;
  String? name;
  int? valueQuantitative;
  String? valueQualitative;
  String? id;
  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["_id"] == null ? null : json["_id"],
        featuresTransportUnitId: json["featuresTransportUnitId"] == null ? null : json["featuresTransportUnitId"],
        name: json["name"] == null ? null : json["name"],
        valueQuantitative: json["valueQuantitative"] == null ? null : json["valueQuantitative"],
        valueQualitative: json["valueQualitative"] == null ? null : json["valueQualitative"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "featuresTransportUnitId": featuresTransportUnitId == null ? null : featuresTransportUnitId,
        "name": name == null ? null : name,
        "valueQuantitative": valueQuantitative == null ? null : valueQuantitative,
        "valueQualitative": valueQualitative == null ? null : valueQualitative,
      };
}

class Resources {
  Resources({
    this.photo,
    this.photoRuat,
    this.photoPolicy,
  });

  List<Photo>? photo;
  String? photoRuat;
  String? photoPolicy;

  factory Resources.fromJson(Map<String, dynamic> json) => Resources(
        photo: json["photo"] == null ? null : List<Photo>.from(json["photo"].map((x) => Photo.fromJson(x))),
        photoRuat: json["photoRuat"] == null ? null : json["photoRuat"],
        photoPolicy: json["photoPolicy"] == null ? null : json["photoPolicy"],
      );

  Map<String, dynamic> toJson() => {
        "photo": photo == null ? null : List<dynamic>.from(photo!.map((x) => x.toJson())),
        "photoRuat": photoRuat == null ? null : photoRuat,
        "photoPolicy": photoPolicy == null ? null : photoPolicy,
      };
}

class Photo {
  Photo({
    this.id,
    this.path,
  });
  String? id;
  String? path;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        path: json["path"] == null ? null : json["path"],
        id: json["_id"] == null ? null : json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "path": path == null ? null : path,
        "_id": id == null ? null : id,
      };
}

class Row {
  Row({
    this.createDate,
    this.updateDate,
    this.disableDate,
  });

  DateTime? createDate;
  DateTime? updateDate;
  DateTime? disableDate;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
        updateDate: json["updateDate"] == null ? null : DateTime.parse(json["updateDate"]),
        disableDate: json["disableDate"] == null ? null : DateTime.parse(json["disableDate"]),
      );

  Map<String, dynamic> toJson() => {
        "createDate": createDate == null ? null : createDate!.toIso8601String(),
        "updateDate": updateDate == null ? null : updateDate!.toIso8601String(),
        "disableDate": disableDate == null ? null : disableDate!.toIso8601String(),
      };
}
