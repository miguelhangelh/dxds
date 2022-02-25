// To parse this JSON data, do
//
//     final ratingModel = ratingModelFromJson(jsonString);

import 'dart:convert';

RatingModel ratingModelFromJson(String str) => RatingModel.fromJson(json.decode(str));

String ratingModelToJson(RatingModel data) => json.encode(data.toJson());

class RatingModel {
  RatingModel({
    this.totalPage,
    this.average,
    this.percentageFive,
    this.percentageFour,
    this.percentageThree,
    this.percentageTwo,
    this.percentageOne,
    this.ratings,
  });

  final int? totalPage;
  final double? average;
  final String? percentageFive;
  final String? percentageFour;
  final String? percentageThree;
  final String? percentageTwo;
  final String? percentageOne;
  final List<Rating>? ratings;

  RatingModel copyWith({
    int? totalPage,
    double? average,
    String? percentageFive,
    String? percentageFour,
    String? percentageThree,
    String? percentageTwo,
    String? percentageOne,
    List<Rating>? ratings,
  }) =>
      RatingModel(
        totalPage: totalPage ?? this.totalPage,
        average: average ?? this.average,
        percentageFive: percentageFive ?? this.percentageFive,
        percentageFour: percentageFour ?? this.percentageFour,
        percentageThree: percentageThree ?? this.percentageThree,
        percentageTwo: percentageTwo ?? this.percentageTwo,
        percentageOne: percentageOne ?? this.percentageOne,
        ratings: ratings ?? this.ratings,
      );

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
    totalPage: json["totalPage"] == null ? null : json["totalPage"],
    average: json["average"] == null ? null : json["average"].toDouble(),
    percentageFive: json["percentageFive"] == null ? null : json["percentageFive"],
    percentageFour: json["percentageFour"] == null ? null : json["percentageFour"],
    percentageThree: json["percentageThree"] == null ? null : json["percentageThree"],
    percentageTwo: json["percentageTwo"] == null ? null : json["percentageTwo"],
    percentageOne: json["percentageOne"] == null ? null : json["percentageOne"],
    ratings: json["ratings"] == null ? [] : List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "totalPage": totalPage == null ? null : totalPage,
    "average": average == null ? null : average,
    "percentageFive": percentageFive == null ? null : percentageFive,
    "percentageFour": percentageFour == null ? null : percentageFour,
    "percentageThree": percentageThree == null ? null : percentageThree,
    "percentageTwo": percentageTwo == null ? null : percentageTwo,
    "percentageOne": percentageOne == null ? null : percentageOne,
    "ratings": ratings == null ? [] : List<dynamic>.from(ratings!.map((x) => x.toJson())),
  };
}

class Rating {
  Rating({
    this.account,
    this.id,
    this.travelId,
    this.userId,
    this.value,
    this.commentary,
  });

  final Account? account;
  final String? id;
  final String? travelId;
  final String? userId;
  final int? value;
  final String? commentary;

  Rating copyWith({
    Account? account,
    String? id,
    String? travelId,
    String? userId,
    int? value,
    String? commentary,
  }) =>
      Rating(
        account: account ?? this.account,
        id: id ?? this.id,
        travelId: travelId ?? this.travelId,
        userId: userId ?? this.userId,
        value: value ?? this.value,
        commentary: commentary ?? this.commentary,
      );

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
    id: json["_id"] == null ? null : json["_id"],
    travelId: json["travelId"] == null ? null : json["travelId"],
    userId: json["userId"] == null ? null : json["userId"],
    value: json["value"] == null ? null : json["value"],
    commentary: json["commentary"] == null ? null : json["commentary"],
  );

  Map<String, dynamic> toJson() => {
    "account": account == null ? null : account!.toJson(),
    "_id": id == null ? null : id,
    "travelId": travelId == null ? null : travelId,
    "userId": userId == null ? null : userId,
    "value": value == null ? null : value,
    "commentary": commentary == null ? null : commentary,
  };
}

class Account {
  Account({
    this.enable,
    this.createDate,
  });

  final bool? enable;
  final DateTime? createDate;

  Account copyWith({
    bool? enable,
    DateTime? createDate,
  }) =>
      Account(
        enable: enable ?? this.enable,
        createDate: createDate ?? this.createDate,
      );

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    enable: json["enable"] == null ? null : json["enable"],
    createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
  );

  Map<String, dynamic> toJson() => {
    "enable": enable == null ? null : enable,
    "createDate": createDate == null ? null : createDate!.toIso8601String(),
  };
}
