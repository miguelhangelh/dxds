// To parse this JSON data, do
//
//     final brandModel = brandModelFromJson(jsonString);

import 'dart:convert';

BrandModel brandModelFromJson(String str) => BrandModel.fromJson(json.decode(str));

String brandModelToJson(BrandModel data) => json.encode(data.toJson());

class BrandModel {
  BrandModel({
    this.account,
    this.id,
    this.brand,
  });

  Account? account;
  String? id;
  String? brand;

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
    id: json["_id"] == null ? null : json["_id"],
    brand: json["brand"] == null ? null : json["brand"],
  );

  Map<String, dynamic> toJson() => {
    "account": account == null ? null : account!.toJson(),
    "_id": id == null ? null : id,
    "brand": brand == null ? null : brand,
  };
}

class Account {
  Account({
    this.enable,
    this.createDate,
  });

  bool? enable;
  DateTime? createDate;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    enable: json["enable"] == null ? null : json["enable"],
    createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
  );

  Map<String, dynamic> toJson() => {
    "enable": enable == null ? null : enable,
    "createDate": createDate == null ? null : createDate!.toIso8601String(),
  };
}
