import 'package:appdriver/features/models/rating_model.dart';
import 'package:appdriver/features/models/travel_model.dart';
import 'package:dio/dio.dart';
import 'package:appdriver/core/error/api_helper.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/models/operation_past_model.dart';
import 'package:appdriver/features/operation/data/models/operation_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OperationDatasourceRemote {
  final Dio? dio;
  final ApiBaseHelper _helper = ApiBaseHelper();
  UserPreference userPreference = UserPreference();

  OperationDatasourceRemote({required this.dio});
  Future<TravelsPastModel?> getTravelsPastAll() async {
    var transportUnitId = userPreference.transportUnit!.id!;
    var url = dotenv.env['URL_OPPORTUNITY']! + "/transportUnit/" + 'transportUnitId' + "/past";
    var response = await _helper.get(url);
    var newElement = TravelsPastModel.fromJson(response);
    return newElement;
  }

  Future<Rating?> getRating({required TravelModel travel}) async {
    var url = dotenv.env['URL_RATING']! + "/travel/" + travel.id!;
    var response = await _helper.get(url);
    var data = response['rating'];
    var rating = Rating.fromJson(data);
    return rating;
  }

  Future<Operation?> operation() async {
    var transportUnitId = userPreference.transportUnit!.id!;
    var url = dotenv.env['URL_OPPORTUNITY']! + "/transportUnit/" + transportUnitId;
    var response = await _helper.get(url);
    Operation? operationNeW;
    List data = response['travels'] as List;
    if (data.isNotEmpty) {
      var newElement = Operation.fromJson(data.last);
      operationNeW = newElement;
      return operationNeW;
    } else {
      return operationNeW;
    }
  }
}
