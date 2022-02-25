// To parse this JSON data, do
//
//     final exchangeRate = exchangeRateFromJson(jsonString);

import 'dart:convert';

ExchangeRate exchangeRateFromJson(String str) => ExchangeRate.fromJson(json.decode(str));

String exchangeRateToJson(ExchangeRate data) => json.encode(data.toJson());

class ExchangeRate {
  ExchangeRate({
    this.account,
    this.id,
    this.name,
    this.typeMeasurementUnit,
    this.abbreviationUnit,
    this.values =const [],
    this.companyId,
  });

  final Account? account;
  final String? id;
  final String? name;
  final String? typeMeasurementUnit;
  final String? abbreviationUnit;
  final List<Value>? values;
  final String? companyId;

  factory ExchangeRate.fromJson(Map<String, dynamic> json) => ExchangeRate(
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
    id: json["_id"] == null ? null : json["_id"],
    name: json["name"] == null ? null : json["name"],
    typeMeasurementUnit: json["typeMeasurementUnit"] == null ? null : json["typeMeasurementUnit"],
    abbreviationUnit: json["abbreviationUnit"] == null ? null : json["abbreviationUnit"],
    values: json["values"] == null ? [] : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
    companyId: json["companyId"] == null ? null : json["companyId"],
  );

  Map<String, dynamic> toJson() => {
    "account": account == null ? null : account!.toJson(),
    "_id": id == null ? null : id,
    "name": name == null ? null : name,
    "typeMeasurementUnit": typeMeasurementUnit == null ? null : typeMeasurementUnit,
    "abbreviationUnit": abbreviationUnit == null ? null : abbreviationUnit,
    "values": values == null ? null : List<dynamic>.from(values!.map((x) => x.toJson())),
    "companyId": companyId == null ? null : companyId,
  };
}

class Account {
  Account({
    this.enable,
    this.createDate,
  });

  final bool? enable;
  final DateTime? createDate;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    enable: json["enable"] == null ? null : json["enable"],
    createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
  );

  Map<String, dynamic> toJson() => {
    "enable": enable == null ? null : enable,
    "createDate": createDate == null ? null : createDate!.toIso8601String(),
  };
}

class Value {
  Value({
    this.id,
    this.value,
    this.initialDate,
    this.endDate,
  });

  final String? id;
  final double? value;
  final DateTime? initialDate;
  final DateTime? endDate;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    id: json["_id"] == null ? null : json["_id"],
    value: json["value"] == null ? null : json["value"].toDouble(),
    initialDate: json["initialDate"] == null ? null : DateTime.parse(json["initialDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "value": value == null ? null : value,
    "initialDate": initialDate == null ? null : initialDate!.toIso8601String(),
    "endDate": endDate == null ? null : endDate!.toIso8601String(),
  };
}
