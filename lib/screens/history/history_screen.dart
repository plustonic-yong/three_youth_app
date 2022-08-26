import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/models/bp.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/providers/history_provider.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/bp/bpRecordCard.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:three_youth_app/widget/history/history_month_calendar.dart';
import 'package:three_youth_app/widget/history/history_week_calendar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<BleBpProvider>().getBloodPressure(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    HistoryType _historyType = context.watch<HistoryProvider>().historyType;
    HistoryCalendarType _historyCalendarType =
        context.watch<HistoryProvider>().historyCalendarType;

    List<Bp>? _bpHistories = context.watch<BleBpProvider>().bpHistories;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: _historyCalendarType == HistoryCalendarType.week
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HistoryWeekCalendar(),
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
                                            measureDatetime: _bpHistories[index]
                                                .measureDatetime,
                                            sys: _bpHistories[index].sys,
                                            dia: _bpHistories[index].dia,
                                            pul: _bpHistories[index].pul,
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
                          const SizedBox(
                            height: kBottomNavigationBarHeight + 55.0,
                          ),
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
                    const HistoryMonthCalendar(),
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
                    const SizedBox(
                      height: kBottomNavigationBarHeight + 55.0,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
