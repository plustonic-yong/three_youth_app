import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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

  static Future<Response?> getBloodPressureOcrService({
    required String imgPath,
  }) async {
    try {
      // var request = http.MultipartRequest(
      //   'POST',
      //   Uri.parse(Constants.API_OCR),
      // );
      // request.fields['apikey'] = Constants.API_KEY_OCR;
      // request.files.add(await http.MultipartFile.fromPath('file', imgPath));
      // request.headers.addAll({
      //   "Content-Type": "application/json",
      // });

      // var response = await http.Response.fromStream(await request.send());
      // log('ocr res: ${response.body}');
      // log('ocr res: ${response.statusCode}');

      var bytes = File(imgPath.toString()).readAsBytesSync();
      String img64 = base64Encode(bytes);

      var url = 'https://api.ocr.space/parse/image';
      var payload = {
        "base64Image": "data:image/jpg;base64,${img64.toString()}",
        "language": "eng"
      };
      var header = {"apikey": Constants.API_KEY_OCR};
      var response =
          await http.post(Uri.parse(url), body: payload, headers: header);
      // var response = jsonDecode(post.body);

      return response;
    } catch (e) {
      log('$e');
    }
  }
}
