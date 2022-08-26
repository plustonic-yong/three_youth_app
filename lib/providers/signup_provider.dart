import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/enums.dart';

class SignupProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  SignupState _signupState = SignupState.kakao;
  SignupState get signupState => _signupState;

  GenderState _gender = GenderState.woman;
  GenderState get gender => _gender;
  String _name = '';
  String get name => _name;
  String _height = '';
  String get height => _height;
  String _weight = '';
  String get weight => _weight;
  DateTime _birth = DateTime.now();
  DateTime get birth => _birth;

  TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  TextEditingController _heightController = TextEditingController();
  TextEditingController get heightController => _heightController;

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

  void onChangeHeight({required String value}) {
    _height = value;

    notifyListeners();
  }

  void onChangeWeight({required String value}) {
    _weight = value;

    notifyListeners();
  }

  // void onChangeYear({required String value}) {
  //   _year = value;
  //   notifyListeners();
  // }

  // void onChangeMonth({required String value}) {
  //   _month = value;
  //   notifyListeners();
  // }

  // void onChangeDay({required String value}) {
  //   _day = value;
  //   notifyListeners();
  // }

  void onChangeBirth({required DateTime value}) {
    // var _formatBirth = DateFormat('yyyy-MM-dd').format(value);
    // _birth = _formatBirth;
    _birth = value;
    notifyListeners();
  }

  void onChangeGender({required GenderState genderState}) {
    _gender = genderState;
    notifyListeners();
  }

  void onChangeSignupState({required SignupState value}) {
    _signupState = value;
    notifyListeners();
  }
}
