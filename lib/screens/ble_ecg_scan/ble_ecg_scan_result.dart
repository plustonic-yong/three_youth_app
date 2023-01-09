import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:three_youth_app/models/ecg_value_model.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../utils/utils.dart';

class BleEcgScanResult extends StatefulWidget {
  final List<EcgValueModel> ecgLst;
  final List<FlSpot> lsData;
  final int bpm;
  final DateTime time;
  final Duration duration;
  final WidgetsToImageController controller;

  const BleEcgScanResult({
    Key? key,
    required this.ecgLst,
    required this.lsData,
    required this.time,
    required this.bpm,
    required this.duration,
    required this.controller,
  }) : super(key: key);

  @override
  State<BleEcgScanResult> createState() => _BleEcgScanResultState();
}

class _BleEcgScanResultState extends State<BleEcgScanResult> {
  List<FlSpot> lDataECG1 = [];
  List<FlSpot> lDataECG2 = [];
  List<FlSpot> lDataECG3 = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<int> tmp = [];
    for (var ecgValue in widget.ecgLst) {
      for (var lData in ecgValue.lDataECG) {
        tmp.add(lData.toInt());
      }
    }
    lDataECG1.clear();
    lDataECG2.clear();
    lDataECG3.clear();
    var cnt = 0;

    for (var i = 0; i < 500; i++) {
      lDataECG1.add(FlSpot(cnt.toDouble(), tmp[i].toDouble()));
      cnt++;
      if (cnt == tmp.length) break;
    }
    for (var i = 500; i < 1000; i++) {
      lDataECG2.add(FlSpot(cnt.toDouble(), tmp[i].toDouble()));
      cnt++;
      if (cnt == tmp.length) break;
    }
    for (var i = 1000; i < 1500; i++) {
      lDataECG3.add(FlSpot(cnt.toDouble(), tmp[i].toDouble()));
      cnt++;
      if (cnt == tmp.length) break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/electrocardiogram_1.png',
                      height: 80.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.formatDate(widget.time),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23.0,
                        ),
                      ),
                      Text(
                        Utils.formatTime(widget.time),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                ],
              ),
              const SizedBox(height: 15.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Divider(
                  color: Colors.white.withOpacity(0.5),
                  thickness: 1.0,
                  indent: 1.0,
                  endIndent: 1.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.duration.inSeconds}초 측정 기준',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.bpm.toString(),
                        style: const TextStyle(
                          color: Color(0xFFFFF898),
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      const Text(
                        'bpm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              WidgetsToImage(
                controller: widget.controller,
                child: Column(
                  children: [
                    SizedBox(
                        height: 50,
                        width: double.maxFinite,
                        child: LineChart(chartSetting(lDataECG1))),
                    const SizedBox(height: 8),
                    SizedBox(
                        height: 50,
                        width: double.maxFinite,
                        child: LineChart(chartSetting(lDataECG2))),
                    const SizedBox(height: 8),
                    SizedBox(
                        height: 50,
                        width: double.maxFinite,
                        child: LineChart(chartSetting(lDataECG3))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData chartSetting(data) => LineChartData(
        backgroundColor: Colors.white,
        lineTouchData: LineTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: false,
          drawVerticalLine: true,
        ),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            colors: [const Color(0xffFF8E2C)],
            barWidth: 1,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: false,
              colors: [const Color(0x00aa4cfc)],
            ),
            spots: data,
          )
        ],
      );
}
