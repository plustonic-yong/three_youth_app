import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/enums.dart';

class BleBpScanProvider extends ChangeNotifier {
  BpScanStatus _bpScanStatus = BpScanStatus.scanning;
  BpScanStatus get bpScanStatus => _bpScanStatus;

  double _bpSeconds = 0.0;
  double get bpSeconds => _bpSeconds;

  Future<void> scanBp() async {
    _bpScanStatus = BpScanStatus.scanning;
    await Future.delayed(const Duration(milliseconds: 3000), () {
      _bpScanStatus = BpScanStatus.scanning;
      notifyListeners();
    });

    await Future.delayed(const Duration(milliseconds: 3000), () {
      _bpScanStatus = BpScanStatus.complete;
      notifyListeners();
    });
  }
}
