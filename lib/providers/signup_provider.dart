import 'package:flutter/material.dart';

enum GenderState {
  woman,
  man,
}

class SignupProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  GenderState _gender = GenderState.woman;
  GenderState get gender => _gender;
  String _name = '';
  String get name => _name;
  String _tall = '';
  String get tall => _tall;
  String _weight = '';
  String get weight => _weight;
  String _year = '';
  String get year => _year;
  String _month = '';
  String get month => _month;
  String _day = '';
  String get day => _day;

  TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  TextEditingController _tallController = TextEditingController();
  TextEditingController get tallController => _tallController;

  TextEditingController _weightController = TextEditingController();
  TextEditingController get weightController => _weightController;

  TextEditingController _yearController = TextEditingController();
  TextEditingController get yearController => _yearController;

  TextEditingController _monthController = TextEditingController();
  TextEditingController get monthController => _monthController;

  TextEditingController _dayController = TextEditingController();
  TextEditingController get dayController => _dayController;

  void onChangeCurrentPage({required int page}) {
    _currentPage = page;
    notifyListeners();
  }

  void onChangeName({required String value}) {
    _name = value;
    notifyListeners();
  }

  void onChangeTall({required String value}) {
    _tall = value;

    notifyListeners();
  }

  void onChangeWeight({required String value}) {
    _weight = value;

    notifyListeners();
  }

  void onChangeYear({required String value}) {
    _year = value;
    notifyListeners();
  }

  void onChangeMonth({required String value}) {
    _month = value;
    notifyListeners();
  }

  void onChangeDay({required String value}) {
    _day = value;
    notifyListeners();
  }

  void onChangeGender({required GenderState genderState}) {
    _gender = genderState;
    notifyListeners();
  }
}
