import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/screens/history/prev/history_appscreen.dart';
import 'package:three_youth_app/services/php/classCubeAPI.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/screens/custom/common_button.dart';
import 'package:three_youth_app/screens/custom/gradient_small_button.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/toast.dart';

class PrevBleBPConnectScreen extends StatefulWidget {
  const PrevBleBPConnectScreen({Key? key}) : super(key: key);

  static PrevBleBPConnectScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<PrevBleBPConnectScreenState>();
  @override
  PrevBleBPConnectScreenState createState() => PrevBleBPConnectScreenState();
}

class PrevBleBPConnectScreenState extends State<PrevBleBPConnectScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  late SharedPreferences prefs;

  // int _bleState = 0;

  DateTime dtStart = DateTime.now();
  DateTime dtStop = DateTime.now();
  String testID = '';
  int isTest = 0;
  int isTestSave = 0;

  int isDemoSaveLocal = 0;

  int iFindCnt = 0;

  int iNeedDisconnect = 0;
  // --------------- BLE
  final _ble = FlutterReactiveBle();

  bool _foundDeviceWaitingToConnect = false;
  bool _connected = false;

  // StreamSubscription? _subscription;

  late DiscoveredDevice _ubiqueDevice;
  late StreamSubscription<DiscoveredDevice> _scanStream;

  late Stream<List<int>> ssRx;

  late QualifiedCharacteristic _rxCharacteristic;
  late QualifiedCharacteristic _txCharacteristic;
// These are the UUIDs of your device
  final Uuid serviceUuid = Uuid.parse("00001810-0000-1000-8000-00805f9b34fb");
  final Uuid bleRx = Uuid.parse("00002a35-0000-1000-8000-00805f9b34fb");
  final Uuid bleTx = Uuid.parse("00002a08-0000-1000-8000-00805f9b34fb");

  // static const String sUUIDService = "00001810-0000-1000-8000-00805f9b34fb";
  // // static const String sUUIDCharBloodPressureFeature =
  // //     "00002a49-0000-1000-8000-00805f9b34fb";
  // static const String sUUIDCharBloodPressureMeasurement =
  //     "00002a35-0000-1000-8000-00805f9b34fb";
  // static const String sUUIDCharDatetime =
  //     "00002a08-0000-1000-8000-00805f9b34fb";

  static List<double> lDataSYS = [0];
  static List<double> lDataDIA = [0];
  static List<double> lDataPUL = [0];

  int dataCnt = 0;
  bool dataIsOK = false;
  String dataState = "-";

  bool isPairing = false;
  bool _isPaired = false;
  bool _isScanning = false;

  bool _isResult = false;
  static bool isUpdated = false;

  late Timer _timer;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();

      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        isLoading = false;
      });
    });

    super.initState();

    _loadCounter();
  }

  _loadCounter() async {
    //YHR 추가  : 페어링 상태라면 기기인식 완료 라고 나오도록 추가함
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        if (prefs.containsKey('isSphyFairing') == false) {
          prefs.setBool('isSphyFairing', false);
        }
        _isPaired = prefs.getBool('isSphyFairing')!;
      });
    }

    String id = prefs.getString('id') ?? '';

    // var ff = DateFormat('yyyy-MM-dd HH:mm:ss');
    dtStart = DateTime.now();

    testID = id + '_bp';

    debugPrint(
        '-------------------tiemr ON tttttttttttttttttttttttttttttttttttttt');
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (iNeedDisconnect > 0) {
        iNeedDisconnect--;
        if (iNeedDisconnect == 0) {
          debugPrint("################ FORCE CLOSE BLE ###########");
          setState(() {
            _isScanning = false;
            if (_scanStream != null) {
              try {
                _scanStream.cancel();
              } catch (err) {
                debugPrint('$err');
              }
            }
            _foundDeviceWaitingToConnect = false;
            _connected = false;
            isPairing = false;
          });
          try {
            _ble.deinitialize();
            _ble.initialize();
          } catch (err) {
            debugPrint('$err');
          }
        }
      }

      if (_isScanning == false) {
        _startScan();
      }

      if (mounted) {
        if (isUpdated) {
          isUpdated = false;

          if (dataIsOK) {
            showSaveDialog(context);
          }
          setState(() {
            debugPrint("-------------------UPDATE");
          });
        }
      }
    });
  }

  void dataClear() {
    dataCnt = 0;
    lDataDIA.clear();
    lDataPUL.clear();
    lDataSYS.clear();
  }

  // Widget getAppBar() {
  //   return AppBar(
  //     iconTheme: const IconThemeData(color: Colors.black),
  //     elevation: 0,
  //     backgroundColor: ColorAssets.white,
  //     leading: SizedBox(
  //       width: 50,
  //       child: IconButton(
  //         icon: const Icon(
  //           Icons.arrow_back,
  //           color: ColorAssets.fontDarkGrey,
  //         ),
  //         onPressed: () {
  //           if (_isResult) {
  //             setState(() {
  //               _isResult = false;
  //             });
  //           } else {
  //             Navigator.pushNamedAndRemoveUntil(
  //                 context, '/main', (route) => false);
  //           }
  //         },
  //       ),
  //     ),
  //     title: InkWell(
  //       onTap: () {
  //         //Navigator.pushNamedAndRemoveUntil(context, '/overview', (route) => false);
  //       },
  //       child: Image.asset(
  //         'assets/images/logo_bg_none.png',
  //         width: 320,
  //         height: 65,
  //       ),
  //     ),
  //     centerTitle: true,
  //     actions: const [
  //       SizedBox(
  //         width: 55,
  //       )
  //     ],
  //   );
  // }

  Widget getAppBar() {
    return AppBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorAssets.commonBackgroundDark,
      //appBar: getAppBar(),
      //drawer: ,
      body: SingleChildScrollView(
        child: isLoading
            ? spinkit
            : Center(
                child: Column(
                  children: [
                    getAppBar(),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      splashFactory: InkRipple.splashFactory,
                      onTap: () {
                        doDemo();
                        if (mounted) {
                          setState(() {
                            isPairing = false;
                            _isPaired = true;
                          });
                        }
                      },
                      child: const Text(
                        'UA-651BLE 혈압 측정',
                        style: TextStyle(
                            color: ColorAssets.fontDarkGrey,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _isResult ? uiResult() : uiMain(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget uiMain() {
    return Column(
      children: [
        uiManual(),
        const SizedBox(
          height: 20,
        ),
        _isPaired ? uiScan() : uiPairing(),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget uiScan() {
    return Column(
      children: [
        Container(
          child: const Text(
            "(페어링 완료)데이터 수신 대기 중 입니다.",
            style: TextStyle(fontSize: 18),
          ),
          margin: const EdgeInsets.all(20),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: const CircularProgressIndicator(
            backgroundColor: Colors.grey,
            color: Colors.purple,
            strokeWidth: 5,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GradientSmallButton(
          width: _screenWidth * 0.6,
          height: 60,
          radius: 50.0,
          child: const Text(
            '페어링 해제하기',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorAssets.white,
                fontWeight: FontWeight.w500,
                fontSize: 18.0),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              ColorAssets.greenGradient1,
              ColorAssets.purpleGradient2
            ],
          ),
          onPressed: () async {
            showAlertDialog(context);
          },
        ),
      ],
    );
  }

  showSaveDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("취소"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("보관함 저장"),
      onPressed: () async {
        doTestSave();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("보관함 저장"),
      content: const Text("데이터 측정이 완료 되었습니다.\n보관함에 저장 하시겠습니까?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("취소"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("연결해지"),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isSphyFairing", false);

        // private void unpairDevice(BluetoothDevice device) {
        //   try {
        //     Method m = device.getClass()
        //         .getMethod("removeBond", (Class[]) null);
        //     m.invoke(device, (Object[]) null);
        //   } catch (Exception e) {
        //   Log.e(TAG, e.getMessage());
        //   }
        // }

        _isScanning = false;
        if (_scanStream != null) {
          try {
            _scanStream.cancel();
          } catch (err) {
            debugPrint('$err');
          }
        }
        _foundDeviceWaitingToConnect = false;
        _connected = false;

        if (mounted) {
          setState(() {
            _isPaired = false;
          });
        }
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("이미 기기가 페어링 되어 있습니다."),
      content: const Text("페어링 해지를 원하시면 연결해지를 클릭하세요."),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showPairFinishDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: const Text("확인"),
      onPressed: () {
        //Navigator.pushNamed(context, '/main');
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("페어링 완료"),
      content: const Text("페어링이 완료 되었습니다. 페어링 이후에는 측정 데이터는 자동 인식 됩니다."),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showPairAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("취소"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("페어링하기"),
      onPressed: () async {
        if (mounted) {
          setState(() {
            isPairing = true;
          });
        }
        _foundDeviceWaitingToConnect = false;
        _connected = false;
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("페어링 시작하기"),
      content: const Text("방법 : 기기의 START 버튼을 3초이상 누르면 Pr이 표시됩니다."),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget uiPairing() {
    return Column(
      children: [
        isPairing
            ? Container(
                child: Column(
                  children: [
                    const Text(
                      "장치를 스캔 중 입니다.",
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: const CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                        color: Colors.purple,
                        strokeWidth: 5,
                      ),
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(20),
              )
            : const SizedBox(height: 10),
        isPairing
            ? GradientSmallButton(
                width: _screenWidth * 0.6,
                height: 60,
                radius: 50.0,
                child: const Text(
                  '페어링 취소',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorAssets.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    ColorAssets.greenGradient1,
                    ColorAssets.purpleGradient2
                  ],
                ),
                onPressed: () async {
                  setState(() {
                    _isScanning = false;
                    if (_scanStream != null) {
                      try {
                        _scanStream.cancel();
                      } catch (err) {
                        debugPrint('$err');
                      }
                    }
                    _foundDeviceWaitingToConnect = false;
                    _connected = false;
                    isPairing = false;
                  });
                  try {
                    _ble.deinitialize();
                    _ble.initialize();
                  } catch (err) {
                    debugPrint('$err');
                  }
                },
              )
            : GradientSmallButton(
                width: _screenWidth * 0.6,
                height: 60,
                radius: 50.0,
                child: const Text(
                  '페어링 시작',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorAssets.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    ColorAssets.greenGradient1,
                    ColorAssets.purpleGradient2
                  ],
                ),
                onPressed: () async {
                  showPairAlertDialog(context);
                },
              ),
      ],
    );
  }

  Widget uiManual() {
    return Container(
        decoration: BoxDecoration(
          color: ColorAssets.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: ColorAssets.borderGrey,
            width: 1,
          ),
        ),
        width: _screenWidth * 0.8,
        padding: const EdgeInsets.only(right: 10, left: 10),
        //height: 310,
        child: Column(
          children: const [
            SizedBox(
              height: 20,
            ),
            Text(
              '사용 방법',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '1. 페어링이 되어있지 않다면, 먼저 페어링을 해야됩니다. 하단의 "페어링 시작" 버튼을 누르면, 앱은 기기를 검색하기 시작합니다.',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '2. 기기의 전원 버튼을 길게 누르면 기기에 "Pr" 문자가 표시되며, 페어링 모드로 진입합니다. 잠시 후 앱은 페어링을 완료하고 기기에 "End" 표시되며 페어링이 완료됩니다.',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '2. 페어링이 된 후에는, 기기에서 측정이 종료되었을때 데이터는 자동 수신됩니다.',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ));
  }

  Widget uiData() {
    return Container(
      decoration: BoxDecoration(
        color: ColorAssets.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(
          color: ColorAssets.borderGrey,
          width: 1,
        ),
      ),
      width: _screenWidth * 0.8,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            dataState,
            style: const TextStyle(
                color: ColorAssets.fontDarkGrey,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                dataIsOK ? lDataSYS.last.round().toString() : '-',
                style: const TextStyle(
                    color: ColorAssets.fontDarkGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Text(
                'SYS.(mmHg)',
                style: TextStyle(
                    color: ColorAssets.fontDarkGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                dataIsOK ? lDataDIA.last.round().toString() : '-',
                style: const TextStyle(
                    color: ColorAssets.fontDarkGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Text(
                'DIA.(mmHg)',
                style: TextStyle(
                    color: ColorAssets.fontDarkGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                dataIsOK ? lDataPUL.last.round().toString() : '-',
                style: const TextStyle(
                    color: ColorAssets.fontDarkGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Text(
                'PUL.(/min)   ',
                style: TextStyle(
                    color: ColorAssets.fontDarkGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  // rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
  Widget uiResult() {
    return Column(
      children: [
        uiData(),
        const SizedBox(height: 20),
        SizedBox(
          width: _screenWidth * 0.8,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            CommonButton(
                screenWidth: _screenWidth * 0.35,
                txt: '보관함 저장',
                onPressed: () {
                  doTestSave();
                }),
            CommonButton(
                screenWidth: _screenWidth * 0.35,
                txt: 'PDF 공유',
                onPressed: () {
                  doTestPDF();
                }),
          ]),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: _screenWidth * 0.8,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            CommonButton(
                screenWidth: _screenWidth * 0.35,
                txt: '히스토리',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HistoryAppScreen()),
                  );
                }),
            CommonButton(
                screenWidth: _screenWidth * 0.35,
                txt: '예방 콘텐츠',
                onPressed: () {
                  Navigator.pushNamed(context, '/safecontent');
                }),
          ]),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  void _startScan() async {
    // bool permGranted = false;

    setState(() {
      iFindCnt = 0;
      _isScanning = true;
    });

    _ble.statusStream.listen((status) {
      if (status == BleStatus.poweredOff) {
      } else if (status == BleStatus.ready) {
      } else if (status == BleStatus.unauthorized) {}
    });

    if (true) {
      _scanStream =
          _ble.scanForDevices(withServices: [serviceUuid]).listen((device) {
        debugPrint("########## SCAN = " + device.name);
        // Change this string to what you defined in Zephyr
        if (device.name.contains('A&D_UA-651BLE')) {
          setState(() {
            iFindCnt++;
          });
          debugPrint(
              '##################### $_isPaired $isPairing $_foundDeviceWaitingToConnect $_connected');
          if ((_isPaired == false && isPairing == true) || _isPaired) {
            if (_foundDeviceWaitingToConnect == false) {
              setState(() {
                _foundDeviceWaitingToConnect = true;
                _ubiqueDevice = device;
              });
              _connectToDevice();
            }
          }
        }
      });

      _scanStream.onDone(() {
        _isScanning = false;
        debugPrint('##################### SCAN END ###############');
      });
    }
  }

  void _connectToDevice() {
    // We're done scanning, we can cancel it
    _scanStream.cancel();
    setState(() {
      _isScanning = false;
    });
    // Let's listen to our connection so we can make updates on a state change

    Stream<ConnectionStateUpdate> _currentConnectionStream =
        _ble.connectToAdvertisingDevice(
      id: _ubiqueDevice.id,
      prescanDuration: const Duration(seconds: 5),
      connectionTimeout: const Duration(seconds: 2),
      withServices: [serviceUuid],
      servicesWithCharacteristicsToDiscover: {
        serviceUuid: [bleRx, bleTx]
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
            setState(() {
              _connected = true;
            });
            if (isPairing) {
              _txCharacteristic = QualifiedCharacteristic(
                  serviceId: serviceUuid,
                  characteristicId: bleTx,
                  deviceId: event.deviceId);

              doSetTime();
              debugPrint("############### END OF PR ################");
            } else {
              setState(() {
                isPairing = false;
                _isPaired = true;
              });
              try {
                _rxCharacteristic = QualifiedCharacteristic(
                    serviceId: serviceUuid,
                    characteristicId: bleRx,
                    deviceId: event.deviceId);

                ssRx = _ble.subscribeToCharacteristic(_rxCharacteristic);

                ssRx.listen((data) {
                  try {
                    doPacket(data);
                    debugPrint("############### DATA  ################");
                  } catch (err) {
                    debugPrint('$err');
                  }
                }, onError: (dynamic error) {
                  debugPrint(error);
                });
              } catch (err) {
                debugPrint('$err');
              }
            }
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          {
            debugPrint("############### DISCONNECT ################");
            iNeedDisconnect = 0;
            setState(() {
              _connected = false;
              _foundDeviceWaitingToConnect = false;
            });
            try {
              if (ssRx != null) {
                ssRx.drain();
              }
              // _ble.deinitialize();
              // _ble.initialize();
            } catch (err) {
              debugPrint('$err');
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
      await _ble.writeCharacteristicWithoutResponse(_txCharacteristic,
          value: buf);
      _ble.deinitialize();
      _ble.initialize();
      _foundDeviceWaitingToConnect = false;
      _connected = false;

      iNeedDisconnect = 3;
      if (_isPaired == false) {
        await prefs.setBool('isSphyFairing', true);
        showPairFinishDialog(context);
        if (mounted) {
          setState(() {
            isPairing = false;
            _isPaired = true;
          });
        }
      }
    } catch (err) {
      debugPrint('$err');
    }
    try {
      _ble.deinitialize();
      _ble.initialize();
    } catch (err) {
      debugPrint('$err');
    }
  }

  void doPacket(List<int> value) async {
    // 114 82 73
    // 22, 114, 0, 82, 0, 90, 0, 230, 7, 1, 7, 0, 29, 59, 73, 0, 4, 0

    // 116 75 87
    // 22, 116, 0, 75, 0, 87, 0, 230, 7, 1, 7, 1, 21, 55, 87, 0, 4, 0

    //if(this.mounted) {
    isTestSave = 0;
    if (value.length >= 18) {
      if (value[1] == 0xFF && value[2] == 0x07) {
        //setState(() {
        _isResult = true;
        dataIsOK = false;
        dataState = "측정 오류";
        isUpdated = true;
        //});
      } else if (value[15] == 0x00 && value[16] == 0x08) {
        //setState(() {
        _isResult = true;
        dataIsOK = false;
        dataState = "범위 오류";
        isUpdated = true;
        //});
      } else {
        //setState(() {
        _isResult = true;
        dataIsOK = true;
        dataState = "측정 완료";
        isUpdated = true;
        dataCnt++;
        // _bleState = 3;
        lDataSYS.add(value[1].toDouble());
        lDataDIA.add(value[3].toDouble());
        lDataPUL.add(value[14].toDouble());

        dtStop = DateTime.now();
        //});
        //await flutterBlue.stopScan();
        //_timer.cancel();
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

  // String getBleState() {
  //   String rr = "";
  //
  //   if (_bleState == 0) {
  //     rr = "대기중...";
  //   } else if (_bleState == 1) {
  //     rr = "측정중...";
  //   } else if (_bleState == 2) {
  //     rr = "기기 인식 완료";
  //   } else if (_bleState == 3) {
  //     rr = "데이터 측정 완료";
  //   }
  //
  //   return rr;
  // }

  Future<void> doTestSave() async {
    if (isTestSave == 1) {
      showToast('이미 저장되었습니다.');
      return;
    }

    dtStart = DateTime.now();
    dtStop = DateTime.now();

    var ff = DateFormat('yyyy-MM-dd HH:mm:ss');

    String sql = "insert into test_list ";
    sql += " (eq, start, stop, value1, value2, value3) values (";
    sql += " '$testID', '${ff.format(dtStart)}', '${ff.format(dtStop)}'";
    sql += " ,${lDataSYS.last.toString()}";
    sql += " ,${lDataDIA.last.toString()}";
    sql += " ,${lDataPUL.last.toString()}";
    sql += ") ";

    TCubeAPI ca = TCubeAPI();
    String sr = await ca.sqlExecPost(sql);

    // File
    if (sr != 'TRUE' || isDemoSaveLocal == 1) {
      isDemoSaveLocal = 0;
      try {
        var dfSave = DateFormat('yyyyMMdd');
        String fileSave = dfSave.format(dtStart) + '.txt';
        CubeStorage cs = CubeStorage(fileSave);

        // String sFrom = ff.format(dtStart);
        // String sTo = ff.format(dtStop);
        // String s1 = lDataSYS.last.toString();
        // String s2 = lDataDIA.last.toString();
        // String s3 = lDataPUL.last.toString();

        // String sMsg = '$testID,$sFrom,$sTo,$s1,$s2,$s3\n';

        cs.writeFile(sql + '\n');
      } catch (e) {
        showToast(e.toString());
        debugPrint(e.toString());
      }
      showToast('서버에 저장할 수 없어 로컬에 저장 했습니다.');
    } else {
      isTestSave = 1;
      showToast('보관함에 저장 했습니다.');
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();

    debugPrint('-------------------timer OFF');
    _timer.cancel();

    try {
      _scanStream.cancel();
    } on Exception {}
  }

  Future<void> doTestPDF() async {
    if (isTestSave == 0) {
      showToast('보관함에 먼저 저장해야 합니다.');
      return;
    }

    var ff = DateFormat('yyyy-MM-dd HH:mm:ss');

    TCubeAPI ca = TCubeAPI();
    String sql = "select * from test_list ";
    sql += " where eq = '$testID' ";
    sql += " and start = '${ff.format(dtStart)}' ";
    sql += " and stop = '${ff.format(dtStop)}'";

    String idx = await ca.sqlToText(sql);
    if (idx == '' || idx.isEmpty) {
      showToast('보관함에서 데이터를 읽어오는데 에러가 발생했습니다.');
      return;
    }

    sql = idx;
    String url = await ca.getPDFUrl(sql);

    Share.share(url);
  }

  void doDemo() {
    // //setState(() {
    // if (_bleState < 2) {
    //   _bleState++;
    // } else {
    //   _bleState = 3;
    List<int> ll = [
      22,
      114,
      0,
      82,
      0,
      90,
      0,
      230,
      7,
      1,
      7,
      0,
      29,
      59,
      73,
      0,
      4,
      0
    ];
    isDemoSaveLocal = 1;
    doPacket(ll);
    // }
    // // });
  }
}
