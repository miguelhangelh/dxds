// To parse this JSON data, do
//
//     final operationsPastModel = operationsPastModelFromJson(jsonString);

import 'dart:convert';

import 'package:appdriver/features/models/travel_model.dart';

TravelsPastModel operationsPastModelFromJson(String str) => TravelsPastModel.fromJson(json.decode(str));

String operationsPastModelToJson(TravelsPastModel data) => json.encode(data.toJson());

class TravelsPastModel {
  TravelsPastModel({
    this.futureTravel,
    this.currentTravel,
    this.travelsPast,
  });

  TravelModel? futureTravel;
  TravelModel? currentTravel;
  List<TravelModel>? travelsPast;

  factory TravelsPastModel.fromJson(Map<String, dynamic> json) => TravelsPastModel(
        futureTravel: (json["futureTravel"]?.length == 0 || json["futureTravel"] == null) ? null : TravelModel.fromJson(json["futureTravel"]),
        currentTravel: (json["currentTravel"]?.length == 0 || json["currentTravel"] == null) ? null : TravelModel.fromJson(json["currentTravel"]),
        travelsPast: json["travelsPast"] == null ? [] :  List<TravelModel>.from(json["travelsPast"].map((x) => TravelModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "futureTravel": futureTravel == null ? null : futureTravel!.toJson(),
        "currentTravel": currentTravel == null ? null : currentTravel!.toJson(),
        "travelsPast": travelsPast == null ? [] : List<dynamic>.from(travelsPast!.map((x) => x.toJson())),
      };
}
