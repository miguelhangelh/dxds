// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
    CategoryModel({
        this.account,
        this.id,
        this.name,
    });

    Account? account;
    String? id;
    String? name;

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        account: json["account"] == null ? null : Account.fromJson(json["account"]),
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "account": account == null ? null : account!.toJson(),
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
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
