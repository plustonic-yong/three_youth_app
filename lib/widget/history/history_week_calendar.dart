import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/providers/history_provider.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:provider/provider.dart';

class HistoryWeekCalendar extends StatelessWidget {
  const HistoryWeekCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDay = context.watch<HistoryProvider>().selectedDay;
    return TableCalendar(
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
      onDaySelected: (value, _) {
        context.read<HistoryProvider>().onDaySelect(value);
        context.read<BleBpProvider>().getBloodPressure(value);
      },
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
    );
  }
}
