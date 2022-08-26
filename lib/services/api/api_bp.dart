import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/services/auth_interceptor.dart';
import 'package:three_youth_app/services/expired_token_retry_policy.dart';
import 'package:three_youth_app/utils/constants.dart' as Constants;

class ApiBp {
  late SharedPreferences pref;

  static Future<Response?> getBloodPressureService() async {
    try {
      var pref = await SharedPreferences.getInstance();
      var accessToken = pref.getString('accessToken');
      Client client = InterceptedClient.build(
        interceptors: [
          AuthInterceptor(),
        ],
        retryPolicy: ExpiredTokenRetryPolicy(),
      );
      var response = await client.get(
        Uri.parse('${Constants.API_HOST}/bloodpressure'),
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

  static Future<Response?> postBloodPressureService({
    required int sys,
    required int dia,
    required int pul,
  }) async {
    var pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString('accessToken');
    try {
      Client client = InterceptedClient.build(
        interceptors: [
          AuthInterceptor(),
        ],
        retryPolicy: ExpiredTokenRetryPolicy(),
      );
      var response = await client.post(
        Uri.parse('${Constants.API_HOST}/bloodpressure'),
        body: json.encode({
          'measureDatetime':
              DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
          "sys": sys,
          "dia": dia,
          "pul": pul,
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
