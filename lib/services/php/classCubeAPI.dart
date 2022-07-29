import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:universal_html/prefer_universal/html.dart';

class Gv {
  //Singleton
  Gv._internal();
  static final Gv instance = Gv._internal();
  factory Gv() {
    return instance;
  }

  // String get sessionId => window.localStorage['SessionId'];
  // set sessionId(String sid) => (sid == null) ? window.localStorage.remove('SessionId') : window.localStorage['SessionId'] = sid;

  static bool isAdmin() {
    // bool r = false;

    //SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;

    return true; //prefs.getString("empperm") == "관리자" ? true : false;
  }
}

class TCubeAPI {
  TCubeAPI();

  Future<String> getPDFUrl(String sql) async {
    // http.Client client = http.Client();
    debugPrint('log : classCubeApi - TCubeAPI');
    Map<String, String> mp = {};
    mp['cmd'] = sql;
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_getpdfurl.php', mp);
    String sv = '';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      String ss = utf8.decode(response.bodyBytes);
      try {
        var jsonResponse = json.decode(ss);
        sv = jsonResponse['result'];
      } catch (err) {
        sv = '';
      }
    } else {}

    return sv;
  }

  Future<String> sqlToText(String sql) async {
    String sr = "";

    // http.Client client = http.Client();

    Map<String, String> mp = {};
    mp['sql'] = sql;

    // var url = Uri.http("dair.co.kr:80", "/dair/hb/api_getdata.php", mp);
    //var url = Uri.http('dair.co.kr:80', '/dair/hb/api_getdata_post.php');
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_getdataset_post.php');

    try {
      final response = await http.post(url,
          // headers: {
          //   "Content-Type": "application/json"
          // },
          body: jsonEncode(mp));

      if (response.statusCode == 200) {
        // var jsonResponse = convert.jsonDecode(response.body);
        // var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        debugPrint('Request failed with status: ${response.statusCode}.');
      }

      //return compute(parseListRow, utf8.decode(response.bodyBytes));
      sr = utf8.decode(response.bodyBytes);

      if (sr.isEmpty) {
        sr = "";
        return sr;
      }
      if (sr == "null") {
        sr = "";
        return sr;
      }

      List<TRow> lr = parseListRow(sr);
      if (lr.isNotEmpty) {
        sr = lr[0].dicCols.values.first.toString();
      } else {
        sr = "";
      }
      return sr;
    } catch (E) {
      debugPrint('$E');
      sr = E.toString();
      return sr;
    }
  }

  Future<int> sqlToInt(String sql) async {
    int sr = -1;

    // http.Client client = http.Client();

    Map<String, String> mp = {};
    mp['sql'] = sql;

    // var url = Uri.http("dair.co.kr:80", "/dair/hb/api_getdata.php", mp);
    //var url = Uri.http('dair.co.kr:80', '/dair/hb/api_getdata_post.php');
    var url =
        Uri.http('dair.co.kr:80', '/d2/dair_3youth/api_getdataset_post.php');

    try {
      final response = await http.post(url,
          // headers: {
          //   "Content-Type": "application/json"
          // },
          body: jsonEncode(mp));

      if (response.statusCode == 200) {
        // var jsonResponse = convert.jsonDecode(response.body);
        // var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        debugPrint('Request failed with status: ${response.statusCode}.');
      }

      //return compute(parseListRow, utf8.decode(response.bodyBytes));
      String ss = utf8.decode(response.bodyBytes);

      if (ss.isEmpty) {
        sr = 0;
        return sr;
      }
      if (ss == "null") {
        sr = -1;
        return sr;
      }

      List<TRow> lr = parseListRow(ss);
      if (lr.isNotEmpty) {
        String sno = lr[0].dicCols.values.first.toString();
        int? ii = int.tryParse(sno);
        if (ii == null) {
          sr = -1;
        } else {
          sr = ii;
        }
      } else {
        sr = 0;
      }
    } catch (E) {
      debugPrint('$E');
    }
    return sr;
  }

  List<TRow> parseListRow(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<TRow>((json) => TRow.fromJson(json)).toList();
  }

  Future<String> sqlToText2(String sql) async {
    // http.Client client = http.Client();

    Map<String, String> mp = {};
    mp['cmd'] = sql;
    //var url = Uri.http('dair.co.kr:80', '/dair/hb/api_getcmd.php', mp);
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_getemd.php', mp);
    String sv = '';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      sv = jsonResponse['result'];
      debugPrint(sv);
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
    return sv;
    // return compute(parseJson, response.body);
  }

  Future<String> sqlToText3(String sql) async {
    // http.Client client = http.Client();

    Map<String, String> mp = {};
    mp['cmd'] = sql;
    //var url = Uri.http('dair.co.kr:80', '/dair/hb/api_getcmd.php', mp);
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_getemdall.php', mp);
    String sv = '';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      sv = jsonResponse['result'];
      debugPrint(sv);
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
    return sv;
    // return compute(parseJson, response.body);
  }

  Future<String> sqlToText4(String sql) async {
    // http.Client client = http.Client();

    Map<String, String> mp = {};
    mp['cmd'] = sql;
    //var url = Uri.http('dair.co.kr:80', '/dair/hb/api_getcmd.php', mp);
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_getemdall_1.php', mp);
    String sv = '';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      sv = jsonResponse['result'];
      //print(sv);
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
    return sv;
    // return compute(parseJson, response.body);
  }

  Future<String> sqlExecPost(String sql) async {
    String sr = "";

    // http.Client client = http.Client();

    Map<String, String> mp = {};
    mp['sql'] = sql;

    // var url = Uri.http("dair.co.kr:80", "/dair/hb/api_getdata.php", mp);
    //var url = Uri.http('dair.co.kr:80', '/dair/hb/api_getdata_post.php');
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_getcmd_post.php');

    try {
      final response = await http.post(url,
          // headers: {
          //   "Content-Type": "application/json"
          // },
          body: jsonEncode(mp));

      if (response.statusCode == 200) {
        // var jsonResponse = convert.jsonDecode(response.body);
        // var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        debugPrint('Request failed with status: ${response.statusCode}.');
      }

      //return compute(parseListRow, utf8.decode(response.bodyBytes));
      sr = utf8.decode(response.bodyBytes);

      return sr;
    } catch (E) {
      debugPrint('$E');
      debugPrint(sr);
      return sr;
    }
  }

  Future<String> sqlExec(String sql) async {
    // http.Client client = http.Client();

    Map<String, String> mp = {};
    mp['cmd'] = sql;
    debugPrint("api_exe cmd : " + sql);
    //var url = Uri.http('dair.co.kr:80', '/dair/hb/api_execmd.php', mp);
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_execmd.php', mp);
    String sv = '';

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      sv = jsonResponse['result'];
      //  print(sv);
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
    return sv;
    // return compute(parseJson, response.body);
  }

  // String parseJson(String responseBody) {
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //
  //   return parsed.map<TRow>((json) => TRow.fromJson(json)).toList();
  // }
  static getDTToString() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
  }
}

class TRow {
  // List<String> Cols = <String>[];
  Map dicCols = {};
  bool selected = false;

  bool isReady = false;

  TRow();

  factory TRow.fromJson(Map<String, dynamic> json) {
    TRow rr = TRow();
    json.forEach((key, value) {
      rr.dicCols[key] = value;
    });

    return rr;
  }

  String value(String col) {
    String sr = "";
    if (dicCols.containsKey(col)) {
      if (dicCols[col] == null) {
        sr = "";
      } else {
        sr = dicCols[col];
      }
    } else {
      sr = "";
    }
    return sr;
  }
}

class TDataSet {
  List<TRow> rows = [];
  List<bool> selected = [];
  Map<String, TRow> colsInfo = {};
  Map<String, TRow> designInfo = {};
  List<TRow> cols = [];
  bool isReady = false;

  //String Table = '인원_목록';

  TDataSet();

  Future<void> getDataSet(String sql) async {
    Map<String, String> mp = {
      'sql': sql,
    };

    rows = await fetchDataSet(mp);
  }

  Future<List<TRow>> fetchDataSet(Map<String, String> mp) async {
    // http.Client client = http.Client();
    String sr = "";

    // var url = Uri.http("dair.co.kr:80", "/dair/hb/api_getdata.php", mp);
    //var url = Uri.http('dair.co.kr:80', '/dair/hb/api_getdata_post.php');
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_getdataset_post.php');

    try {
      final response = await http.post(url,
          // headers: {
          //   "Content-Type": "application/json"
          // },
          body: jsonEncode(mp));

      if (response.statusCode == 200) {
        // var jsonResponse = convert.jsonDecode(response.body);
        // var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        debugPrint('Request failed with status: ${response.statusCode}.');
      }

      //return compute(parseListRow, utf8.decode(response.bodyBytes));
      sr = utf8.decode(response.bodyBytes);

      return parseListRow(sr);
    } catch (E) {
      debugPrint('$E');
      debugPrint(sr);
      List<TRow> ll = <TRow>[];
      return ll;
    }
  }

  Future<void> getDataSetSetting(Map<String, String> mp) async {
    rows = await fetchRows(mp);

    // 2) table setting
    Map<String, String> mpTableSetting = {};
    mpTableSetting['table'] = '_table_setting';
    mpTableSetting['cols'] = '';
    mpTableSetting['where'] = ' 테이블 = \'' + mp['table'].toString() + '\' ';

    colsInfo = await fetchDicRows(mpTableSetting, '필드');

    colsInfo.forEach((key, value) {
      cols.add(value);
    });

    // 3) table design
    mpTableSetting.clear();
    mpTableSetting['table'] = '_table_filter_design';
    mpTableSetting['cols'] = '';
    mpTableSetting['where'] = " 키 = '테이블_" + mp["table"].toString() + "' ";
    designInfo = await fetchDicRows(mpTableSetting, 'idx');
  }

  bool colVisible(String col) {
    if (colsInfo.containsKey(col)) {
      String v = colsInfo[col]!.dicCols['표시'];
      String v2 = colsInfo[col]!.dicCols['숨기기'];
      if (v == '1' && v2 == "0") {
        return true;
      }
    }
    return false;
  }

  Map col(String col) {
    return colsInfo[col]!.dicCols;
  }

  Future<List<TRow>> fetchRows(Map<String, String> mp) async {
    // http.Client client = http.Client();
    String sr = "";

    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_getdata_post.php');

    try {
      final response = await http.post(url,
          // headers: {
          //   "Content-Type": "application/json"
          // },
          body: jsonEncode(mp));

      if (response.statusCode == 200) {
        // var jsonResponse = convert.jsonDecode(response.body);
        // var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        debugPrint('Request failed with status: ${response.statusCode}.');
      }

      //return compute(parseListRow, utf8.decode(response.bodyBytes));
      sr = utf8.decode(response.bodyBytes);

      return parseListRow(sr);
    } catch (E) {
      debugPrint('$E');
      debugPrint(sr);
      List<TRow> ll = <TRow>[];
      return ll;
    }
  }

  List<TRow> parseListRow(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<TRow>((json) => TRow.fromJson(json)).toList();
  }

  Future<Map<String, TRow>> fetchDicRows(
      Map<String, String> mp, String key) async {
    // http.Client client = http.Client();
    //var url = Uri.http('dair.co.kr:80', '/dair/hb/api_getdata_post.php');
    var url = Uri.http('dair.co.kr:80', '/dair/3youth/api_getdata_post.php');

    try {
      final response = await http.post(url,
          // headers: {
          //   "Content-Type": "application/json"
          // },
          body: jsonEncode(mp));
      if (response.statusCode == 200) {
        // var jsonResponse = convert.jsonDecode(response.body);
        // var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        debugPrint('Request failed with status: ${response.statusCode}.');
      }

      Map mpResult = {};
      mpResult['response'] = utf8.decode(response.bodyBytes);
      mpResult['key'] = Key;

      //return compute(parseDicRow, mpResult);
      return parseDicRow(mpResult);
    } catch (E) {
      debugPrint(E.toString());
      Map<String, TRow> ll = <String, TRow>{};
      return ll;
    }
  }

  Map<String, TRow> parseDicRow(Map mp) {
    String responseBody = mp['response'];
    String key = mp['key'];

    // print(responseBody);

    Map<String, TRow> _dic = {};

    try {
      final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

      List<TRow> listRow =
          parsed.map<TRow>((json) => TRow.fromJson(json)).toList();

      for (var row in listRow) {
        _dic[row.dicCols[key]] = row;
      }
    } on FormatException {
      debugPrint('-------------------------------------');
      debugPrint('The provided string is not valid JSON');
      debugPrint(responseBody);
    }

    return _dic;
  }

  int getRowCount() {
    return isReady ? 0 : rows.length;
  }
}

class CubeStorage {
  // ignore: prefer_typing_uninitialized_variables
  final _fileName;

  String _path = '';

  CubeStorage(this._fileName) {
    init();
  }

  void init() async {
    final directory = await getApplicationDocumentsDirectory();

    _path = directory.path;
  }

  Future<String> readFile() async {
    try {
      final file = File('$_path/$_fileName');

      return file.readAsString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> writeFile(String message) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _path = directory.path;
      final path = Directory('$_path/save/');
      if ((await path.exists())) {
      } else {
        path.create();
      }

      final file = File('$_path/save/$_fileName');

      file.writeAsString(message, mode: FileMode.append);
    } catch (e) {
      debugPrint('$e');
    }
  }
}
