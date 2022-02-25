// To parse this JSON data, do
//
//     final newModel = newModelFromJson(jsonString);

import 'dart:convert';

NewModel newModelFromJson(String str) => NewModel.fromJson(json.decode(str));

String newModelToJson(NewModel data) => json.encode(data.toJson());

class NewModel {
  NewModel({
    this.account,
    this.id,
    this.name,
    this.description,
    this.path,
    this.link,
    this.order,
  });

  Account? account;
  String? id;
  String? name;
  String? description;
  String? path;
  String? link;
  int? order;

  factory NewModel.fromJson(Map<String, dynamic> json) => NewModel(
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
    id: json["_id"] == null ? null : json["_id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    path: json["path"] == null ? null : json["path"],
    link: json["link"] == null ? null : json["link"],
    order: json["order"] == null ? null : json["order"],
  );

  Map<String, dynamic> toJson() => {
    "account": account == null ? null : account!.toJson(),
    "_id": id == null ? null : id,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "path": path == null ? null : path,
    "link": link == null ? null : link,
    "order": order == null ? null : order,
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
