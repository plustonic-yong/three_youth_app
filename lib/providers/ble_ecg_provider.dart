import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/models/ecg_model.dart';
import 'package:three_youth_app/models/ecg_value_model.dart';
import 'package:three_youth_app/services/api/api_auth.dart';
import 'package:three_youth_app/services/api/api_ecg.dart';
import 'package:three_youth_app/utils/toast.dart';
import 'package:synchronized/synchronized.dart';
import 'package:three_youth_app/utils/utils.dart';

class BleEcgProvider extends ChangeNotifier {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  var lock = Lock();

  static const String sBLEDevice = "er2000_smart_v2.1";
  static const String sUUIDService = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
  static const String sUUIDRx = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
  static const String sUUIDTx = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
  static const String sUUIDCharDatetime =
      "00002a08-0000-1000-8000-00805f9b34fb";

  BluetoothDevice? _bleDevice;

  //심전계 안내에서의 현재 페이지
  int _currentPage = 0;
  int get currentPage => _currentPage;

  //측정중인지 여부
  bool _isScanning = false;
  bool get isScanning => _isScanning;

  //페어링 끝났는지
  bool _isPairing = false;
  bool get isPairing => _isPairing;
  set isPairing(bool isPairing) {
    _isPairing = isPairing;
    notifyListeners();
  }

  //측정 페어링
  bool _isReadMeasure = false;
  bool get isReadMeasure => _isReadMeasure;
  set isReadMeasure(bool isReadMeasure) {
    _isReadMeasure = isReadMeasure;
    notifyListeners();
  }

  //페어링 끝났는지
  bool _isPaired = false;
  bool get isPaired => _isPaired;
  set isPaired(bool isPaired) {
    _isPaired = isPaired;
    notifyListeners();
  }

  //심전계 데이터
  List<EcgModel>? _ecgHistories = [];
  List<EcgModel>? get ecgHistories => _ecgHistories;

  //심전계 데이터
  List<EcgModel>? _ecgAllHistories = [];
  List<EcgModel>? get ecgAllHistories => _ecgAllHistories;

  //마지막 심전계 데이터
  EcgModel? _lastEcgHistory;
  EcgModel? get lastEcgHistory => _lastEcgHistory;

  // 앱 초기 로그인 시작시 페어링 여부 확인
  Future<void> findIsPaired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isPaired = prefs.getBool('isEcgFairing') ?? false;
    notifyListeners();
  }

  // 연결 해제
  Future<void> disConnectPairing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isEcgFairing", false);
    _isScanning = false;
    _isPaired = false;
    _bleDevice?.disconnect();
    notifyListeners();
  }

  // 스캔 및 디바이스 등록
  void startScanAndConnect(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    flutterBlue.state.listen((event) {
      if (event == BluetoothState.off) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(30.0),
                actionsPadding: const EdgeInsets.all(10.0),
                actions: [
                  GestureDetector(
                    onTap: () async {
                      await disConnectPairing();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/main', (route) => false);
                    },
                    child: const Text(
                      '확인',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
                content: const Text(
                  '설정에서 블루투스를 켜주세요.',
                  style: TextStyle(fontSize: 18.0),
                ),
              );
            });
      }
    });

    var list = await flutterBlue.connectedDevices;

    for (var item in list) {
      /// 연결된 디바이스 존재
      if (item.name == sBLEDevice) {
        try {
          await prefs.setBool('isEcgFairing', true);
          _isPaired = true;
          _bleDevice = item;
          await _bleDevice?.pair();
          measure();
        } catch (e) {
          debugPrint(e.toString());
        } finally {}
        return;
      }
    }
    try {
      isPairing = false;
      flutterBlue.startScan(timeout: const Duration(seconds: 10)).then((value) {
        if (isPairing == false) {
          showToast('다시 시도 해주세요');
          Navigator.of(context).pop();
        }
      });
      flutterBlue.scanResults.listen((results) async {
        for (var r in results) {
          debugPrint(r.device.name);
          if (r.device.name.startsWith(sBLEDevice)) {
            isPairing = true;
            await flutterBlue.stopScan();
            await r.device.connect();
            await r.device.pair();
            await r.device.requestMtu(512);
            isPaired = true;
            _bleDevice = r.device;
            measure();
            await prefs.setBool("isEcgFairing", true);
            return;
          }
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      await prefs.setBool("isEcgFairing", false);
      isPaired = false;
    }
  }

  Future<void> dataClear() async {
    dataCnt = 0;
    _lDataECG.clear();
    notifyListeners();
  }

  // 안내 페이지 변경
  void onChangeCurrentPage({required int page}) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> getLastEcg() async {
    var pref = await SharedPreferences.getInstance();
    var response = await ApiEcg.getEcgService();
    int statusCode = response!.statusCode;
    //accessToken 만료 시 token refresh
    if (statusCode == 401) {
      var refreshToken = pref.getString('refreshToken');
      await ApiAuth.getTokenService(refreshToken: refreshToken!);
      response = await ApiEcg.getEcgService();
      statusCode = response!.statusCode;
    }
    if (statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      List<EcgModel> ecgList =
          (data as List).map((json) => EcgModel.fromJson(json)).toList();

      //가장 최근의 심전계데이터 가져오기
      if (ecgList.isNotEmpty) {
        ecgList.sort((a, b) => a.measureDatetime.compareTo(b.measureDatetime));
        _lastEcgHistory = ecgList.last;
      } else {
        _lastEcgHistory = null;
      }
      notifyListeners();
    }
  }

  Future<void> getEcg(DateTime measureDatetime) async {
    var pref = await SharedPreferences.getInstance();
    var response = await ApiEcg.getEcgService();

    int statusCode = response!.statusCode;
    if (statusCode == 401) {
      var refreshToken = pref.getString('refreshToken');
      await ApiAuth.getTokenService(refreshToken: refreshToken!);
      response = await ApiEcg.getEcgService();
      statusCode = response!.statusCode;
    }
    if (statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      List<EcgModel> ecgList =
          (data as List).map((json) => EcgModel.fromJson(json)).toList();
      List<EcgModel> filtedEcgList = [];

      //선택한 날짜와 일치하는 데이터 추출
      for (var element in ecgList) {
        if (Utils.formatDatetime(element.measureDatetime).split(' ')[0] ==
            Utils.formatDatetime(measureDatetime).split(' ')[0]) {
          filtedEcgList.add(element);
        }
      }
      //선택한 날짜와 일치하는 데이터중 최신 시간대 순으로 배열
      filtedEcgList
          .sort((a, b) => b.measureDatetime.compareTo(a.measureDatetime));
      _ecgAllHistories = ecgList;
      _ecgHistories = filtedEcgList;
      notifyListeners();
    }
  }

  Future<bool> postEcg({
    required int bpm,
    required List<int> lDataECG,
    required int duration,
    required String pdfPath,
  }) async {
    var pref = await SharedPreferences.getInstance();
    var response = await ApiEcg.postEcgService(
      bpm: bpm,
      lDataECG: lDataECG,
      duration: duration,
      pdfPath: pdfPath,
    );
    int statusCode = response!.statusCode;
    if (statusCode == 401) {
      var refreshToken = pref.getString('refreshToken');
      await ApiAuth.getTokenService(refreshToken: refreshToken!);
      await ApiEcg.postEcgService(
        duration: duration,
        bpm: bpm,
        lDataECG: lDataECG,
        pdfPath: pdfPath,
      );
      statusCode = response.statusCode;
    }
    if (statusCode == 200) {
      return true;
    }
    return false;
  }

  //////// 실시간 측정 //////////
  int _bleEcgState = 0;
  int get bleEcgState => _bleEcgState;
  set bleEcgState(int bleEcgState) {
    _bleEcgState = bleEcgState;
    notifyListeners();
  }

  BluetoothCharacteristic? _bleCharRx;
  BluetoothCharacteristic? _bleCharTx;

  List<EcgValueModel> _lDataECG = [];
  List<EcgValueModel> get lDataECG => _lDataECG;

  List<DateTime> _lTimeECG = [];
  List<String> _lSQLECG = [];

  List<FlSpot> _lsData = [];
  List<FlSpot> get lsData => _lsData;
  set lsData(List<FlSpot> lsData) {
    _lsData = lsData;
    notifyListeners();
  }

  String _sData = '';
  String get sData => _sData;
  set sData(String sData) {
    _sData = sData;
    notifyListeners();
  }

  int dataCnt = 0;
  bool dataIsOK = false;

  // 심전계 측정
  void measure() async {
    if (_bleDevice != null) {
      List<BluetoothService> services = await _bleDevice!.discoverServices();
      for (var service in services) {
        if (service.uuid.toString().toUpperCase() == sUUIDService) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic c in characteristics) {
            debugPrint('####### Character UUID = ${c.uuid.toString()}');
            if (c.uuid.toString().toUpperCase() == sUUIDTx) {
              _bleCharRx = c;
              await startMeasure();
            } else if (c.uuid.toString().toUpperCase() == sUUIDRx) {
              if (!_isReadMeasure) {
                _bleCharTx = c;
                _bleCharTx?.value.listen((value) => doPacket(value));
                debugPrint('read : measure');
              }
            }
          }
        }
      }
    }
  }

  Future<void> startMeasure() async {
    await _bleCharTx?.setNotifyValue(true);
    var retry = 0;
    do {
      try {
        await _bleCharRx?.write(utf8.encode("DEBUG1<\r\n>"),
            withoutResponse: true);
        retry++;
      } on PlatformException {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } while (retry < 3);
    debugPrint('write : start measure');
  }

  Future<void> stopMeasure() async {
    await _bleCharTx?.setNotifyValue(false);
    var retry = 0;
    do {
      try {
        await _bleCharRx?.write(utf8.encode("DEBUG0<\r\n>"),
            withoutResponse: true);
        retry++;
      } on PlatformException {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } while (retry < 3);
    debugPrint('write : stop measure');
  }

  void doPacket(List<int> value) async {
    if (value.isEmpty) {
      debugPrint('success packet listen');
      _isReadMeasure = true;
      return;
    }

    if (_bleEcgState != 1) {
      bleEcgState = 1;
    }

    dataCnt++;
    while (lsData.length >= 300) {
      lsData.removeAt(0);
    }

    String sdata2 = '';
    var ff = DateFormat('yyyy-MM-dd HH:mm:ss');
    var now = DateTime.now();
    var ffNow = ff.format(now);
    _sData = "'" + ffNow + "', '";
    sdata2 = "'" + ffNow + "', '";

    String command = String.fromCharCode(value.first);
    String end = String.fromCharCode(value[value.length - 2]);
    String next = String.fromCharCode(value.last);

    List<int> valueLst = [];
    List<double> ecgData = [];

    for (var i = 1; i < value.length - 2; i++) {
      sdata2 += '${value[i]},';
      if (i % 2 == 0) {
        valueLst.add(value[i]);
        var list = Uint8List.fromList(valueLst);
        var powerValue = ((list[1] << 8) + list[0]);
        _sData += '$powerValue,';
        valueLst.clear();
        double dv = powerValue.toDouble();
        lsData.add(FlSpot(dataCnt.toDouble(), dv));
        ecgData.add(dv);
        lsData = lsData;
        dataCnt++;
      } else {
        valueLst.add(value[i]);
      }
    }
    debugPrint('$command : $sData : $end $next');
    debugPrint('$command : $sdata2 : $end $next');
    _lDataECG.add(EcgValueModel(measureDatetime: now, lDataECG: ecgData));
    _lSQLECG.add(sData);
  }
}
