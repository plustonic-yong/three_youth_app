import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common/common_button.dart';

class BleBpConnectPairingScreen extends StatefulWidget {
  const BleBpConnectPairingScreen({Key? key}) : super(key: key);

  @override
  State<BleBpConnectPairingScreen> createState() =>
      _BleBpConnectPairingTestScreenState();
}

class _BleBpConnectPairingTestScreenState
    extends State<BleBpConnectPairingScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  late SharedPreferences prefs;

  // int _bleState = 0;

  DateTime _dtStart = DateTime.now();
  DateTime _dtStop = DateTime.now();
  String _testID = '';
  int _isTest = 0;
  int _isTestSave = 0;

  int _isDemoSaveLocal = 0;

  int _iFindCnt = 0;

  int _iNeedDisconnect = 0;
  // --------------- BLE
  final _ble = FlutterReactiveBle();

  bool _foundDeviceWaitingToConnect = false;
  bool _connected = false;

  // StreamSubscription? _subscription;

  DiscoveredDevice? _ubiqueDevice;
  StreamSubscription<DiscoveredDevice>? _scanStream;

  Stream<List<int>>? _ssRx;

  QualifiedCharacteristic? _rxCharacteristic;
  QualifiedCharacteristic? _txCharacteristic;
// These are the UUIDs of your device
  final Uuid _serviceUuid = Uuid.parse("00001810-0000-1000-8000-00805f9b34fb");
  final Uuid _bleRx = Uuid.parse("00002a35-0000-1000-8000-00805f9b34fb");
  final Uuid _bleTx = Uuid.parse("00002a08-0000-1000-8000-00805f9b34fb");

  // static const String sUUIDService = "00001810-0000-1000-8000-00805f9b34fb";
  // // static const String sUUIDCharBloodPressureFeature =
  // //     "00002a49-0000-1000-8000-00805f9b34fb";
  // static const String sUUIDCharBloodPressureMeasurement =
  //     "00002a35-0000-1000-8000-00805f9b34fb";
  // static const String sUUIDCharDatetime =
  //     "00002a08-0000-1000-8000-00805f9b34fb";

  static List<double> _lDataSYS = [0];
  static List<double> _lDataDIA = [0];
  static List<double> _lDataPUL = [0];

  int _dataCnt = 0;
  bool _dataIsOK = false;
  String _dataState = "-";

  bool _isPairing = false;
  bool _isPaired = false;
  bool _isScanning = false;

  bool _isResult = false;
  static bool _isUpdated = false;

  Timer? _timer;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await context.read<BleBpProvider>().startPairing();
      prefs = await SharedPreferences.getInstance();

      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        isLoading = false;
      });

      await context.read<BleBpProvider>().loadCounter();
    });

    super.initState();
  }

  void dataClear() {
    _dataCnt = 0;
    _lDataDIA.clear();
    _lDataPUL.clear();
    _lDataSYS.clear();
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('기기 연동'),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () async {
          await context.read<BleBpProvider>().disConnectPairing();
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _isPairing = context.read<BleBpProvider>().isPairing;
    _isPaired = context.watch<BleBpProvider>().isPaired;
    _isScanning = context.read<BleBpProvider>().isScanning;
    _dtStart = context.read<BleBpProvider>().dtStart;
    _foundDeviceWaitingToConnect =
        context.read<BleBpProvider>().foundDeviceWaitingToConnect;
    _connected = context.read<BleBpProvider>().connected;
    _dtStart = context.read<BleBpProvider>().dtStart;
    _scanStream = context.read<BleBpProvider>().scanStream;
    _dtStart = context.read<BleBpProvider>().dtStart;
    _dtStop = context.read<BleBpProvider>().dtStop;
    _testID = context.read<BleBpProvider>().testID;
    _timer = context.read<BleBpProvider>().timer;
    _dtStop = context.read<BleBpProvider>().dtStop;
    _iNeedDisconnect = context.read<BleBpProvider>().iNeedDisconnect;
    _iFindCnt = context.read<BleBpProvider>().iFintCnt;
    _ubiqueDevice = context.read<BleBpProvider>().ubiqueDevice;
    _rxCharacteristic = context.read<BleBpProvider>().rxCharacteristic;
    _txCharacteristic = context.read<BleBpProvider>().txCharacteristic;
    _ssRx = context.read<BleBpProvider>().ssRx;
    _isTestSave = context.read<BleBpProvider>().isTestSave;
    _isResult = context.read<BleBpProvider>().isResult;
    _dataCnt = context.read<BleBpProvider>().dataCnt;
    _dataIsOK = context.read<BleBpProvider>().dataIsOK;
    _dataState = context.read<BleBpProvider>().dataState;
    _isUpdated = context.read<BleBpProvider>().isUpdated;
    _lDataSYS = context.read<BleBpProvider>().lDataSYS;
    _lDataDIA = context.read<BleBpProvider>().lDataDIA;
    _lDataPUL = context.read<BleBpProvider>().lDataPUL;
    return Stack(
      children: [
        //배경이미지
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('기기 연동'),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () async {
                await context.read<BleBpProvider>().disConnectPairing();
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: isLoading
              ? spinkit
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: _isPaired ? uiScan(context) : uiPairing(context),
                ),
        ),
      ],
    );
  }

  Widget uiScan(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        Center(
          child: Image.asset(
            'assets/images/sphygmomanometer_1@2x.png',
            width: 108.0,
          ),
        ),
        const SizedBox(height: 10.0),
        Image.asset(
          'assets/icons/ic_check_circle.png',
          width: 30.0,
        ),
        Container(
          child: const Text(
            "혈압계 연동 완료!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          margin: const EdgeInsets.all(20),
        ),
        const SizedBox(height: 50.0),
        const Text(
          "혈압계 연동 완료!\n혈압계 화면에 'End' 문자를\n확인하셨나요?\n이제 측정 기록이 스마트폰에\n자동으로 저장됩니다.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        CommonButton(
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          title: '측정화면으로 이동',
          buttonColor: ButtonColor.primary,
          onTap: () => Navigator.of(context).pushNamed('/scan/mesurement'),
        ),
        const SizedBox(height: 30.0)
      ],
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

  Widget uiPairing(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50.0),
          Image.asset(
            'assets/images/sphygmomanometer_1@2x.png',
            width: 108.0,
          ),
          // _isPairing
          //     ?
          Container(
            margin: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: Colors.purple,
              strokeWidth: 5,
            ),
          ),
          // const SizedBox(height: 50.0),
          const Text(
            "연동 중 입니다.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          CommonButton(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            title: '중단하기',
            buttonColor: ButtonColor.orange,
            onTap: () async {
              await context.read<BleBpProvider>().disConnectPairing();
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 30.0)
        ],
      ),
    );
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
            _dataState,
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
                _dataIsOK ? _lDataSYS.last.round().toString() : '-',
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
                _dataIsOK ? _lDataDIA.last.round().toString() : '-',
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
                _dataIsOK ? _lDataPUL.last.round().toString() : '-',
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

  Future<void> startPairing() async {
    await context.read<BleBpProvider>().startPairing();
  }
}
