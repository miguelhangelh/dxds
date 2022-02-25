import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:appdriver/features/models/category_model.dart';
import 'package:appdriver/features/models/echange_rate_model.dart';
import 'package:appdriver/features/opportunity/presentation/bloc/opportunity_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:appdriver/core/error/api_helper.dart';
import 'package:appdriver/core/share_prefs/user_pref.dart';
import 'package:appdriver/features/models/postulationRequest.dart';
import 'package:appdriver/features/models/travel_model.dart';

class OpportunityDataSourceRemote {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final Dio? dio;
  final UserPreference userPreference = UserPreference();

  OpportunityDataSourceRemote({this.dio});
  dynamic filterResponse(int? page, DateTime? end, DateTime? start, String? category, typeFilter, url) async {
    var response;
    if (end != null && start != null) {
      var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
      var formatStart = DateFormat("yyyy-MM-dd").format(start);
      var formatEnd = DateFormat("yyyy-MM-dd").format(end);
      DateTime newDateBegin = DateTime.parse(formatStart).add(Duration(minutes: 1));
      DateTime newDateEnd = DateTime.parse(formatEnd).add(Duration(hours: 23, minutes: 59));
      String dateBegin = inputFormat.format(newDateBegin);
      String dateEnd = inputFormat.format(newDateEnd);
      Map<String, dynamic> parameters = {'page': page, 'size': 5, 'dateBegin': dateBegin, 'dateEnd': dateEnd};
      if (typeFilter == TypeFilter.DATE) {
        parameters['type'] = 'date';
        response = await _helper.getPages(url, parameters);
      } else if (typeFilter == TypeFilter.ALL) {
        parameters['type'] = 'categoryDate';
        parameters['categoryId'] = category;
        response = await _helper.getPages(url, parameters);
      }
    }
    if (typeFilter == TypeFilter.NONE) {
      response = await _helper.getPages(url, {
        'page': page,
        'size': 5,
      });
    }
    if (typeFilter == TypeFilter.CATEGORY) {
      response = await _helper.getPages(url, {
        'page': page,
        'size': 5,
        'type': 'category',
        'categoryId': category,
      });
    }
    return response;
  }

  Future<List<TravelModel>> getOpportunities({int? page = 0, DateTime? end, DateTime? start, String? category, typeFilter}) async {
    var transportUnit = userPreference.transportUnit;
    String? url;
    AuthSession res = await Amplify.Auth.fetchAuthSession();
    if (res.isSignedIn) {
      if (transportUnit != null) {
        url = dotenv.env['URL_OPPORTUNITY']! + "/transportUnitId/" + transportUnit.id!;
      } else {
        url = dotenv.env['URL_OPPORTUNITY_GUEST'];
      }
    } else {
      url = dotenv.env['URL_OPPORTUNITY_GUEST'];
    }
    var response = await filterResponse(page, end, start, category, typeFilter, url);
    var data = response['travels'] as List;
    List<TravelModel> list = data.map<TravelModel>((e) => TravelModel.fromJson(e)).toList();
    return list;
  }

  Future<List<TravelModel>> getOpportunityAllPayments({
    int? page,
    String? typeFilter,
  }) async {
    var exist = userPreference.transportUnit!;
    var url = dotenv.env['URL_OPPORTUNITY']! + '/paid/pay/${exist.id}?type=$typeFilter';
    var response = await _helper.get(url);
    var data = response['travels'] as List;
    List<TravelModel> travels = data.map<TravelModel>((e) => TravelModel.fromJson(e)).toList();
    return travels;
  }

  Future<List<CategoryModel>> getCategoryAll() async {
    var url = dotenv.env['URL_CATEGORIES'];
    var response = await _helper.get(url);
    var data = response['categories'] as List;
    List<CategoryModel> categories = data.map<CategoryModel>((e) => CategoryModel.fromJson(e)).toList();
    userPreference.category = json.encode(categories);
    return categories;
  }

  Future<List<ExchangeRate>> getAllExchangeRate() async {
    var url = dotenv.env['URL_EXCHANGE_RATE'];
    var response = await _helper.get(url);
    var data = response['exchangeRate'] as List;
    List<ExchangeRate> exchangeRates = data.map<ExchangeRate>((e) => ExchangeRate.fromJson(e)).toList();
    return exchangeRates;
  }

  Future<PostulationRequest?> cancelledPostulation({required PostulationRequest postulation}) async {
    var data;
    var url = dotenv.env['URL_POSTULATION']! + "/cancelled/" + postulation.postulation!.id!;
    await _helper.put(url, data);
    PostulationRequest postulations = postulation;
    return postulations;
  }

  Future<List<TravelModel>> getOpportunityAllRoundTrip(TravelModel travel) async {
    var exist = userPreference.transportUnit;
    var travelData = travel;
    var time = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(travelData.dates!.deliveryDate!);
    AuthSession res = await Amplify.Auth.fetchAuthSession();
    if (res.isSignedIn) {
      if (exist != null) {
        var url =
            dotenv.env['URL_OPPORTUNITY']! + "/transportUnitId/${exist.id}/deliveryDate/$time/city/${travel.route!.destination!.cityDestinationId}";
        var response = await _helper.get(url);
        var data = response['travels'] as List;
        List<TravelModel> travels = data.map<TravelModel>((e) => TravelModel.fromJson(e)).toList();
        return travels;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<PostulationRequest?> addPostulation(PostulationRequest postulationRequest) async {
    var exist = userPreference.transportUnit!;
    Map<String, dynamic> postulation = {
      "travelId": postulationRequest.postulation!.travelId,
      "typeCurrencyFreightId": postulationRequest.postulation!.typeCurrencyFreightId,
      "transportUnitId": exist.id,
      "freightValue": 0.0,
      "invoice": postulationRequest.postulation!.invoice
    };
    if (postulationRequest.postulation!.typeUnitMeasurement == null) {
      postulation["abbreviationTypeCurrency"] = postulationRequest.postulation!.abbreviationTypeCurrency;
    } else {
      postulation["abbreviationUnit"] = postulationRequest.postulation!.abbreviationUnit;
      postulation["typeMeasurementUnit"] = postulationRequest.postulation!.typeMeasurementUnit;
      postulation["abbreviationTypeCurrency"] = postulationRequest.postulation!.abbreviationTypeCurrency;
      postulation["typeUnitMeasurement"] = postulationRequest.postulation!.typeUnitMeasurement;
    }
    if (postulationRequest.postulation?.freightValue != null) {
      postulation.update("freightValue", (value) => postulationRequest.postulation!.freightValue);
    }

    var url = dotenv.env['URL_POSTULATION']!;
    var response = await _helper.post(url, postulation);
    PostulationRequest postulationResponse = PostulationRequest.fromJson(response);
    if (response != null) {
      return postulationResponse;
    }
    return null;
  }

  Future<PostulationRequest?> getPostulationTruck(String travelId) async {
    var exist = userPreference.transportUnit;
    var url = dotenv.env['URL_POSTULATION']! + "/travel/" + travelId;
    var response = await _helper.get(url);
    var postulations = response['postulations'] as List;
    PostulationRequest? newData;
    for (var element in postulations) {
      Map<String, dynamic>? dataPostulation = element['dataPostulation'];
      var object = {
        'message': 'ok',
        "postulation": dataPostulation,
      };
      var jsonData = PostulationRequest.fromJson(object);
      if (jsonData.postulation!.transportUnitId == exist!.id && jsonData.postulation!.travelId == travelId) {
        newData = jsonData;
      }
    }
    if (response != null) {
      return newData;
    }
    return null;
  }

  Future<PostulationRequest?> confirmPostulation(PostulationRequest postulationRequest) async {
    var url = dotenv.env['URL_POSTULATION']! + "/confirm/" + postulationRequest.postulation!.id!;
    var data;
    var response = await _helper.put(url, data);
    var postulation = postulationRequest;
    if (response != null) {
      return postulation;
    }
    return null;
  }

  Future<TravelModel> getOpportunityById({String? travelId}) async {
    var transportUnit = userPreference.transportUnit!;
    var url = dotenv.env['URL_OPPORTUNITY']! + "/$travelId/transportUnitId/${transportUnit.id}";
    var response = await _helper.get(url);
    TravelModel travel = TravelModel.fromJson(response['travel']);
    return travel;
  }
}
