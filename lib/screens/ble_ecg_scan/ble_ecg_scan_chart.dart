import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/ble_ecg_provider.dart';

class BleEcgScanChart extends StatefulWidget {
  const BleEcgScanChart({Key? key}) : super(key: key);

  @override
  State<BleEcgScanChart> createState() => _BleEcgScanChartState();
}

/// State class of the realtime line chart.
class _BleEcgScanChartState extends State<BleEcgScanChart> {
  List<FlSpot> lsData = [];

  @override
  Widget build(BuildContext context) {
    lsData = context.watch<BleEcgProvider>().lsData;
    return SizedBox(
        height: 122, width: double.maxFinite, child: LineChart(chartSetting));
  }

  LineChartData get chartSetting => LineChartData(
        lineTouchData: chartTouch,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lcDataList,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(show: false);

  LineTouchData get chartTouch => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.black),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: chartGetXLabel,
        leftTitles: chartGetYLabel,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
      );

  SideTitles get chartGetXLabel => SideTitles(showTitles: false);

  SideTitles get chartGetYLabel => SideTitles(showTitles: false);

  List<LineChartBarData> get lcDataList => [lcData];

  LineChartBarData get lcData => LineChartBarData(
        isCurved: true,
        colors: [Colors.white],
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          colors: [Colors.white],
        ),
        spots: lsData,
      );
}
