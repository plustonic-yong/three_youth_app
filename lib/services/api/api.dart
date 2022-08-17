import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:three_youth_app/managers/account_manager.dart';
import 'package:three_youth_app/services/auth_interceptor.dart';
import 'package:three_youth_app/utils/constants.dart' as Constants;

class Api {
  static Map<String, String> _getHeader() {
    if (AccountManager().accessToken != null) {
      return {'accessToken': AccountManager().accessToken};
    } else {
      return {};
    }
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

  static Future<void> signupGoogleService({
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
      final data = json.decode(utf8.decode(response.bodyBytes));

      // if (response.statusCode == 200) {
      //   AccountManager().accessToken = data['Authorization'];
      // }
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
        headers: {"Content-Type": "application/json"},
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
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'token': token,
        }),
      );
      return response;
    } catch (e) {
      print(e);
    }
  }
}
