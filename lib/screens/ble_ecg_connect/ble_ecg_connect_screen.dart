import 'dart:async';
import 'dart:convert' show utf8;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/services/php/classCubeAPI.dart';
import 'package:three_youth_app/screens/base/navigate_app_bar.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/screens/custom/common_button.dart';
import 'package:three_youth_app/screens/custom/gradient_small_button.dart';
import 'package:three_youth_app/screens/history/history_appscreen.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/toast.dart';

class BleECGConnectScreen extends StatefulWidget {
  const BleECGConnectScreen({Key? key}) : super(key: key);

  static BleECGConnectScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<BleECGConnectScreenState>();
  @override
  BleECGConnectScreenState createState() => BleECGConnectScreenState();
}

class BleECGConnectScreenState extends State<BleECGConnectScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  late SharedPreferences prefs;

  int _bleState = 0;

  late Timer _timer;

  // --------------- BLE
  //   // 6e400001-b5a3-f393-e0a9-e50e24dcca9e
  //   // 제3의청춘 ECG
  //   sUUIDService  : TBluetoothUUID = '{6E400001-B5A3-F393-E0A9-E50E24DCCA9E}';
  //   sUUIDRx       : TBluetoothUUID = '{6E400003-B5A3-F393-E0A9-E50E24DCCA9E}';
  //   sUUIDTx       : TBluetoothUUID = '{6E400002-B5A3-F393-E0A9-E50E24DCCA9E}';  // 44 45 42 55 47 31 13
  static const String sBLEDevice = "er2000_smart_v2.1";

  static const String sUUIDService = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
  static const String sUUIDRx = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
  static const String sUUIDTx = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";

  static const String sUUIDCharBloodPressureFeature =
      "00002a49-0000-1000-8000-00805f9b34fb";
  static const String sUUIDCharBloodPressureMeasurement =
      "00002a35-0000-1000-8000-00805f9b34fb";
  static const String sUUIDCharDatetime =
      "00002a08-0000-1000-8000-00805f9b34fb";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? bleDevice;

  BluetoothCharacteristic? bleCharRx;
  BluetoothCharacteristic? bleCharTx;

  BluetoothCharacteristic? bleCharBloodPressureFeature;
  BluetoothCharacteristic? bleCharBloodPressureMeasurement;
  BluetoothCharacteristic? bleCharDatetime;

  List<double> lDataECG = [];
  List<DateTime> lTimeECG = [];
  List<String> lSQLECG = [];

  int dataCnt = 0;
  bool dataIsOK = false;

  //late Timer _timer;
  int isLoad = 0;

  double xMin = 0;
  double xMax = 1;
  double yMin = 0;
  double yMax = 0;

  List<DateTime> lTimes = [];
  List<FlSpot> lsData = [];

  TDataSet ds = TDataSet();

  int isDemo = 0;

  DateTime dtStart = DateTime.now();
  DateTime dtStop = DateTime.now();
  String testID = '';
  int isTest = 0;
  int isTestSave = 0;

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

    // tttttttttttttttttttttttttttttttttt
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (isDemo == 1) {
        List<int> ll = [];

        for (int i = 0; i < 10; i++) {
          ll.add(38);
          ll.add(i + 100);
        }
        doPacket(ll);
      }
      if (mounted) {
        if (dataCnt > 0) {
          setState(() {});
        }
      }
    });

    super.initState();
  }

  void dataClear() {
    dataCnt = 0;
    lDataECG.clear();
    lTimeECG.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorAssets.commonBackgroundDark,
      appBar: const NavigateAppBar(),
      //drawer: ,
      body: SingleChildScrollView(
        child: isLoading
            ? spinkit
            : Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),

                    InkWell(
                      splashFactory: InkRipple.splashFactory,
                      onTap: () {
                        isDemo = 1;
                      },
                      child: const Text(
                        'ER-2000S 심전도 측정',
                        style: TextStyle(
                            color: ColorAssets.fontDarkGrey,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _bleState != 0 ? uiRx() : uiConnect(),
                    const SizedBox(
                      height: 30,
                    ),

                    (isTest == 0)
                        ? getStartButton()
                        : (isTest == 1)
                            ? getStopButton()
                            : getResult(),
                    //
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // // 3) 데이터얻기
                    // GradientSmallButton(
                    //   width: _screenWidth * 0.6,
                    //   height: 60,
                    //   radius: 50.0,
                    //   child: const Text(
                    //     '데이터 수신',
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(color: ColorAssets.white, fontWeight: FontWeight.w500, fontSize: 18.0),
                    //   ),
                    //   gradient: const LinearGradient(
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //     colors: <Color>[ColorAssets.greenGradient1, ColorAssets.purpleGradient2],
                    //   ),
                    //   onPressed: () {
                    //     doOpenBLE();
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 30,
                    // ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget getStartButton() {
    return GradientSmallButton(
      width: _screenWidth * 0.6,
      height: 60,
      radius: 50.0,
      child: const Text(
        '측정 시작',
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
        await doTestStart();

        if (await Permission.contacts.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
        }

        setState(() {
          _bleState = 1;
        });

        // You can request multiple permissions at once.
        Map<Permission, PermissionStatus> statuses = await [
          Permission.bluetoothScan,
          Permission.bluetooth,
          Permission.bluetoothAdvertise,
          Permission.bluetoothConnect,
        ].request();
        //print(statuses[Permission.location]);

        if (bleDevice != null) {
          await bleDevice!.disconnect();
        }
        bleDevice = null;

        flutterBlue.startScan(timeout: const Duration(seconds: 10));

        flutterBlue.scanResults.listen((results) async {
          print('####### Found = ${results.length}');
          for (ScanResult r in results) {
            if (r.device.name.startsWith(sBLEDevice)) {
              // ignore: avoid_print
              print('####### ${r.device.name} found! rssi: ${r.rssi}');
              if (bleDevice == null) {
                bleDevice = r.device;
                await flutterBlue.stopScan();
                // Connect to the device
                await r.device.connect();

                List<BluetoothService> services =
                    await r.device.discoverServices();
                // ignore: avoid_function_literals_in_foreach_calls
                services.forEach((service) async {
                  print('####### Service UUID = ${service.uuid.toString()}');

                  if (service.uuid.toString().toUpperCase() == sUUIDService) {
                    // Reads all characteristics
                    var characteristics = service.characteristics;

                    for (BluetoothCharacteristic c in characteristics) {
                      print('####### Character UUID = ${c.uuid.toString()}');
                      if (c.uuid.toString().toUpperCase() == sUUIDTx) {
                        bleCharTx = c;
                        //44 45 42 55 47 3d 31 13
                        List<int> bytes = utf8.encode("DEBUG=1\r\n");
                        for (int i = 0; i < bytes.length; i++) {
                          print('####### ${i} = ${bytes[i].toString()}');
                        }
                        c.write(bytes);
                        //await r.device.disconnect();
                        //await prefs.setBool('isSphyFairing', true);

                      } else if (c.uuid.toString().toUpperCase() == sUUIDRx) {
                        bleCharRx = c;
                        await c.setNotifyValue(true);
                        c.value.listen((value) {
                          // ignore: avoid_print
                          // print("DATA--------------");
                          // // ignore: avoid_print
                          // print(value);
                          // // ignore: avoid_print
                          // print("DATA------END-----");

                          doPacket(value);
                        });
                      }
                    }
                  }
                });
                break;
              }
            }
          }
        });
      },
    );
  }

  Widget getStopButton() {
    return GradientSmallButton(
      width: _screenWidth * 0.6,
      height: 60,
      radius: 50.0,
      child: const Text(
        '측정 종료',
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
        await doTestStop();
      },
    );
  }

  // rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
  Widget getResult() {
    return Column(
      children: [
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
                  //Navigator.pushNamed(context, '/history');
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
    // return Container(
    //     decoration: BoxDecoration(
    //       color: ColorAssets.white,
    //       borderRadius: BorderRadius.all(
    //         Radius.circular(20),
    //       ),
    //       border: Border.all(
    //         color: ColorAssets.borderGrey,
    //         width: 1,
    //       ),
    //     ),
    //     width: _screenWidth * 0.8,
    //     padding: const EdgeInsets.only(right: 10, left: 10),
    //     height: 310,
    //     child: Column(
    //       children: const [
    //         SizedBox(
    //           height: 20,
    //         ),
    //
    //         Text(
    //           "데이터 개수 : ",
    //           style: TextStyle(
    //               color: Colors.black87,
    //               fontSize: 16,
    //               fontWeight: FontWeight.bold),
    //           textAlign: TextAlign.left,
    //         ),
    //       ],
    //     ));
  }

  // 111111111111111111111111111
  void doPacket(List<int> value) async {
    if (_bleState != 3) {
      _bleState = 3;
    }

    // if(isTest != 1)
    //   {
    //     return;
    //   }

    dataCnt++;
    while (lsData.length >= 200) {
      //lDataECG.removeAt(0);
      lsData.removeAt(0);
      //dataCnt--;
    }

    String sdata = '';
    var ff = DateFormat('yyyy-MM-dd HH:mm:ss');
    sdata = "'" + ff.format(DateTime.now()) + "', '";

    for (int i = 0; i < value.length - 1; i++) {
      int i1 = value[i];
      // int i2 = value[i + 1];
      double dv = i1.toDouble(); // (i1 * 256 + i2).toDouble();

      //lTimeECG.add(DateTime.now());
      lDataECG.add(dv);
      lsData.add(FlSpot(dataCnt.toDouble(), dv));
      dataCnt++;

      if (i == 0) {
        sdata = sdata + dv.toString();
      } else {
        sdata = sdata + ',' + dv.toString();
      }
    }
    sdata = sdata + "' ";
    lSQLECG.add(sdata);
    //setState(() {});
  }

  String getBleState() {
    String rr = "";

    if (isTest == 2) {
      return "측정 종료";
    }

    if (_bleState == 0) {
      rr = "대기중...";
    } else if (_bleState == 1) {
      rr = "검색중...";
    } else if (_bleState == 2) {
      rr = "기기 인식 완료";
    } else if (_bleState == 3) {
      rr = "데이터 측정 중...";
    }

    return rr;
  }

  Widget uiConnect() {
    return Container(
        decoration: BoxDecoration(
          color: ColorAssets.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: ColorAssets.borderGrey,
            width: 1,
          ),
        ),
        width: _screenWidth * 0.8,
        padding: const EdgeInsets.only(right: 10, left: 10),
        height: 310,
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
              '1. 페어링이 되어있지 않다면, 먼저 페어링을 해야됩니다. 기기의 전원 버튼을 길게 누르고 페어링 시작을 누르십시오. 핸드폰에서 승인을 누른 뒤, end 가 기기에 표시되면 페어링이 완료된 상태입니다.',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '2. 페어링이 완료되었으면, 기기 전원버튼을 눌러서 측정을 시작하고 데이터 수신을 누르십시오.',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  Widget uiRx() {
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
      height: 250,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            getBleState(),
            style: const TextStyle(
                color: ColorAssets.fontDarkGrey,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: getChart(),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData get chartSetting => LineChartData(
        lineTouchData: chartTouch,
        gridData: bloodPressureGridData,
        titlesData: chartGetLabel,
        borderData: bloodPressureBorderData,
        lineBarsData: lcDataList,
        // minX: xMin,
        // maxX: xMax,
        // maxY: yMin,
        // minY: yMax,
      );

  LineTouchData get chartTouch => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white,
        ),
      );

  FlTitlesData get chartGetLabel => FlTitlesData(
        bottomTitles: chartGetXLabel,
        leftTitles: chartGetYLabel,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
      );

  List<LineChartBarData> get lcDataList => [
        lcData,
      ];

  SideTitles get chartGetYLabel => SideTitles(
        showTitles: true,
        interval: 5,
        getTextStyles: (context, value) => const TextStyle(
          color: ColorAssets.fontDarkGrey,
          // fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        getTitles: (value) {
          int idx = value.toInt();

          //if(idx % 10 == 0)
          {
            return value.toString();
          }
          // else{
          //   return "";
          // }
        },
      );

  SideTitles get chartGetXLabel => SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: ColorAssets.fontDarkGrey,
          // fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
        getTitles: (value) {
          int idx = value.toInt();

          if (idx < lTimes.length) {
            var ff = DateFormat('HH:mm');
            String sx = ff.format(lTimes[idx]);
            return sx;
          } else {
            return "";
          }
        },
      );

  FlGridData get bloodPressureGridData => FlGridData(show: true);

  FlBorderData get bloodPressureBorderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lcData => LineChartBarData(
        isCurved: true,
        colors: [const Color(0xff134fad)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          colors: [
            const Color(0x00aa4cfc),
          ],
        ),
        spots: lsData,
      );

  Future<TDataSet> getChartData() async {
    TCubeAPI ca = TCubeAPI();

    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? '';

    String eq = id;

    //await ds.getDataSet(sql);

    lsData.clear();
    lTimes.clear();

    xMin = 0;
    xMax = 0;
    yMin = 0;
    yMax = 0;

    double idx = 0;
    for (int r = 0; r < ds.getRowCount(); r++) {
      TRow dr = ds.rows[r];

      String sdt = dr.value('datatime');
      DateTime dt = DateTime.parse(sdt);

      String s1 = dr.value('ext');
      final sa = s1.split(',');
      for (int c = 0; c < sa.length; c++) {
        String sv = sa[c];
        double? dd = double.tryParse(sv);
        if (dd != null) {
          lsData.add(FlSpot(idx, dd));
          lTimes.add(dt);
          idx++;
        }
      }
    }

    // setState(() {
    //
    // });

    isLoad = 0;

    return ds;
  }

  Widget getChart() {
    if (lsData.isEmpty) {
      return const Text(
        '-',
        style: TextStyle(
            color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }
    return LineChart(
      chartSetting,
      //swapAnimationDuration: const Duration(seconds: 1), // Optional
      //swapAnimationCurve: Curves.linear, // Optional
    );
  }

  Future<void> doTestStart() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? '';

    var ff = DateFormat('yyyy-MM-dd HH:mm:ss');
    dtStart = DateTime.now();

    testID = id + '_ecg';

    // String sql = "insert into test_list ";
    // sql += " (eq, start) values (";
    // sql += " '${id}', '${ff.format(dtStart)}";
    // sql += ") ";
    //
    // TCubeAPI ca=TCubeAPI();
    // await ca.sqlExecPost(sql);

    setState(() {
      isTest = 1;
    });
  }

  Future<void> doTestStop() async {
    if (bleDevice != null) {
      await bleDevice!.disconnect();
    }
    bleDevice = null;

    dtStop = DateTime.now();

    // SharedPreferences prefs;
    // prefs = await SharedPreferences.getInstance();
    // String id = prefs.getString('id') ?? '';
    //
    // var ff = DateFormat('yyyy-MM-dd HH:mm:ss');
    // testState = id + '_ecg';
    //
    // String sql = "update test_list set ";
    // sql += " stop = '${ff.format(DateTime.now())} ";
    // sql += " where eq = '${id}' and start = '${ff.format(dtStart)}' ";
    //
    // TCubeAPI ca=TCubeAPI();
    // await ca.sqlExecPost(sql);

    setState(() {
      isTest = 2;
    });
  }

  Future<void> doTestSave() async {
    if (isTestSave == 1) {
      showToast('이미 저장되었습니다.');
      return;
    }
    var ff = DateFormat('yyyy-MM-dd HH:mm:ss');

    String sql = "insert into test_list ";
    sql += " (eq, start, stop, datacnt) values (";
    sql +=
        " '${testID}', '${ff.format(dtStart)}', '${ff.format(dtStop)}', ${lsData.length}";
    sql += ") ";

    TCubeAPI ca = TCubeAPI();
    String sr = await ca.sqlExecPost(sql);

    if (sr == "TRUE") {
      isTestSave = 1;
    }

    sql = "insert into raw (eq, tag, datatime, ext) values ";
    String sql2 = "";

    List<String> ll = [];

    int icnt = 0;
    int i = 0;
    while (i < lSQLECG.length) {
      sql2 = " ('$testID', 'ecg', " + lSQLECG[i] + ") ";
      ll.add(sql2);

      icnt++;
      i++;

      if (icnt > 100) {
        String sql3 = sql + ll.join(",") + ";";
        ca.sqlExecPost(sql3);
        icnt = 0;
      }
    }
    if (icnt > 0) {
      String sql3 = sql + ll.join(",") + ";";
      ca.sqlExecPost(sql3);
      icnt = 0;
    }

    showToast('보관함에 저장 했습니다.');
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
    String url = await ca.getPDFUrl(sql);

    Share.share(url);
  }
}
