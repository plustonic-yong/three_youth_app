import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/enums.dart';

class HistoryProvider extends ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;

  HistoryTypes _historyType = HistoryTypes.ecg;
  HistoryTypes get historyType => _historyType;

  void onDaySelect(DateTime value) async {
    _selectedDay = value;
    notifyListeners();
  }

  void onChangeHistoryType(HistoryTypes value) {
    _historyType = value;
    notifyListeners();
  }
}
