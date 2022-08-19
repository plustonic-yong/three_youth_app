import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/enums.dart';

class HistoryProvider extends ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;

  HistoryType _historyType = HistoryType.ecg;
  HistoryType get historyType => _historyType;

  HistoryCalendarType _historyCalendarType = HistoryCalendarType.week;
  HistoryCalendarType get historyCalendarType => _historyCalendarType;

  void onDaySelect(DateTime value) async {
    _selectedDay = value;
    notifyListeners();
  }

  void onChangeHistoryType(HistoryType value) {
    _historyType = value;
    notifyListeners();
  }

  void onChangeHistoryCalendarType(HistoryCalendarType value) {
    _historyCalendarType = value;
    notifyListeners();
  }
}
