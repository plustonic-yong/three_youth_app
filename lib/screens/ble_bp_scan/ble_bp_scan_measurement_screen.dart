import 'package:flutter/material.dart';
import 'package:three_youth_app/providers/ble_bp_scan_provider.dart';
import 'package:three_youth_app/screens/ble_bp_scan/components/ble_bp_scan_measurement_result.dart';
import 'package:three_youth_app/screens/ble_bp_scan/components/ble_bp_scan_measurement_scanning.dart';
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
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<BleBpScanProvider>().scanBp();
      // Provider.of<BleEcgScanProvider>(context, listen: false).scanEcg();
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    BpScanStatus _bpScanStatus =
        context.watch<BleBpScanProvider>().bpScanStatus;
    double _ecgSeconds = context.watch<BleBpScanProvider>().bpSeconds;

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
        _bpScanStatus == BpScanStatus.scanning
            ? const BleBpScanMeasurementScanning()
            : const BleBpScanMeasurementResult()
      ],
    );
  }
}
