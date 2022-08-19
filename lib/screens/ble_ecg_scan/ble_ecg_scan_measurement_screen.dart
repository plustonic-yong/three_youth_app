import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:three_youth_app/providers/ble_ecg_scan_provider.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/widget/ecg/ecg_record_card.dart';

class BleEcgScanMeasurementScreen extends StatefulWidget {
  const BleEcgScanMeasurementScreen({Key? key}) : super(key: key);

  @override
  State<BleEcgScanMeasurementScreen> createState() =>
      _BleEcgScanMeasurementScreenState();
}

class _BleEcgScanMeasurementScreenState
    extends State<BleEcgScanMeasurementScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<BleEcgScanProvider>().scanEcg();
      // Provider.of<BleEcgScanProvider>(context, listen: false).scanEcg();
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    EcgScanStatus _ecgScanStatus =
        context.watch<BleEcgScanProvider>().ecgScanStatus;
    double _ecgSeconds = context.watch<BleEcgScanProvider>().ecgSeconds;
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
        _ecgScanStatus == EcgScanStatus.waiting
            ? _getWaiting(screenWidth: _screenWidth)
            : _ecgScanStatus == EcgScanStatus.scanning
                ? _getScanning(screenWidth: _screenWidth)
                : _getScanningResult(screenWidth: _screenWidth),
      ],
    );
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
          // crossAxisAlignment: CrossAxisAlignment.center,
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
                '심전계 상부 전극판(금속판)에 오른손\n손가락을 왼쪽 가슴 밑에 심전계 하부\n전극판을 접촉한 후 기기의 "O" 버튼을\n누르면 측정이 시작됩니다.',
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
        children: [
          const SizedBox(height: 280.0),
          Container(
            width: screenWidth,
            height: 1.0,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 180.0),
          Stack(
            children: [
              Container(
                width: 100.0,
                height: 50.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF849D),
                ),
              ),
              Container(
                width: 300.0,
                height: 50.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(
          //   height: 80.0,
          //   child: PieChart(
          //     PieChartData(
          //         sections: data,
          //         centerSpaceRadius: 60.0,
          //         startDegreeOffset: 270.0
          //         // sectionsSpace: 10.0,

          //         ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _getScanningResult({required double screenWidth}) {
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
            const SizedBox(height: 40.0),
            ecgRecordCard(context: context),
            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 25.0),
            //   decoration: BoxDecoration(
            //     color: Colors.white.withOpacity(0.2),
            //     borderRadius: BorderRadius.circular(10.0),
            //   ),
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 25.0),
            //         child: Row(
            //           children: [
            //             Image.asset('assets/images/electrocardiogram_1.png'),
            //             const SizedBox(width: 20.0),
            //             Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: const [
            //                 Text(
            //                   '2022.7.05(화)',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 23.0,
            //                   ),
            //                 ),
            //                 Text(
            //                   '오후 7:21',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 23.0,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(height: 15.0),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 25.0),
            //         child: SizedBox(
            //           width: MediaQuery.of(context).size.width,
            //           child: Divider(
            //             color: Colors.white.withOpacity(0.5),
            //             thickness: 1.0,
            //             indent: 1.0,
            //             endIndent: 1.0,
            //           ),
            //         ),
            //       ),
            //       Column(
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 25.0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 const Text(
            //                   '30초 측정 기준',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 20.0,
            //                   ),
            //                 ),
            //                 Row(
            //                   children: const [
            //                     Text(
            //                       '158',
            //                       style: TextStyle(
            //                         color: Color(0xFFFFF898),
            //                         fontSize: 28.0,
            //                         fontWeight: FontWeight.bold,
            //                       ),
            //                     ),
            //                     SizedBox(width: 5.0),
            //                     Text(
            //                       'bpm',
            //                       style: TextStyle(
            //                         color: Colors.white,
            //                         fontSize: 20.0,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           )
            //         ],
            //       ),
            //       const SizedBox(height: 180.0),
            //       const Divider(
            //         color: Colors.white,
            //         thickness: 1.0,
            //         indent: 1.0,
            //         endIndent: 1.0,
            //       ),
            //       const SizedBox(height: 60.0),
            //     ],
            //   ),
            // ),
            const Spacer(),
            CommonButton(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              title: '이전 측정 결과와 비교',
              buttonColor: ButtonColor.inactive,
            ),
            const SizedBox(height: 30.0),
            CommonButton(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              title: '측정 결과 공유',
              buttonColor: ButtonColor.inactive,
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
      color: Color(0xFFFF849D),
      showTitle: false,
    ),
    PieChartSectionData(
      value: 80.0,
      color: Colors.transparent,
      showTitle: false,
    ),
  ];
}
