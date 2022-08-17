import 'dart:async';

import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/enums.dart';

class BleEcgScanProvider extends ChangeNotifier {
  EcgScanStatus _ecgScanStatus = EcgScanStatus.waiting;
  EcgScanStatus get ecgScanStatus => _ecgScanStatus;

  double _ecgSeconds = 0.0;
  double get ecgSeconds => _ecgSeconds;

  Future<void> scanEcg() async {
    _ecgScanStatus = EcgScanStatus.waiting;
    await Future.delayed(const Duration(milliseconds: 3000), () {
      _ecgScanStatus = EcgScanStatus.scanning;
      notifyListeners();
    });

    await Future.delayed(const Duration(milliseconds: 3000), () {
      _ecgScanStatus = EcgScanStatus.complete;
      notifyListeners();
    });
  }

  // void countEcgSeconds() async {
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     _ecgSeconds = _ecgSeconds + 10.0;
  //     notifyListeners();
  //   });
  //   print(_ecgSeconds);
  // }
}
