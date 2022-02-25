// ignore_for_file: avoid_print

import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:dio/dio.dart';
import 'package:appdriver/core/error/errors.dart';

class ApiBaseHelper {
  Dio dio = Dio();
  ApiBaseHelper() {
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      responseType: ResponseType.json,
      connectTimeout: 30 * 1000, // 60 seconds
      receiveTimeout: 30 * 1000, // 60 seconds
    );
    dio = Dio(options);
  }
  Future<dynamic> get(String? url, {queryParameters}) async {
    dynamic responseJson;
    try {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(options: CognitoSessionOptions(getAWSCredentials: true)) as CognitoAuthSession;
      if (res.userPoolTokens != null) {
        final token = res.userPoolTokens!.idToken;
        dio.options.headers["Authorization"] = "Bearer $token";
        final Response response = await dio.get(url!, queryParameters: queryParameters);
        responseJson = _returnResponse(response);
      } else {
        dio.options.headers["Authorization"] = "Bearer ${res.credentials!.sessionToken}";
        final Response response = await dio.get(url!);
        responseJson = _returnResponse(response);
      }
    } on DioError catch (e) {
      print('DioError status get-> ${e.response}');
      if (e.type == DioErrorType.response) {
        var a = e.response!.data['message'];
        throw BadRequestException(a);
      }
      if (e.type == DioErrorType.connectTimeout) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
      if (e.type == DioErrorType.receiveTimeout) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
      if (e.error is SocketException) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
    } on SessionExpiredException catch (_) {
      throw FetchDataException('Comprueba la conexión a Internet');
    }

    return responseJson;
  }

  Future<dynamic> getPages(String? url, Map<String, dynamic> queryParameters) async {
    dynamic responseJson;
    try {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(options: CognitoSessionOptions(getAWSCredentials: true)) as CognitoAuthSession;
      if (res.userPoolTokens != null) {
        final token = res.userPoolTokens!.idToken;
        dio.options.headers["Authorization"] = "Bearer $token";
        final Response response = await dio.get(url!, queryParameters: queryParameters);
        responseJson = _returnResponse(response);
      } else {
        // dio.options.headers["Authorization"] = "Bearer ${res.credentials.sessionToken}";
        final Response response = await dio.get(url!, queryParameters: queryParameters);
        // final Response response = await dio.get(url);
        responseJson = _returnResponse(response);
      }
    } on DioError catch (e) {
      print('DioError status get-> ${e.response}');
      if (e.type == DioErrorType.response) {
        // print(e.response.data[0])
        var a = e.response!.data['message'];
        throw BadRequestException(a);
      }
      if (e.type == DioErrorType.connectTimeout) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
      if (e.type == DioErrorType.receiveTimeout) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
      if (e.error is SocketException) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
    } on SessionExpiredException catch (_) {
      throw FetchDataException('Comprueba la conexión a Internet');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, data) async {
    Dio dio = Dio();
    dynamic responseJson;
    try {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(options: CognitoSessionOptions(getAWSCredentials: true)) as CognitoAuthSession;
      final token = res.userPoolTokens!.idToken;
      dio.options.headers["Authorization"] = "Bearer $token";
      final Response response = await dio.post(url, data: data);
      responseJson = _returnResponse(response);
    } on DioError catch (e) {
      print('DioError status get-> ${e.response}');
      if (e.type == DioErrorType.response) {
        // print(e.response.data[0])
        var a = e.response!.data['message'];
        throw BadRequestException(a);
      }
      if (e.type == DioErrorType.connectTimeout) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
      if (e.type == DioErrorType.receiveTimeout) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
      if (e.error is SocketException) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
    } on SessionExpiredException catch (_) {
      throw FetchDataException('Comprueba la conexión a Internet');
    }
    return responseJson;
  }

  Future<dynamic> put(String url, data, [Map<String, dynamic>? queryParameters]) async {
    Dio dio = Dio();
    dynamic responseJson;
    try {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(options: CognitoSessionOptions(getAWSCredentials: true)) as CognitoAuthSession;
      final token = res.userPoolTokens!.idToken;
      dio.options.headers["Authorization"] = "Bearer $token";
      final Response response = await dio.put(url, data: data, queryParameters: queryParameters);
      responseJson = _returnResponse(response);
    } on DioError catch (e) {
      print('DioError status PUT-> ${e.response}');
      if (e.type == DioErrorType.response) {
        // print(e.response.data[0])
        var a = e.response!.data['message'];
        throw BadRequestException(a);
      }
      if (e.type == DioErrorType.connectTimeout) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
      if (e.type == DioErrorType.receiveTimeout) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
      if (e.error is SocketException) {
        throw FetchDataException('Comprueba la conexión a Internet');
      }
    } on SessionExpiredException catch (_) {
      throw FetchDataException('Comprueba la conexión a Internet');
    }
    return responseJson;
  }

  dynamic _returnResponse(Response response) {
    print('response status code -> ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data;
        return responseJson;
      case 400:
        throw BadRequestException('el servidor no pudo interpretar la solicitud dada una sintaxis inválida');
      case 401:
        throw UnauthorisedException('Es necesario autenticar para obtener la respuesta solicitada.');
      case 403:
        throw UnauthorisedException(
            'El cliente no posee los permisos necesarios para cierto contenido, por lo que el servidor está rechazando otorgar una respuesta apropiada');
      case 404:
        throw UnauthorisedException('El servidor no pudo encontrar el contenido solicitado');
      case 500:

      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
