import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  bool _isInfoAgreeChecked = false;
  bool get isInfoAgreeChecked => _isInfoAgreeChecked;
  bool _isTermsAgreeChecked = false;
  bool get isTermsAgreeChecked => _isTermsAgreeChecked;
  int _currentPage = 0;
  int get currentPage => _currentPage;
  bool _isButtonActive = false;
  bool get isButtonActive => _isButtonActive;

  void onChangeInfoAgree() {
    _isInfoAgreeChecked = !_isInfoAgreeChecked;
    notifyListeners();
  }

  void onChangeTermsAgree() {
    _isTermsAgreeChecked = !_isTermsAgreeChecked;
    notifyListeners();
  }

  void onChangeAgreementCurrentPage({required int page}) {
    _currentPage = page;
    notifyListeners();
  }
}
