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

class ApiBp {
  late SharedPreferences pref;

  static Future<Response?> getBloodPressureService() async {
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
    required String pdfPath,
  }) async {
    var pref = await SharedPreferences.getInstance();
    var refreshToken = pref.getString('refreshToken');
    var accessToken = pref.getString('accessToken');
    if (accessToken == null) {
      await ApiAuth.getTokenService(refreshToken: refreshToken!);
    }
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.API_HOST}/bloodpressure'),
      );
      request.fields['measureDatetime'] =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
      request.fields['sys'] = sys.toString();
      request.fields['dia'] = dia.toString();
      request.fields['pul'] = pul.toString();

      if (pdfPath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('pdf', pdfPath));
      }
      request.headers.addAll({
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
        "Content-Type": "application/json",
      });
      var response = await http.Response.fromStream(await request.send());
      return response;
    } catch (e) {
      log('$e');
    }
  }

  //혈압계 ocr 결과 가져오기
  static Future<Response?> getBloodPressureOcrService({
    required String imgPath,
  }) async {
    try {
      var bytes = File(imgPath.toString()).readAsBytesSync();
      String img64 = base64Encode(bytes);
      var url = Constants.API_OCR;
      var payload = {"base64Image": img64.toString(), "language": "eng"};
      var response = await http.post(Uri.parse(url), body: payload);
      return response;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
