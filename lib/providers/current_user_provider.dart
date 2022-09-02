// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class CurrentUser with ChangeNotifier {
  bool _isER2000S = true;
  String _id = '';
  String _pwd = '';
  String _name = '';
  String _height = '';
  String _weight = '';
  String _birthDate = '';
  bool _isMale = true;
  bool _isFairing = false;

  bool get isER2000S => _isER2000S;
  String get id => _id;
  String get pwd => _pwd;
  String get name => _name;
  String get height => _height;
  String get weight => _weight;
  String get birthDate => _birthDate;
  bool get isMale => _isMale;
  bool get isFairing => _isFairing;

  set isER2000S(bool value) {
    _isER2000S = value;
    notifyListeners();
  }

  set id(String value) {
    _id = value;
    notifyListeners();
  }

  set pwd(String value) {
    _pwd = value;
    notifyListeners();
  }

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set height(String value) {
    _height = value;
    notifyListeners();
  }

  set weight(String value) {
    _weight = value;
    notifyListeners();
  }

  set birthDate(String value) {
    _birthDate = value;
    notifyListeners();
  }

  set isMale(bool value) {
    _isMale = value;
    notifyListeners();
  }

  set isFairing(bool value) {
    _isFairing = value;
    notifyListeners();
  }
}
