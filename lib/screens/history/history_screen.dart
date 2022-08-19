import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/history_provider.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common_button.dart';
import 'package:three_youth_app/widget/ecg/ecg_record_card.dart';
import 'package:three_youth_app/widget/history/history_month_calendar.dart';
import 'package:three_youth_app/widget/history/history_week_calendar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoryType _historyType = context.watch<HistoryProvider>().historyType;
    HistoryCalendarType _historyCalendarType =
        context.watch<HistoryProvider>().historyCalendarType;

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
                            child: ListView(
                              children: [
                                ecgRecordCard(context: context),
                                ecgRecordCard(context: context),
                                ecgRecordCard(context: context),
                              ],
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
