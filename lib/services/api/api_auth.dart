import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/services/auth_interceptor.dart';
import 'package:three_youth_app/utils/constants.dart' as Constants;

class ApiAuth {
  static Map<String, String> _getHeader() {
    return {"Content-Type": "application/json"};
  }

  static Future<void> logoutService() async {
    try {
      Client client = InterceptedClient.build(interceptors: [
        AuthInterceptor(),
      ]);
      await client.post(
        Uri.parse('${Constants.API_HOST}/logout'),
        headers: _getHeader(),
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<Response?> signupGoogleService({
    required String token,
    required String name,
    required String birth,
    required String gender,
    required int height,
    required int weight,
  }) async {
    try {
      Client client = InterceptedClient.build(
        interceptors: [AuthInterceptor()],
      );
      var response = await client.post(
        Uri.parse('${Constants.API_HOST}/signup/google'),
        body: json.encode({
          'token': token,
          "name": name,
          "birth": birth,
          "gender": gender,
          "height": height,
          "weight": weight,
        }),
        headers: _getHeader(),
      );
      final data = json.decode(utf8.decode(response.bodyBytes));
      return data;
    } catch (e) {
      print(e);
    }
  }

  static Future<Response?> signupKakaoService({
    required String token,
    required String name,
    required String birth,
    required String gender,
    required int height,
    required int weight,
  }) async {
    try {
      Client client = InterceptedClient.build(interceptors: [
        AuthInterceptor(),
      ]);
      var response = await client.post(
        Uri.parse('${Constants.API_HOST}/signup/google'),
        body: json.encode({
          'token': token,
          "name": name,
          "birth": birth,
          "gender": gender,
          "height": height,
          "weight": weight,
        }),
      );
      return response;
    } catch (e) {
      print(e);
    }
  }

  static Future<Response?> loginGoogleService({required String token}) async {
    try {
      Client client = InterceptedClient.build(interceptors: [
        AuthInterceptor(),
      ]);

      var response = await client.post(
        Uri.parse('${Constants.API_HOST}/login/google'),
        headers: _getHeader(),
        body: json.encode({
          'token': token,
        }),
      );
      return response;
    } catch (e) {
      print(e);
    }
  }

  static Future<Response?> loginKakaoService({required String token}) async {
    try {
      Client client = InterceptedClient.build(interceptors: [
        AuthInterceptor(),
      ]);
      var response = await client.post(
        Uri.parse('${Constants.API_HOST}/login/kakao'),
        headers: _getHeader(),
        body: json.encode({
          'token': token,
        }),
      );
      return response;
    } catch (e) {
      print(e);
    }
  }

  static Future<void> getTokenService({required String refreshToken}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      Client client = InterceptedClient.build(interceptors: [
        AuthInterceptor(),
      ]);
      var response = await client.post(
        Uri.parse('${Constants.API_HOST}/token/refresh'),
        headers: _getHeader(),
        body: json.encode({
          'refreshToken': refreshToken,
        }),
      );
      final data = json.decode(utf8.decode(response.bodyBytes));
      var newAccessToken = data['accessToken'];
      var newRefreshToken = data['refreshToken'];
      pref.setString('accessToken', newAccessToken);
      pref.setString('refreshToken', newRefreshToken);
    } catch (e) {
      print(e);
    }
  }

  static Future<Response?> getUserInfoService() async {
    try {
      var pref = await SharedPreferences.getInstance();
      var refreshToken = pref.getString('refreshToken');
      var accessToken = pref.getString('accessToken');
      Client client = InterceptedClient.build(interceptors: [
        AuthInterceptor(),
      ]);
      var response = await client.get(
        Uri.parse('${Constants.API_HOST}/me'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );
      return response;
    } catch (e) {
      log('$e');
    }
  }

  static Future<Response?> deleteUserService() async {
    try {
      var pref = await SharedPreferences.getInstance();
      var refreshToken = pref.getString('refreshToken');
      var accessToken = pref.getString('accessToken');
      if (accessToken == null) {
        await ApiAuth.getTokenService(refreshToken: refreshToken!);
      }
      Client client = InterceptedClient.build(interceptors: [
        AuthInterceptor(),
      ]);
      var response = await client.delete(
        Uri.parse('${Constants.API_HOST}/me'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );
      return response;
    } catch (e) {
      print(e);
    }
  }
}
