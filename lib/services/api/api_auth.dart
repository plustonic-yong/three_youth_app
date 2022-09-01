import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/services/auth_interceptor.dart';
import 'package:three_youth_app/utils/constants.dart' as Constants;
import 'package:http/http.dart' as http;

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
    required String img,
  }) async {
    try {
      // Client client = InterceptedClient.build(
      //   interceptors: [AuthInterceptor()],
      // );
      // var response = await client.post(
      //   Uri.parse('${Constants.API_HOST}/signup/google'),
      //   body: json.encode({
      //     'token': token,
      //     "name": name,
      //     "birth": birth,
      //     "gender": gender,
      //     "height": height,
      //     "weight": weight,
      //   }),
      //   headers: _getHeader(),
      // );
      // final data = json.decode(utf8.decode(response.bodyBytes));
      // return data;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.API_HOST}/signup/google'),
      );
      request.fields['token'] = token;
      request.fields['name'] = name;
      request.fields['birth'] = birth;
      request.fields['gender'] = gender;
      request.fields['height'] = height.toString();
      request.fields['weight'] = weight.toString();
      request.files.add(await http.MultipartFile.fromPath('img', img));
      request.headers.addAll(_getHeader());

      var response = await http.Response.fromStream(await request.send());
      return response;
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
    required String img,
  }) async {
    try {
      // Client client =
      //     InterceptedClient.build(interceptors: [AuthInterceptor()]);
      // var response = await http.post(
      //   Uri.parse('${Constants.API_HOST}/signup/kakao'),
      //   body: json.encode({
      //     'token': token,
      //     "name": name,
      //     "birth": birth,
      //     "gender": gender,
      //     "height": height,
      //     "weight": weight,
      //     "img": img,
      //   }),
      //   headers: _getHeader(),
      // );
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.API_HOST}/signup/kakao'),
      );
      request.fields['token'] = token;
      request.fields['name'] = name;
      request.fields['birth'] = birth;
      request.fields['gender'] = gender;
      request.fields['height'] = height.toString();
      request.fields['weight'] = weight.toString();
      request.files.add(await http.MultipartFile.fromPath('img', img));
      request.headers.addAll(_getHeader());

      var response = await http.Response.fromStream(await request.send());
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

  static Future<Response?> loginNaverService({required String token}) async {
    try {
      Client client = InterceptedClient.build(interceptors: [
        AuthInterceptor(),
      ]);
      var response = await client.post(
        Uri.parse('${Constants.API_HOST}/login/naver'),
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
      if (accessToken == null) {
        await ApiAuth.getTokenService(refreshToken: refreshToken!);
      }
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

  static Future<Response?> updateUserService({
    required int height,
    required int weight,
    String? img,
  }) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var refreshToken = pref.getString('refreshToken');
      var accessToken = pref.getString('accessToken');
      if (accessToken == null) {
        await ApiAuth.getTokenService(refreshToken: refreshToken!);
      }
      var request =
          http.MultipartRequest("PUT", Uri.parse('${Constants.API_HOST}/me'));
      request.fields['height'] = height.toString();
      request.fields['weight'] = weight.toString();
      if (img != null) {
        request.files.add(await http.MultipartFile.fromPath('img', img));
      }
      request.headers.addAll({
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
        "Content-Type": "application/json",
      });
      var response = await http.Response.fromStream(await request.send());
      return response;
    } catch (e) {
      print(e);
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
