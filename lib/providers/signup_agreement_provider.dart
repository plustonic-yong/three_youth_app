import 'package:flutter/material.dart';

class SignupAgreementProvider extends ChangeNotifier {
  bool _isInfoAgreeChecked = false;
  bool get isInfoAgreeChecked => _isInfoAgreeChecked;
  bool _isTermsAgreeChecked = false;
  bool get isTermsAgreeChecked => _isTermsAgreeChecked;
  int _currentPage = 0;
  int get currentPage => _currentPage;

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
