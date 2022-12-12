import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/services/api/api_auth.dart';
import 'package:three_youth_app/services/auth_interceptor.dart';
import 'package:three_youth_app/services/expired_token_retry_policy.dart';
import 'package:three_youth_app/utils/constants.dart' as Constants;
import 'package:http/http.dart' as http;

class ApiEcg {
  late SharedPreferences pref;

  static Future<Response?> getEcgService() async {
    try {
      var pref = await SharedPreferences.getInstance();
      var refreshToken = pref.getString('refreshToken');
      var accessToken = pref.getString('accessToken');
      if (accessToken == null) {
        await ApiAuth.getTokenService(refreshToken: refreshToken!);
      }
      Client client = InterceptedClient.build(
        interceptors: [
          AuthInterceptor(),
        ],
        retryPolicy: ExpiredTokenRetryPolicy(),
      );
      var response = await client.get(
        Uri.parse('${Constants.API_HOST}/electrocardiogram'),
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

  static Future<Response?> postEcgService({
    required int bpm,
    required List<int> lDataECG,
    required int duration,
  }) async {
    var pref = await SharedPreferences.getInstance();
    var refreshToken = pref.getString('refreshToken');
    var accessToken = pref.getString('accessToken');
    if (accessToken == null) {
      await ApiAuth.getTokenService(refreshToken: refreshToken!);
    }
    try {
      Client client = InterceptedClient.build(
        interceptors: [
          AuthInterceptor(),
        ],
        retryPolicy: ExpiredTokenRetryPolicy(),
      );
      var response = await client.post(
        Uri.parse('${Constants.API_HOST}/electrocardiogram'),
        body: json.encode({
          'measureDatetime':
              DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
          "bpm": bpm,
          "lDataECG": lDataECG,
          "duration": duration,
        }),
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
}
