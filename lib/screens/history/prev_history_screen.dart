import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:three_youth_app/models/bp_model.dart';
import 'package:three_youth_app/models/ecg_model.dart';
import 'package:three_youth_app/models/user_model.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/providers/ble_ecg_provider.dart';
import 'package:three_youth_app/providers/history_provider.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/utils/pdf_mkr.dart';
import 'package:three_youth_app/widget/bp/bpRecordCard.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:three_youth_app/widget/ecg/ecg_record_card.dart';
import 'package:three_youth_app/widget/history/history_month_calendar.dart';
import 'package:three_youth_app/widget/history/history_week_calendar.dart';

import '../../providers/user_provider.dart';

class PrevHistoryScreen extends StatefulWidget {
  const PrevHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PrevHistoryScreen> createState() => _PrevHistoryScreenState();
}

class _PrevHistoryScreenState extends State<PrevHistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<BleBpProvider>().getBloodPressure(DateTime.now());
      await context.read<BleEcgProvider>().getEcg(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    HistoryType _historyType = context.watch<HistoryProvider>().historyType;
    HistoryCalendarType _historyCalendarType =
        context.watch<HistoryProvider>().historyCalendarType;

    List<BpModel>? _bpHistories = context.watch<BleBpProvider>().bpHistories;
    List<BpModel>? _bpAllHistories =
        context.watch<BleBpProvider>().bpAllHistories;
    List<EcgModel>? _ecgHistories =
        context.watch<BleEcgProvider>().ecgHistories;
    List<EcgModel>? _ecgAllHistories =
        context.watch<BleEcgProvider>().ecgAllHistories;
    UserModel? _userInfo = context.watch<UserProvider>().userInfo;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/bg.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('이전 기록'),
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: _historyCalendarType == HistoryCalendarType.week
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HistoryWeekCalendar(
                        bpList: _bpAllHistories,
                        ecgList: _ecgAllHistories,
                        historyType: _historyType),
                    //심전도, 혈압계 선택
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => context
                              .read<HistoryProvider>()
                              .onChangeHistoryType(HistoryType.ecg),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: _historyType == HistoryType.ecg
                                  ? const Color(0xff000000).withOpacity(0.5)
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '심전도',
                                style: TextStyle(
                                  color: _historyType == HistoryType.ecg
                                      ? ColorAssets.waterLevelWave1
                                      : ColorAssets.txtGrey,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context
                              .read<HistoryProvider>()
                              .onChangeHistoryType(HistoryType.bp),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: _historyType == HistoryType.bp
                                  ? const Color(0xff000000).withOpacity(0.5)
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '혈압계',
                                style: TextStyle(
                                  color: _historyType == HistoryType.bp
                                      ? ColorAssets.waterLevelWave1
                                      : ColorAssets.txtGrey,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xff000000).withOpacity(0.5),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: _historyType == HistoryType.bp
                                  ? _bpHistories!.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: _bpHistories.length,
                                          itemBuilder: (context, index) {
                                            return bpRecordCard(
                                              context: context,
                                              measureDatetime:
                                                  _bpHistories[index]
                                                      .measureDatetime,
                                              sys: _bpHistories[index].sys,
                                              dia: _bpHistories[index].dia,
                                              pul: _bpHistories[index].pul,
                                              onShared: () => _pdfShare(
                                                context,
                                                _userInfo!,
                                                _bpHistories[index],
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text(
                                            '혈압 측정 기록이 없습니다.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 23.0,
                                            ),
                                          ),
                                        )
                                  : _ecgHistories!.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: _ecgHistories.length,
                                          itemBuilder: (context, index) {
                                            return EcgRecordCard(
                                              duration: Duration(
                                                  seconds: _ecgHistories[index]
                                                      .duration),
                                              time: _ecgHistories[index]
                                                  .measureDatetime,
                                              ecgLst:
                                                  _ecgHistories[index].lDataECG,
                                              bpm: _ecgHistories[index].bpm,
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text(
                                            '심전도 측정 기록이 없습니다.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 23.0,
                                            ),
                                          ),
                                        ),
                            ),
                            const SizedBox(height: 10.0),
                            CommonButton(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width,
                              title: '월별보기',
                              buttonColor: ButtonColor.primary,
                              onTap: () => context
                                  .read<HistoryProvider>()
                                  .onChangeHistoryCalendarType(
                                    HistoryCalendarType.month,
                                  ),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      HistoryMonthCalendar(
                          bpList: _bpAllHistories,
                          ecgList: _ecgAllHistories,
                          historyType: _historyType),
                      const Spacer(),
                      CommonButton(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        title: '주간 별 보기',
                        buttonColor: ButtonColor.primary,
                        onTap: () => context
                            .read<HistoryProvider>()
                            .onChangeHistoryCalendarType(
                              HistoryCalendarType.week,
                            ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  _pdfShare(context, UserModel userInfo, BpModel? bpData) async {
    var pdf = await PdfMkr.getPdfForBp(userInfo, bpData!);

    final output = await getTemporaryDirectory();
    if (await output.exists()) {
      final file = File(
          '${output.path}/${DateTime.now().millisecondsSinceEpoch}_혈압계.pdf');
      await file.writeAsBytes(await pdf.save());
      await Share.shareFiles([file.path]);
    }
  }
}
