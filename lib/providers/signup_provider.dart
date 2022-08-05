import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  void onChangeCurrentPage({required int page}) {
    _currentPage = page;
    notifyListeners();
  }
}
