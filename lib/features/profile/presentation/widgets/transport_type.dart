
import 'dart:convert';

TransportUnitType transportUnitTypeFromJson(String str) => TransportUnitType.fromJson(json.decode(str));

String transportUnitTypeToJson(TransportUnitType data) => json.encode(data.toJson());

class TransportUnitType {
  TransportUnitType({
    this.account,
    this.id,
    this.name,
    this.path,
    this.selected,
  });
  bool? selected = false;
  Account? account;
  String? id;
  String? name;
  String? path;

  factory TransportUnitType.fromJson(Map<String, dynamic> json) => TransportUnitType(
        account: json["account"] == null ? null : Account.fromJson(json["account"]),
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        selected: json["selected"] == null ? false : json["selected"],
        path: json["path"] == null ? null : json["path"],
      );

  Map<String, dynamic> toJson() => {
        "account": account == null ? null : account!.toJson(),
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "path": path == null ? null : path,
        "selected": selected == null ? null : selected,
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
