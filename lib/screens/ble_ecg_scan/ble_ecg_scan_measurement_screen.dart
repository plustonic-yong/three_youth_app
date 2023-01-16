import 'dart:io';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:three_youth_app/models/ecg_model.dart';
import 'package:three_youth_app/providers/user_provider.dart';
import 'package:three_youth_app/screens/ble_ecg_scan/ble_ecg_scan_result.dart';
import 'package:three_youth_app/screens/history/prev_history_screen.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/utils/pdf_mkr.dart';
import 'package:three_youth_app/utils/toast.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:provider/provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../models/ecg_value_model.dart';
import '../../providers/ble_ecg_provider.dart';
import 'ble_ecg_scan_chart.dart';

class BleEcgScanMeasurementScreen extends StatefulWidget {
  const BleEcgScanMeasurementScreen({Key? key}) : super(key: key);

  @override
  State<BleEcgScanMeasurementScreen> createState() =>
      _BleEcgScanMeasurementScreenState();
}

class _BleEcgScanMeasurementScreenState
    extends State<BleEcgScanMeasurementScreen> {
  int _bleEcgState = 0;
  bool _isSave = false;
  bool _isLoading = false;
  late DateTime _time;
  EcgModel? _ecgData;

  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();
// to save image bytes of widget
  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<BleEcgProvider>(context, listen: false).bleEcgState = 0;
      Provider.of<BleEcgProvider>(context, listen: false).lsData.clear();
      Provider.of<BleEcgProvider>(context, listen: false).lDataECG.clear();
      Provider.of<BleEcgProvider>(context, listen: false)
          .startScanAndConnect(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    _bleEcgState = context.watch<BleEcgProvider>().bleEcgState;
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
        _buildMeasure(_screenWidth),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  _buildMeasure(_screenWidth) {
    if (_bleEcgState == 0) {
      return _getWaiting(screenWidth: _screenWidth);
    } else if (_bleEcgState == 1) {
      return _getScanning(screenWidth: _screenWidth);
    } else if (_bleEcgState == 2) {
      return _getScanningResult(screenWidth: _screenWidth);
    }
  }

  Widget _getWaiting({required double screenWidth}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('측정준비'),
      ),
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 40.0),
            Center(
              child: Image.asset(
                'assets/images/electrocardiogram_1@2x.png',
                width: 100.0,
              ),
            ),
            const SizedBox(height: 20.0),
            const Center(
              child: Text(
                '심전계의 측정이 시작되면\n이 화면은 자동으로 닫힙니다.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.all(25.0),
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                '외부 심전도 케이블을 장치에 연결한 후\n일회용 심전도 전극을 각각 왼쪽(노랑)과\n오른쪽(빨강)가슴, 왼쪽 배(흰색)에\n부착한 후 OK 버튼을 누릅니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 2.0,
                ),
              ),
            ),
            const Spacer(),
            CommonButton(
              height: 50.0,
              width: screenWidth,
              title: '이전 화면으로',
              buttonColor: ButtonColor.inactive,
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _getScanning({required double screenWidth}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('실시간 심전도 측정'),
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const BleEcgScanChart(),
          const SizedBox(height: 100),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: CommonButton(
              width: double.maxFinite,
              height: 40,
              title: '측정 중단',
              buttonColor: ButtonColor.primary,
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(30.0),
                        actionsPadding: const EdgeInsets.all(10.0),
                        actions: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Text(
                              '취소',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          GestureDetector(
                            onTap: () async {
                              await Provider.of<BleEcgProvider>(context,
                                      listen: false)
                                  .stopMeasure();
                              _time = DateTime.now();
                              Provider.of<BleEcgProvider>(context,
                                      listen: false)
                                  .bleEcgState = 2;

                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              '확인',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                        content: const Text(
                          '측정을 중단하시겠습니까?',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getScanningResult({required double screenWidth}) {
    var dataLst = Provider.of<BleEcgProvider>(context, listen: false).lDataECG;
    var bpm = _calBpm(dataLst);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('심전도 측정 기록'),
      ),
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            BleEcgScanResult(
                lsData:
                    Provider.of<BleEcgProvider>(context, listen: false).lsData,
                controller: controller,
                ecgLst: dataLst,
                bpm: bpm,
                duration: dataLst.last.measureDatetime
                    .difference(dataLst.first.measureDatetime),
                time: _time),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: '결과저장',
                    buttonColor: ButtonColor.primary,
                    fontSize: 16.0,
                    onTap: () => _dataSave(bpm, dataLst),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: 'PDF 공유',
                    buttonColor:
                        _isSave ? ButtonColor.primary : ButtonColor.inactive,
                    fontSize: 16.0,
                    onTap: () =>
                        _isSave ? _pdfShare(context) : showToast('결과를 저장해주세요.'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: '이전기록',
                    buttonColor: ButtonColor.inactive,
                    fontSize: 16.0,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PrevHistoryScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: '홈으로',
                    buttonColor: ButtonColor.inactive,
                    fontSize: 16.0,
                    onTap: () {
                      context.read<BleEcgProvider>().dataClear();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/main', (route) => false);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> data = [
    PieChartSectionData(
      value: 20.0,
      color: const Color(0xFFFF849D),
      showTitle: false,
    ),
    PieChartSectionData(
      value: 80.0,
      color: Colors.transparent,
      showTitle: false,
    ),
  ];

  _calBpm(List<EcgValueModel> dataLst) {
    try {
      var r = 0.0;
      List<DateTime> timeLst = [];
      for (var i = 0; i < dataLst.length; i++) {
        for (var j = 0; j < dataLst[i].lDataECG.length; j++) {
          if (dataLst[i].lDataECG[j] > r || dataLst[i].lDataECG[j] < 10000) {
            r = dataLst[i].lDataECG[j];
          } else {
            r = 0.0;
            timeLst.add(dataLst[i].measureDatetime);
          }
        }
      }

      List<int> difLst = [];
      for (var i = 0; i < timeLst.length; i++) {
        if (i != timeLst.length - 1) {
          difLst.add(timeLst[i + 1].difference(timeLst[i]).inMilliseconds);
        }
      }

      difLst = difLst.where((e) => e != 0).toList();
      Duration diffTime = dataLst.last.measureDatetime
          .difference(dataLst.first.measureDatetime);
      double difAvg = 0;
      for (var dif in difLst) {
        difAvg += (dif * 0.001);
      }
      difAvg /= difLst.length;
      return (diffTime.inSeconds / difAvg).round();
    } catch (e) {
      return 0;
    }
  }

  _dataSave(int bpm, List<EcgValueModel> ecgValueModel) async {
    try {
      setState(() => _isLoading = true);
      List<int> tmp = [];
      for (var ecgValue in ecgValueModel) {
        for (var lData in ecgValue.lDataECG) {
          tmp.add(lData.toInt());
        }
      }
      List<int> lDataECG = [];
      var cnt = 0;
      for (var i = 0; i < tmp.length; i++) {
        if (cnt > 10000) break;
        lDataECG.add(tmp[i]);
        cnt++;
      }
      Duration diffTime = ecgValueModel.last.measureDatetime
          .difference(ecgValueModel.first.measureDatetime);

      var bytes = await controller.capture();
      var usrInfo = Provider.of<UserProvider>(context, listen: false).userInfo;

      var pdf = await PdfMkr.getPdfForEcg(
          usrInfo!,
          EcgModel(
            bpm: bpm,
            lDataECG: lDataECG,
            duration: diffTime.inSeconds,
            measureDatetime: DateTime.now(),
            regDatetime: '',
          ),
          bytes!);

      final output = await getTemporaryDirectory();
      final file = File(
          '${output.path}/${DateTime.now().millisecondsSinceEpoch}_심전계.pdf');
      await file.writeAsBytes(await pdf.save());

      var result = await context.read<BleEcgProvider>().postEcg(
            bpm: bpm,
            lDataECG: lDataECG,
            duration: diffTime.inSeconds,
            pdfPath: file.path,
          );

      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(30.0),
              actionsPadding: const EdgeInsets.all(10.0),
              actions: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
              content: Text(
                // ignore: unrelated_type_equality_checks
                result ? '데이터 저장에 성공했습니다.' : '데이터 저장에 실패했습니다.',
                style: const TextStyle(fontSize: 18.0),
              ),
            );
          });
      if (result) {
        _isSave = true;
        await context.read<BleEcgProvider>().getLastEcg();
      } else {
        _isSave = false;
      }
    } catch (e) {
      _isSave = false;
      showToast(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  _pdfShare(context) async {
    var bytes = await controller.capture();
    var usrInfo = Provider.of<UserProvider>(context, listen: false).userInfo;
    var ecgData =
        Provider.of<BleEcgProvider>(context, listen: false).lastEcgHistory;
    var pdf = await PdfMkr.getPdfForEcg(usrInfo!, ecgData!, bytes!);
    final output = await getTemporaryDirectory();
    final file =
        File('${output.path}/${DateTime.now().millisecondsSinceEpoch}_심전계.pdf');
    await file.writeAsBytes(await pdf.save());
    await Share.shareFiles([file.path]);
  }
}
