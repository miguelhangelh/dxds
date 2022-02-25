import 'dart:convert';

import 'package:appdriver/features/models/category_model.dart';
import 'package:appdriver/features/models/postulationRequest.dart';
import 'package:appdriver/features/models/transport_unit_model.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:appdriver/features/models/user_model.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static final UserPreference _instance = UserPreference._internal();

  factory UserPreference() {
    return _instance;
  }

  UserPreference._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  get getNameUser {
    return _prefs.getString('nameUser') ?? '';
  }

  Future<bool> deleteKey(String key) async {
    return await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  set setNameUser(String value) {
    _prefs.setString('nameUser', value);
  }

  get getNumberPhoneUser {
    return _prefs.getInt('numberPhoneUser');
  }

  set setNumberPhoneUser(int value) {
    _prefs.setInt('numberPhoneUser', value);
  }

  set category(String value) {
    _prefs.setString('categories', value);
  }

  get getImageUser {
    return _prefs.getString('imageUser');
  }

  set setImageUser(String value) {
    _prefs.setString('imageUser', value);
  }

  set sessionUser(bool value) {
    _prefs.setBool('sessionUser', value);
  }

  set onBoarding(bool value) {
    _prefs.setBool('onBoarding', value);
  }

  bool get sessionUser {
    return _prefs.getBool('sessionUser') ?? false;
  }

  bool get onBoarding {
    return _prefs.getBool('onBoarding') ?? false;
  }

  bool get guestMode {
    return _prefs.getBool('guestMode') ?? false;
  }

  bool get firstRun {
    return _prefs.getBool('first_run') ?? true;
  }

  set guestMode(bool value) {
    _prefs.setBool('guestMode', value);
  }

  get getLanguage {
    return _prefs.getString('language');
  }

  set setLanguage(String value) {
    _prefs.setString('language', value);
  }

  get getLatestPage {
    return _prefs.getString('latestPage') ?? 'home';
  }

  set setLatestPage(String value) {
    _prefs.setString('latestPage', value);
  }

  set firstRun(bool value) {
    _prefs.setBool('first_run', value);
  }

  set setTravelPostulation(String value) {
    _prefs.setString('travelPostulation', value);
  }

  set setOperation(String value) {
    _prefs.setString('operation', value);
  }

  set setVersion(String value) {
    _prefs.setString('version', value);
  }

  set travelsPostulation(List<TravelModel> value) {
    String encode = json.encode(value);
    _prefs.setString('travelsPostulation', encode);
  }

  set setUser(String value) {
    _prefs.setString('user', value);
  }

  set setTransportUnit(String value) {
    _prefs.setString('transportUnit', value);
  }

  get version {
    return _prefs.getString('version');
  }

  PostulationRequest? get getTravelPostulation {
    var exist = _prefs.getString('travelPostulation');
    if (exist != null) {
      var data = json.decode(exist);
      var data2 = PostulationRequest.fromJson(data);
      return data2;
    } else {
      return null;
    }
  }

  UserModel get getUser {
    var exist = _prefs.getString('user')!;
    var data = json.decode(exist);
    var data2 = UserModel.fromJson(data);
    print("user -> ${data2.id} ");
    return data2;
  }

  UserModel? get getUserMenu {
    var exist = _prefs.getString('user');
    if (exist != null) {
      var data = json.decode(exist);
      var data2 = UserModel.fromJson(data);
      print("user -> ${data2.id} ");
      return data2;
    }
    return null;
  }

  List<TravelModel> get travelsPostulation {
    List<TravelModel> data = [];
    String? travelsPostulation = _prefs.getString('travelsPostulation') ?? null;
    if (travelsPostulation == null) return data;
    List<dynamic> listMap = json.decode(travelsPostulation);
    for (var element in listMap) {
      data.add(TravelModel.fromJson(element));
    }
    return data;
  }

  List<CategoryModel>? get categories {
    List<CategoryModel> data = [];
    String? categories = _prefs.getString('categories');
    if (categories == null) return null;
    List<dynamic> listMap = json.decode(categories);
    for (var element in listMap) {
      data.add(CategoryModel.fromJson(element));
    }
    return data;
  }

  Operation? get operation {
    var operation = _prefs.getString('operation');
    if (operation == null) return null;
    var data2 = json.decode(operation);
    Operation operationDecode = Operation.fromJson(data2);
    return operationDecode;
  }

  TransportUnitModel? get transportUnit {
    var exist = _prefs.getString('transportUnit');
    if (exist != null) {
      var data = json.decode(exist);
      var data2 = TransportUnitModel.fromJson(data);
      print("TRANSPORTUNIT -> ${data2.id} ");
      return data2;
    } else {
      return null;
    }
  }
}
