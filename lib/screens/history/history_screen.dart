import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/history_provider.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/widget/common_button.dart';
import 'package:three_youth_app/widget/ecg/ecg_record_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDay = context.watch<HistoryProvider>().selectedDay;
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TableCalendar(
              locale: 'ko-KR',
              calendarFormat: CalendarFormat.week,
              focusedDay: _selectedDay,
              firstDay: DateTime(2000, 01, 01),
              lastDay: DateTime(2100, 12, 31),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 23.0),
                leftChevronIcon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 23.0,
                ),
                rightChevronIcon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 23.0,
                ),
              ),
              onDaySelected: (value, _) =>
                  context.read<HistoryProvider>().onDaySelect(value),
              selectedDayPredicate: (value) => isSameDay(_selectedDay, value),
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.white),
                weekdayStyle: TextStyle(color: Colors.white),
              ),
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: true,
                defaultTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(
                  color: ColorAssets.txtGrey,
                ),
                selectedDecoration: BoxDecoration(
                  color: ColorAssets.purpleGradient1,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                todayTextStyle: TextStyle(
                  color: ColorAssets.purpleGradient1,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            //심전도, 혈압계 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff000000).withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '심전도',
                        style: TextStyle(
                          color: ColorAssets.waterLevelWave1,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '혈압계',
                        style: TextStyle(
                          color: ColorAssets.txtGrey,
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
                    ),
                    const SizedBox(
                      height: kBottomNavigationBarHeight + 55.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
