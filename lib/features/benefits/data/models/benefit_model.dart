// To parse this JSON data, do
//
//     final benefitModel = benefitModelFromJson(jsonString);

import 'dart:convert';


BenefitModel benefitModelFromJson(String str) => BenefitModel.fromJson(json.decode(str));

String benefitModelToJson(BenefitModel data) => json.encode(data.toJson());

class BenefitModel {
  BenefitModel({
    this.account,
    this.id,
    this.name,
    this.description,
    this.path,
    this.phone,
    this.order,
    this.percentage,
    this.price,
  });
  String? phone;
  Account? account;
  String? id;
  String? name;
  String? description;
  String? path;
  int? order;
  double? percentage;
  double? price;

  factory BenefitModel.fromJson(Map<String, dynamic> json) => BenefitModel(
        account: json["account"] == null ? null : Account.fromJson(json["account"]),
        id: json["_id"] == null ? null : json["_id"],
        phone: json["phone"] == null ? null : json["phone"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        path: json["path"] == null ? null : json["path"],
        order: json["order"] == null ? null : json["order"],
        percentage: json["percentage"] == null ? null : json["percentage"].toDouble(),
        price: json["price"] == null ? null : json["price"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "account": account == null ? null : account!.toJson(),
        "_id": id == null ? null : id,
        "phone": phone == null ? null : phone,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "path": path == null ? null : path,
        "order": order == null ? null : order,
        "percentage": percentage == null ? null : percentage,
        "price": price == null ? null : price,
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
