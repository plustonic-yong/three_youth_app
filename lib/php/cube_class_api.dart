import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'php_list_data.dart';

class CubeClassAPI {
  Future<String> sqlToText(String sql) async {
    Map<String, String> mp = {};
    mp['cmd'] = sql;
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_get_text.php', mp);
    //log(url.toString());

    final response = await http.get(url);
    var _text = utf8.decode(response.bodyBytes);
    //log(_text);

    var dataObjsJson = jsonDecode(_text)['result'] as List;
    final List<Data> parsedResponse = dataObjsJson.map((dataJson) => Data.fromJson(dataJson)).toList();
    if (response.statusCode == 200) {
      log(parsedResponse.toString());
    } else {
      log('Request failed with status: ${response.statusCode}.');
    }
    return _text;
  }

  Future<String> emailSend(String sql, String emailto, String code) async {
    String sr = '';

    Map<String, String> mp = {};
    mp['cmd'] = sql;
    mp['emailto'] = emailto;
    mp['code'] = code;
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_email_send.php', mp);
    //log(url.toString());

    final response = await http.get(url);
    sr = utf8.decode(response.bodyBytes);

    try {
      if (response.statusCode == 200) {
        //log(parsedResponse.toString());
      } else {
        //log('Request failed with status: ${response.statusCode}.');
      }
    }
    catch (e) {
      log(e.toString());
    }
    return sr;
  }
}
