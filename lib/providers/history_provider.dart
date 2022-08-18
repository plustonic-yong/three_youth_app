import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;

  void onDaySelect(DateTime value) async {
    _selectedDay = value;
    notifyListeners();
  }
}
