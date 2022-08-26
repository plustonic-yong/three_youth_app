import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/enums.dart';

class UserProvider extends ChangeNotifier {
  String _profileImg = '';
  String get progileImg => _profileImg;
  GenderState _gender = GenderState.woman;
  GenderState get gender => _gender;
  String _name = '';
  String get name => _name;
  String _height = '';
  String get height => _height;
  String _weight = '';
  String get weight => _weight;
  String _year = '';
  String get year => _year;
  String _month = '';
  String get month => _month;
  String _day = '';
  String get day => _day;

  void onChangeHeight({required String value}) {
    _height = value;
    notifyListeners();
  }

  void onChangeWeight({required String value}) {
    _weight = value;
    notifyListeners();
  }
}
