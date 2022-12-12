import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/models/bp_model.dart';
import 'package:three_youth_app/services/api/api_auth.dart';
import 'package:three_youth_app/services/api/api_bp.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/utils/utils.dart';

class BleBpProvider extends ChangeNotifier {
  final _ble = FlutterReactiveBle();
  final Uuid _serviceUuid = Uuid.parse("00001810-0000-1000-8000-00805f9b34fb");
  BpScanStatus _bpScanStatus = BpScanStatus.scanning;
  BpScanStatus get bpScanStatus => _bpScanStatus;

  //혈압계 안내에서의 현재 페이지
  int _currentPage = 0;
  int get currentPage => _currentPage;

  //페어링 중인지 아닌지
  bool _isPairing = false;
  bool get isPairing => _isPairing;

  //페어링 끝났는지
  bool _isPaired = false;
  bool get isPaired => _isPaired;

  //기기 찾는중인지 아닌지
  bool _foundDeviceWaitingToConnect = false;
  bool get foundDeviceWaitingToConnect => _foundDeviceWaitingToConnect;

  //기기연동여부
  bool _connected = false;
  bool get connected => _connected;

  //측정중인지 여부
  bool _isScanning = false;
  bool get isScanning => _isScanning;

  StreamSubscription<DiscoveredDevice>? _scanStream;
  StreamSubscription<DiscoveredDevice>? get scanStream => _scanStream;

  //측정시작시간
  DateTime _dtStart = DateTime.now();
  DateTime get dtStart => _dtStart;

  //측정종료시간
  DateTime _dtStop = DateTime.now();
  DateTime get dtStop => _dtStop;

  String _testID = '';
  String get testID => _testID;

  Timer? _timer;
  Timer? get timer => _timer;

  int _iNeedDisconnect = 0;
  int get iNeedDisconnect => _iNeedDisconnect;

  int _iFindCnt = 0;
  int get iFintCnt => _iFindCnt;

  DiscoveredDevice? _ubiqueDevice;
  DiscoveredDevice? get ubiqueDevice => _ubiqueDevice;

  final Uuid _bleRx = Uuid.parse("00002a35-0000-1000-8000-00805f9b34fb");
  final Uuid _bleTx = Uuid.parse("00002a08-0000-1000-8000-00805f9b34fb");

  //Rx: recive 보내는 데이터
  //Tx: Transaction 받는 데이터

  QualifiedCharacteristic? _rxCharacteristic;
  QualifiedCharacteristic? get rxCharacteristic => _rxCharacteristic;
  QualifiedCharacteristic? _txCharacteristic;
  QualifiedCharacteristic? get txCharacteristic => _txCharacteristic;

  Stream<List<int>>? _ssRx;
  Stream<List<int>>? get ssRx => _ssRx;

  int _isTestSave = 0;
  int get isTestSave => _isTestSave;

  bool _isResult = false;
  bool get isResult => _isResult;

  int _dataCnt = 0;
  int get dataCnt => _dataCnt;

  bool _dataIsOK = false;
  bool get dataIsOK => _dataIsOK;

  String _dataState = "-";
  String get dataState => _dataState;

  bool _isUpdated = false;
  bool get isUpdated => _isUpdated;

  //sys 데이터
  List<double> _lDataSYS = [0];
  List<double> get lDataSYS => _lDataSYS;

  //dia 데이터
  List<double> _lDataDIA = [0];
  List<double> get lDataDIA => _lDataDIA;

  //pul데이터
  List<double> _lDataPUL = [0];
  List<double> get lDataPUL => _lDataPUL;

  //혈압계 데이터
  List<BpModel>? _bpHistories = [];
  List<BpModel>? get bpHistories => _bpHistories;

  //혈압계 데이터
  List<BpModel>? _bpAllHistories = [];
  List<BpModel>? get bpAllHistories => _bpAllHistories;

  //마지막 혈압계 데이터
  BpModel? _lastBpHistory;
  BpModel? get lastBpHistory => _lastBpHistory;

  void onInitCurrentPage() {
    _currentPage = 0;
    notifyListeners();
  }

  //앱 초기 로그인 시작시 페어링 여부 확인
  Future<void> findIsPaired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isPaired = prefs.getBool('isSphyFairing') ?? false;
    notifyListeners();
  }

  void onChangeCurrentPage({required int page}) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> getLastBloodPressure() async {
    var pref = await SharedPreferences.getInstance();
    var response = await ApiBp.getBloodPressureService();
    int statusCode = response!.statusCode;
    //accessToken 만료 시 token refresh
    if (statusCode == 401) {
      var refreshToken = pref.getString('refreshToken');
      await ApiAuth.getTokenService(refreshToken: refreshToken!);
      response = await ApiBp.getBloodPressureService();
    }

    if (statusCode == 200) {
      final data = json.decode(utf8.decode(response!.bodyBytes));
      List<BpModel> bpList =
          (data as List).map((json) => BpModel.fromJson(json)).toList();

      //가장 최근의 혈압데이터 가져오기
      if (bpList.isNotEmpty) {
        bpList.sort((a, b) => a.measureDatetime.compareTo(b.measureDatetime));
        _lastBpHistory = bpList.last;
      } else {
        _lastBpHistory = null;
      }
      notifyListeners();
    }
  }

  Future<void> getBloodPressure(DateTime measureDatetime) async {
    var pref = await SharedPreferences.getInstance();
    var response = await ApiBp.getBloodPressureService();

    int statusCode = response!.statusCode;
    if (statusCode == 401) {
      var refreshToken = pref.getString('refreshToken');
      await ApiAuth.getTokenService(refreshToken: refreshToken!);
      response = await ApiBp.getBloodPressureService();
    }
    if (statusCode == 200) {
      final data = json.decode(utf8.decode(response!.bodyBytes));
      List<BpModel> bpList =
          (data as List).map((json) => BpModel.fromJson(json)).toList();
      List<BpModel> filtedBpList = [];

      //선택한 날짜와 일치하는 데이터 추출
      bpList.forEach((element) {
        if (Utils.formatDatetime(element.measureDatetime).split(' ')[0] ==
            Utils.formatDatetime(measureDatetime).split(' ')[0]) {
          filtedBpList.add(element);
        }
      });
      //선택한 날짜와 일치하는 데이터중 최신 시간대 순으로 배열
      filtedBpList
          .sort((a, b) => b.measureDatetime.compareTo(a.measureDatetime));
      _bpAllHistories = bpList;
      _bpHistories = filtedBpList;
      notifyListeners();
    }
  }

  Future<BpSaveDataStatus> postBloodPressure({
    required int sys,
    required int dia,
    required int pul,
  }) async {
    var pref = await SharedPreferences.getInstance();
    var response = await ApiBp.postBloodPressureService(
      sys: sys,
      dia: dia,
      pul: pul,
    );
    int statusCode = response!.statusCode;
    if (statusCode == 401) {
      var refreshToken = pref.getString('refreshToken');
      await ApiAuth.getTokenService(refreshToken: refreshToken!);
      await ApiBp.postBloodPressureService(
        sys: sys,
        dia: dia,
        pul: pul,
      );
    }
    if (statusCode == 200) {
      return BpSaveDataStatus.success;
    }
    return BpSaveDataStatus.failed;
  }

  Future<void> startPairing() async {
    _isPairing = true;
    _foundDeviceWaitingToConnect = false;
    _connected = false;
    notifyListeners();
  }

  Future<void> dataClear() async {
    _dataCnt = 0;
    _isUpdated = false;
    _lDataDIA.clear();
    _lDataPUL.clear();
    _lDataSYS.clear();
    notifyListeners();
  }

  Future<void> disConnectPairing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isSphyFairing", false);
    _isScanning = false;
    if (_scanStream != null) {
      try {
        _scanStream!.cancel();
      } catch (err) {
        log('$err');
      }
    }
    _foundDeviceWaitingToConnect = false;
    _connected = false;
    _isPairing = false;
    _isPaired = false;
    if (_timer != null) {
      _timer!.cancel();
    }
    notifyListeners();
  }

  Future<void> loadCounter() async {
    //YHR 추가  : 페어링 상태라면 기기인식 완료 라고 나오도록 추가함
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('isSphyFairing') == false) {
      prefs.setBool('isSphyFairing', false);
    }
    _isPaired = prefs.getBool('isSphyFairing')!;

    String id = prefs.getString('id') ?? '';

    // var ff = DateFormat('yyyy-MM-dd HH:mm:ss');
    _dtStart = DateTime.now();
    StreamSubscription<DiscoveredDevice>? _scanStream;

    _testID = id + '_bp';

    log('-------------------tiemr ON tttttttttttttttttttttttttttttttttttttt');
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (_iNeedDisconnect > 0) {
        _iNeedDisconnect--;
        if (_iNeedDisconnect == 0) {
          log("################ FORCE CLOSE BLE ###########");
          _isScanning = false;
          notifyListeners();
          if (_scanStream != null) {
            try {
              _scanStream.cancel();
            } catch (err) {
              log('$err');
            }
          }
          _foundDeviceWaitingToConnect = false;
          _connected = false;
          _isPairing = false;
          notifyListeners();
          try {
            Future.delayed(const Duration(milliseconds: 7000), () async {
              _isPaired = true;
              await prefs.setBool('isSphyFairing', true);
              notifyListeners();
            });
            _ble.deinitialize();
            _ble.initialize();
          } catch (err) {
            log('$err');
          }
        }
      }
      if (_isScanning == false) {
        await startScan();
      }

      // if (isUpdated) {
      //   _isUpdated = false;

      //   notifyListeners();
      //   // if (dataIsOK) {
      //   //   showSaveDialog(context);
      //   // }
      // }
    });
  }

  Future<void> startScan() async {
    _iFindCnt = 0;
    _isScanning = true;

    _ble.statusStream.listen((status) {
      if (status == BleStatus.poweredOff) {
      } else if (status == BleStatus.ready) {
      } else if (status == BleStatus.unauthorized) {}
    });

    if (true) {
      print('is _serviceUuid? $_serviceUuid');
      _scanStream =
          _ble.scanForDevices(withServices: [_serviceUuid]).listen((device) {
        log("########## SCAN = " + device.name);
        print('is device?? $device');
        // Change this string to what you defined in Zephyr
        if (device.name.contains('A&D_UA-651BLE')) {
          _iFindCnt++;
          log('##################### $_isPaired $isPairing $_foundDeviceWaitingToConnect $_connected');
          if ((_isPaired == false && isPairing == true) || _isPaired) {
            if (_foundDeviceWaitingToConnect == false) {
              _foundDeviceWaitingToConnect = true;
              _ubiqueDevice = device;
              notifyListeners();
              connectToDevice();
            }
          }
        }
      });

      _scanStream!.onDone(() {
        _isScanning = false;
        log('##################### SCAN END ###############');
      });
    }
    notifyListeners();
  }

  Future<void> connectToDevice() async {
    // We're done scanning, we can cancel it
    _scanStream!.cancel();
    _isScanning = false;
    notifyListeners();
    // Let's listen to our connection so we can make updates on a state change

    Stream<ConnectionStateUpdate> _currentConnectionStream =
        _ble.connectToAdvertisingDevice(
      id: _ubiqueDevice!.id,
      prescanDuration: const Duration(seconds: 5),
      connectionTimeout: const Duration(seconds: 2),
      withServices: [_serviceUuid],
      servicesWithCharacteristicsToDiscover: {
        _serviceUuid: [_bleRx, _bleTx]
      },
    );

    // Stream<ConnectionStateUpdate> _currentConnectionStream = _ble
    //     .connectToDevice(
    //   id: _ubiqueDevice.id,
    //   connectionTimeout: const Duration(seconds: 2),
    //   servicesWithCharacteristicsToDiscover: {serviceUuid: [bleRx, bleTx]},
    // );

    _currentConnectionStream.listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            _connected = true;
            notifyListeners();
            if (_isPairing) {
              _txCharacteristic = QualifiedCharacteristic(
                  serviceId: _serviceUuid,
                  characteristicId: _bleTx,
                  deviceId: event.deviceId);

              doSetTime();
              log("############### END OF PR ################");
            } else {
              _isPairing = false;
              // _isPaired = true;
              notifyListeners();
              try {
                _rxCharacteristic = QualifiedCharacteristic(
                  serviceId: _serviceUuid,
                  characteristicId: _bleRx,
                  deviceId: event.deviceId,
                );

                _ssRx = _ble.subscribeToCharacteristic(_rxCharacteristic!);

                _ssRx!.listen((data) {
                  try {
                    doPacket(data);
                    log("############### DATA  ################");
                  } catch (err) {
                    log('$err');
                  }
                }, onError: (dynamic error) {
                  log(error);
                });
              } catch (err) {
                log('$err');
              }
            }
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          {
            log("############### DISCONNECT ################");
            _iNeedDisconnect = 0;
            _connected = false;
            _foundDeviceWaitingToConnect = false;
            _timer!.cancel();
            notifyListeners();
            try {
              if (_ssRx != null) {
                _ssRx!.drain();
              }
              // _ble.deinitialize();
              // _ble.initialize();
            } catch (err) {
              log('$err');
            }
            break;
          }
        default:
      }
    });
  }

  Future<void> doSetTime() async {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    int hour = DateTime.now().hour;
    int min = DateTime.now().minute;
    int sec = DateTime.now().second;

    List<int> buf = [
      (year & 0x0FF), // year 2bit
      (year >> 8), //
      month, // month
      day, // day
      hour, // hour
      min, // min
      sec // sec
    ];

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await _ble.writeCharacteristicWithoutResponse(_txCharacteristic!,
          value: buf);
      _ble.deinitialize();
      _ble.initialize();
      _foundDeviceWaitingToConnect = false;
      _connected = false;

      _iNeedDisconnect = 3;
      if (_isPaired == false) {
        // showPairFinishDialog(context);
        _isPairing = false;
        // _isPaired = true;
        notifyListeners();
      }
    } catch (err) {
      log('$err');
    }
    try {
      _ble.deinitialize();
      _ble.initialize();
      notifyListeners();
    } catch (err) {
      log('$err');
    }
  }

  Future<void> doPacket(List<int> value) async {
    // 114 82 73
    // 22, 114, 0, 82, 0, 90, 0, 230, 7, 1, 7, 0, 29, 59, 73, 0, 4, 0

    // 116 75 87
    // 22, 116, 0, 75, 0, 87, 0, 230, 7, 1, 7, 1, 21, 55, 87, 0, 4, 0

    //if(this.mounted) {
    _isTestSave = 0;
    if (value.length >= 18) {
      if (value[1] == 0xFF && value[2] == 0x07) {
        //setState(() {
        _isResult = true;
        _dataIsOK = false;
        _dataState = "측정 오류";
        _isUpdated = true;
        notifyListeners();
        //});
      } else if (value[15] == 0x00 && value[16] == 0x08) {
        //setState(() {
        _isResult = true;
        _dataIsOK = false;
        _dataState = "범위 오류";
        _isUpdated = true;
        notifyListeners();
        //});
      } else {
        //setState(() {
        _isResult = true;
        _dataIsOK = true;
        _dataState = "측정 완료";
        _isUpdated = true;
        _dataCnt++;
        // _bleState = 3;
        _lDataSYS.add(value[1].toDouble());
        _lDataDIA.add(value[3].toDouble());
        _lDataPUL.add(value[14].toDouble());

        _dtStop = DateTime.now();
        //});
        //await flutterBlue.stopScan();
        //_timer.cancel();
        notifyListeners();
      }
    } else {
      // //setState(() {
      //   _isResult = true;
      //   dataIsOK = false;
      //   dataState = "측정 오류";
      // //});
    }
    //}
  }

  Future<Map<String, String>?> getBloodPressureOcr(String imgPath) async {
    try {
      var response = await ApiBp.getBloodPressureOcrService(imgPath: imgPath);
      log(response?.body ?? '');
      var result = [];
      if (response != null) {
        result = json.decode(response.body);
      } else {
        result.addAll([0, 0, 0]);
      }
      // int statusCode = response!.statusCode;
      // final data = json.decode(utf8.decode(response.bodyBytes));
      // log('ocr ParsedText: ${data['ParsedResults'][0]['ParsedText']}');
      // //필터작업

      return {"sys": result[0], "dia": result[1], "pul": result[2]};
    } catch (e) {
      return null;
    }
  }
}
