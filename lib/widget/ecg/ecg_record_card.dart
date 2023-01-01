import 'dart:io';
import 'dart:typed_data';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:three_youth_app/providers/ble_ecg_provider.dart';
import 'package:three_youth_app/providers/user_provider.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/pdf_mkr.dart';
import 'package:three_youth_app/utils/utils.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class EcgRecordCard extends StatefulWidget {
  final List<int> ecgLst;
  final DateTime time;
  final Duration duration;
  final int bpm;

  const EcgRecordCard({
    Key? key,
    required this.ecgLst,
    required this.time,
    required this.duration,
    required this.bpm,
  }) : super(key: key);

  @override
  State<EcgRecordCard> createState() => _EcgRecordCardState();
}

class _EcgRecordCardState extends State<EcgRecordCard> {
  WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    List<FlSpot> lDataECG1 = [];
    List<FlSpot> lDataECG2 = [];
    List<FlSpot> lDataECG3 = [];
    var cnt = 0;
    for (var i = 0; i < 500; i++) {
      lDataECG1.add(FlSpot(cnt.toDouble(), widget.ecgLst[i].toDouble()));
      cnt++;
      if (cnt == widget.ecgLst.length) break;
    }
    for (var i = 500; i < 1000; i++) {
      lDataECG2.add(FlSpot(cnt.toDouble(), widget.ecgLst[i].toDouble()));
      cnt++;
      if (cnt == widget.ecgLst.length) break;
    }
    for (var i = 1000; i < 1500; i++) {
      lDataECG3.add(FlSpot(cnt.toDouble(), widget.ecgLst[i].toDouble()));
      cnt++;
      if (cnt == widget.ecgLst.length) break;
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
                  GestureDetector(
                    onTap: () => _pdfShare(context),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: ColorAssets.waterLevelWave1,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Image.asset(
                        'assets/icons/ic_share.png',
                        width: 20.0,
                        height: 20.0,
                      ),
                    ),
                  ),
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
                controller: controller,
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
          drawHorizontalLine: true,
          drawVerticalLine: true,
          horizontalInterval: 1000,
          verticalInterval: 100,
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
