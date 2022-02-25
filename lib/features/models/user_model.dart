// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:appdriver/features/models/transport_unit_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.auth,
    this.profile,
    this.address,
    this.account,
    this.recordAdvance,
    this.id,
    this.userId,
    this.type,
    this.devices,
    this.roles,
    this.resources,
    this.advancePercentage,
    this.transportUnit,
    this.ratingPercentage,
    this.signedContract = false,
  });

  Auth? auth;
  Profile? profile;
  Address? address;
  Account? account;
  bool signedContract;
  List<dynamic>? recordAdvance;
  String? id;
  String? userId;
  String? type;
  List<Device>? devices;
  List<Role>? roles;
  Resources? resources;
  double? advancePercentage;
  String? ratingPercentage;
  TransportUnitModel? transportUnit;
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        auth: json["auth"] == null ? null : Auth.fromJson(json["auth"]),
        profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        transportUnit: json["transportUnit"] == null ? null : TransportUnitModel.fromJson(json["transportUnit"]),
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        account: json["account"] == null ? null : Account.fromJson(json["account"]),
        recordAdvance: json["recordAdvance"] == null ? null : List<dynamic>.from(json["recordAdvance"].map((x) => x)),
        id: json["_id"] == null ? null : json["_id"],
        userId: json["userId"] == null ? null : json["userId"],
        type: json["type"] == null ? null : json["type"],
        devices: json["devices"] == null ? null : List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
        roles: json["roles"] == null ? null : List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        resources: json["resources"] == null ? null : Resources.fromJson(json["resources"]),
        advancePercentage: json["advancePercentage"] == null ? 0.0 : json["advancePercentage"].toDouble(),
        ratingPercentage: json["ratingPercentage"] == null ? "0.0" : json["ratingPercentage"].toString(),
        signedContract: json["signedContract"]  == null ? false :  json["signedContract"],
      );

  Map<String, dynamic> toJson() => {
        "auth": auth == null ? null : auth!.toJson(),
        "profile": profile == null ? null : profile!.toJson(),
        "address": address == null ? null : address!.toJson(),
        "account": account == null ? null : account!.toJson(),
        "recordAdvance": recordAdvance == null ? null : List<dynamic>.from(recordAdvance!.map((x) => x)),
        "_id": id == null ? null : id,
        "userId": userId == null ? null : userId,
        "type": type == null ? null : type,
        "devices": devices == null ? null : List<dynamic>.from(devices!.map((x) => x.toJson())),
        "roles": roles == null ? null : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "resources": resources == null ? null : resources!.toJson(),
        "TransportUnitModel": transportUnit == null ? null : transportUnit!.toJson(),
        "advancePercentage": advancePercentage == null ? null : advancePercentage,
        "ratingPercentage": ratingPercentage == null ? null : ratingPercentage,
        "signedContract": signedContract,
      };
}

class Account {
  Account({
    this.enable,
    this.enableDate,
    this.disableDate,
    this.createDate,
    this.updateDate,
  });

  bool? enable;
  DateTime? enableDate;
  DateTime? disableDate;
  DateTime? createDate;
  DateTime? updateDate;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        enable: json["enable"] == null ? null : json["enable"],
        enableDate: json["enableDate"] == null ? null : DateTime.parse(json["enableDate"]),
        disableDate: json["disableDate"] == null ? null : DateTime.parse(json["disableDate"]),
        createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
        updateDate: json["updateDate"] == null ? null : DateTime.parse(json["updateDate"]),
      );

  Map<String, dynamic> toJson() => {
        "enable": enable == null ? null : enable,
        "enableDate": enableDate == null ? null : enableDate!.toIso8601String(),
        "disableDate": disableDate == null ? null : disableDate!.toIso8601String(),
        "createDate": createDate == null ? null : createDate!.toIso8601String(),
        "updateDate": updateDate == null ? null : updateDate!.toIso8601String(),
      };
}

class Address {
  Address({
    this.country,
    this.city,
    this.states,
    this.street,
    this.postalCode,
  });

  String? country;
  String? city;
  String? states;
  String? street;
  String? postalCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        country: json["country"] == null ? null : json["country"],
        city: json["city"] == null ? null : json["city"],
        states: json["states"] == null ? null : json["states"],
        street: json["street"] == null ? null : json["street"],
        postalCode: json["postalCode"] == null ? null : json["postalCode"],
      );

  Map<String, dynamic> toJson() => {
        "country": country == null ? null : country,
        "city": city == null ? null : city,
        "states": states == null ? null : states,
        "street": street == null ? null : street,
        "postalCode": postalCode == null ? null : postalCode,
      };
}

class Auth {
  Auth({
    this.phone,
    this.email,
    this.confirmed,
    this.countryCode,
    this.tokenSession,
  });

  String? phone;
  String? email;
  bool? confirmed;
  String? countryCode;
  String? tokenSession;

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        phone: json["phone"] == null ? null : json["phone"],
        email: json["email"] == null ? null : json["email"],
        confirmed: json["confirmed"] == null ? null : json["confirmed"],
        countryCode: json["countryCode"] == null ? null : json["countryCode"],
        tokenSession: json["tokenSession"] == null ? null : json["tokenSession"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone == null ? null : phone,
        "email": email == null ? null : email,
        "confirmed": confirmed == null ? null : confirmed,
        "countryCode": countryCode == null ? null : countryCode,
        "tokenSession": tokenSession == null ? null : tokenSession,
      };
}

class Device {
  Device({
    this.id,
    this.pushToken,
    this.phone,
    this.registerDate,
    this.lastAccessDate,
    this.countryCode,
  });

  String? id;
  String? pushToken;
  String? phone;
  DateTime? registerDate;
  DateTime? lastAccessDate;
  String? countryCode;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["_id"] == null ? null : json["_id"],
        pushToken: json["pushToken"] == null ? null : json["pushToken"],
        phone: json["phone"] == null ? null : json["phone"],
        registerDate: json["registerDate"] == null ? null : DateTime.parse(json["registerDate"]),
        lastAccessDate: json["lastAccessDate"] == null ? null : DateTime.parse(json["lastAccessDate"]),
        countryCode: json["countryCode"] == null ? null : json["countryCode"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "pushToken": pushToken == null ? null : pushToken,
        "phone": phone == null ? null : phone,
        "registerDate": registerDate == null ? null : registerDate!.toIso8601String(),
        "lastAccessDate": lastAccessDate == null ? null : lastAccessDate!.toIso8601String(),
        "countryCode": countryCode == null ? null : countryCode,
      };
}

class Profile {
  Profile({
    this.timeZone,
    this.firstName,
    this.lastName,
    this.documentId,
    this.birthDate,
    this.personReference,
    this.phoneReference,
    this.taxId,
    this.pathPhoto,
    this.companyId,
  });

  String? timeZone;
  String? firstName;
  String? lastName;
  String? documentId;
  DateTime? birthDate;
  String? personReference;
  String? phoneReference;
  String? taxId;
  String? pathPhoto;
  String? companyId;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        timeZone: json["timeZone"] == null ? null : json["timeZone"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        documentId: json["documentId"] == null ? null : json["documentId"],
        birthDate: json["birthDate"] == null ? null : DateTime.parse(json["birthDate"]),
        personReference: json["personReference"] == null ? null : json["personReference"],
        phoneReference: json["phoneReference"] == null ? null : json["phoneReference"],
        taxId: json["taxId"] == null ? null : json["taxId"],
        pathPhoto: json["pathPhoto"] == null ? null : json["pathPhoto"],
        companyId: json["companyId"] == null ? null : json["companyId"],
      );

  Map<String, dynamic> toJson() => {
        "timeZone": timeZone == null ? null : timeZone,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "documentId": documentId == null ? null : documentId,
        "birthDate": birthDate == null ? null : birthDate!.toIso8601String(),
        "personReference": personReference == null ? null : personReference,
        "phoneReference": phoneReference == null ? null : phoneReference,
        "taxId": taxId == null ? null : taxId,
        "pathPhoto": pathPhoto == null ? null : pathPhoto,
        "companyId": companyId == null ? null : companyId,
      };
}

class Resources {
  Resources({
    this.photoDocumentIdFront,
    this.photoDocumentIdReverse,
    this.photoLicenseDrivers,
  });

  String? photoDocumentIdFront;
  String? photoDocumentIdReverse;
  String? photoLicenseDrivers;

  factory Resources.fromJson(Map<String, dynamic> json) => Resources(
        photoDocumentIdFront: json["photoDocumentIdFront"] == null ? null : json["photoDocumentIdFront"],
        photoDocumentIdReverse: json["photoDocumentIdReverse"] == null ? null : json["photoDocumentIdReverse"],
        photoLicenseDrivers: json["photoLicenseDrivers"] == null ? null : json["photoLicenseDrivers"],
      );

  Map<String, dynamic> toJson() => {
        "photoDocumentIdFront": photoDocumentIdFront == null ? null : photoDocumentIdFront,
        "photoDocumentIdReverse": photoDocumentIdReverse == null ? null : photoDocumentIdReverse,
        "photoLicenseDrivers": photoLicenseDrivers == null ? null : photoLicenseDrivers,
      };
}

class Role {
  Role({
    this.id,
    this.modulesId,
    this.name,
    this.create,
    this.read,
    this.update,
    this.delete,
    this.admin,
  });

  String? id;
  String? modulesId;
  String? name;
  bool? create;
  bool? read;
  bool? update;
  bool? delete;
  bool? admin;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["_id"] == null ? null : json["_id"],
        modulesId: json["modulesId"] == null ? null : json["modulesId"],
        name: json["name"] == null ? null : json["name"],
        create: json["create"] == null ? null : json["create"],
        read: json["read"] == null ? null : json["read"],
        update: json["update"] == null ? null : json["update"],
        delete: json["delete"] == null ? null : json["delete"],
        admin: json["admin"] == null ? null : json["admin"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "modulesId": modulesId == null ? null : modulesId,
        "name": name == null ? null : name,
        "create": create == null ? null : create,
        "read": read == null ? null : read,
        "update": update == null ? null : update,
        "delete": delete == null ? null : delete,
        "admin": admin == null ? null : admin,
      };
}
