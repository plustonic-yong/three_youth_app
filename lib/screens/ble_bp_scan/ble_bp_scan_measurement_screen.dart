import 'package:flutter/material.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/screens/ble_bp_scan/ble_bp_scan_measurement_result.dart';
import 'package:three_youth_app/screens/ble_bp_scan/ble_bp_scan_measurement_scanning.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as foundation;

class BleBpScanMesurementScreen extends StatefulWidget {
  const BleBpScanMesurementScreen({Key? key}) : super(key: key);

  @override
  State<BleBpScanMesurementScreen> createState() =>
      _BleBpScanMesurementScreenState();
}

class _BleBpScanMesurementScreenState extends State<BleBpScanMesurementScreen> {
  double botomNavigationBarHeight =
      foundation.defaultTargetPlatform == foundation.TargetPlatform.android
          ? kBottomNavigationBarHeight + 27.0
          : 140.0;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<BleBpProvider>().dataClear();
      await context.read<BleBpProvider>().loadCounter();
      // Provider.of<BleEcgScanProvider>(context, listen: false).scanEcg();
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    BpScanStatus _bpScanStatus = context.watch<BleBpProvider>().bpScanStatus;
    bool _isScanning = context.watch<BleBpProvider>().isScanning;
    bool _dataIsOK = context.watch<BleBpProvider>().dataIsOK;
    bool _isUpdated = context.watch<BleBpProvider>().isUpdated;

    return Stack(
      children: [
        //배경이미지
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        _isUpdated
            ? const BleBpScanMeasurementResult()
            : const BleBpScanMeasurementScanning()
      ],
    );
  }
}
