// To parse this JSON data, do
//
//     final postulationRequest = postulationRequestFromJson(jsonString);

import 'dart:convert';

PostulationRequest postulationRequestFromJson(String str) => PostulationRequest.fromJson(json.decode(str));

String postulationRequestToJson(PostulationRequest data) => json.encode(data.toJson());

class PostulationRequest {
  PostulationRequest({
    this.message,
    this.postulation,
  });

  String? message;
  Postulation? postulation;

  factory PostulationRequest.fromJson(Map<String, dynamic> json) => PostulationRequest(
        message: json["message"] == null ? null : json["message"],
        postulation: json["postulation"] == null ? null : Postulation.fromJson(json["postulation"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "postulation": postulation == null ? null : postulation!.toJson(),
      };
}

class Postulation {
  Postulation({
    this.id,
    this.travelId,
    this.freightValue,
    this.typeCurrencyFreightId,
    this.transportUnitId,
    this.invoice,
    this.postulateDate,
    this.cancelledDate,
    this.confirmedDate,
    this.acceptedDate,
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
  String? transportUnitId;
  bool? invoice;
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
        typeCurrencyFreightId: json["typeCurrencyFreightId"] == null ? null : json["typeCurrencyFreightId"],
        transportUnitId: json["transportUnitId"] == null ? null : json["transportUnitId"],
        abbreviationTypeCurrency: json["abbreviationTypeCurrency"] == null ? null : json["abbreviationTypeCurrency"],
        typeMeasurementUnit: json["typeMeasurementUnit"] == null ? null : json["typeMeasurementUnit"],
        abbreviationUnit: json["abbreviationUnit"] == null ? null : json["abbreviationUnit"],
        typeUnitMeasurement: json["typeUnitMeasurement"] == null ? null : json["typeUnitMeasurement"],

        invoice: json["invoice"] == null ? null : json["invoice"],
        postulateDate: json["postulateDate"] == null ? null : DateTime.parse(json["postulateDate"]),
        acceptedDate: json["acceptedDate"] == null ? null : DateTime.parse(json["acceptedDate"]),
        confirmedDate: json["confirmedDate"] == null ? null : DateTime.parse(json["confirmedDate"]),
        cancelledDate: json["cancelledDate"] == null ? null : DateTime.parse(json["cancelledDate"]),
        rejectDate: json["rejectDate"] == null ? null : DateTime.parse(json["rejectDate"]),
        declineDate: json["declineDate"] == null ? null : DateTime.parse(json["declineDate"]),
        commentReject: json["commentReject"] == null ? null : json["commentReject"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "travelId": travelId == null ? null : travelId,
        "freightValue": freightValue == null ? null : freightValue,
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
        "rejectDate": rejectDate == null ? null : rejectDate!.toIso8601String(),
        "declineDate": declineDate == null ? null : declineDate!.toIso8601String(),
        "commentReject": commentReject == null ? null : commentReject,
      };
}
