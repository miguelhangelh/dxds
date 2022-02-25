// To parse this JSON data, do
//
//     final featuresTransportUnitModel = featuresTransportUnitModelFromJson(jsonString);

import 'dart:convert';

List<FeaturesTransportUnitModel> featuresTransportUnitModelFromJson(String str) => List<FeaturesTransportUnitModel>.from(json.decode(str).map((x) => FeaturesTransportUnitModel.fromJson(x)));

String featuresTransportUnitModelToJson(List<FeaturesTransportUnitModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeaturesTransportUnitModel {
    FeaturesTransportUnitModel({
        this.id,
        this.name,
        this.path,
        this.quantitative,
        this.qualitative,
        this.requireForCarrier,
        this.values,
    });

    final String? id;
    final String? name;
    final String? path;
    final bool? quantitative;
    final bool? qualitative;
    final bool? requireForCarrier;

    final List<Value>? values;
    FeaturesTransportUnitModel copyWith({
        String? id,
        String? name,
        String? path,
        bool? quantitative,
        bool? requireForCarrier,
        bool? qualitative,
        List<Value>? values,
    }) => 
        FeaturesTransportUnitModel(
            id: id ?? this.id,
            name: name ?? this.name,
            requireForCarrier: requireForCarrier ?? this.requireForCarrier,
            path: path ?? this.path,
            quantitative: quantitative ?? this.quantitative,
            qualitative: qualitative ?? this.qualitative,
            values: values ?? this.values,
        );

    factory FeaturesTransportUnitModel.fromJson(Map<String, dynamic> json) => FeaturesTransportUnitModel(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        path: json["path"] == null ? null : json["path"],
        quantitative: json["Quantitative"] == null ? null : json["Quantitative"],
        requireForCarrier: json["requireForCarrier"] == null ? false : json["requireForCarrier"],
        qualitative: json["Qualitative"] == null ? null : json["Qualitative"],
        values: json["values"] == null ? null : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "path": path == null ? null : path,
        "Quantitative": quantitative == null ? null : quantitative,
        "requireForCarrier": requireForCarrier == null ? null : requireForCarrier,
        "Qualitative": qualitative == null ? null : qualitative,
        "values": values == null ? null : List<dynamic>.from(values!.map((x) => x.toJson())),
    };
}

class Value {
    Value({
        this.id,
        this.valueQualitative,
        this.valueQuantitative,
        this.selected,
    });

    final String? id;
    final String? valueQualitative;
    final int? valueQuantitative;
    bool? selected = false;

    Value copyWith({
        String? id,
        String? valueQualitative,
        int? valueQuantitative,
        bool? selected,
    }) => 
        Value(
            id: id ?? this.id,
            valueQualitative: valueQualitative ?? this.valueQualitative,
            valueQuantitative: valueQuantitative ?? this.valueQuantitative,
            selected: selected ?? this.selected,
        );

    factory Value.fromJson(Map<String, dynamic> json) => Value(
        id: json["_id"] == null ? null : json["_id"],
        valueQualitative: json["valueQualitative"] == null ? null : json["valueQualitative"],
        valueQuantitative: json["valueQuantitative"] == null ? null : json["valueQuantitative"],
        selected: json["selected"] == null ? false : json["selected"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "valueQualitative": valueQualitative == null ? null : valueQualitative,
        "valueQuantitative": valueQuantitative == null ? null : valueQuantitative,
        "selected": selected == null ? false : selected,
    };
}
