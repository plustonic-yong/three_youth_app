import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/screens/ble_bp_scan/ble_bp_scan_camera_result_screen.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/utils/toast.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:provider/provider.dart';

import '../../utils/color.dart';

class BleBpScanCameraScreen extends StatefulWidget {
  const BleBpScanCameraScreen({Key? key}) : super(key: key);

  @override
  State<BleBpScanCameraScreen> createState() => _BleBpScanCameraScreenState();
}

class _BleBpScanCameraScreenState extends State<BleBpScanCameraScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
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
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text('측정결과 촬영'),
          ),
          backgroundColor: Colors.transparent,
          body: _isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SpinKitFadingCircle(
                      color: ColorAssets.white,
                      size: 66.0,
                    ),
                    SizedBox(height: 15),
                    Text('분석중..',
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100.0),
                      GestureDetector(
                        onTap: () => _tapCamera(),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(50.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Image.asset(
                              'assets/images/camera.png',
                              width: 80.0,
                              height: 80.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Center(
                        child: SizedBox(
                          width: 140.0,
                          height: 140.0,
                          child: Text(
                            '혈압계의 측정결과를 카메라로 촬영하여 앱에 저장합니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // CommonButton(
                      //   height: 50.0,
                      //   width: _screenWidth,
                      //   title: '측정 가이드 보기',
                      //   buttonColor: ButtonColor.primary,
                      //   onTap: () => Navigator.of(context).pop(),
                      // ),
                      // const SizedBox(height: 20.0),
                      CommonButton(
                        height: 50.0,
                        width: _screenWidth,
                        title: '이전 화면으로',
                        buttonColor: ButtonColor.inactive,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  _tapCamera() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? value = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1000,
        maxWidth: 640,
        imageQuality: 99,
      );

      setState(() => _isLoading = true);
      String? _imgPath = value!.path;
      Map<String, String>? result =
          await context.read<BleBpProvider>().getBloodPressureOcr(_imgPath);
      if (result != null) {
        String? sys = result['sys'];
        String? dia = result['dia'];
        String? pul = result['pul'];
        Uint8List imgFile = await value.readAsBytes();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BleBpScanCameraResultScreen(
            imgFile: imgFile,
            sys: sys,
            dia: dia,
            pul: pul,
          ),
        ));
      } else {
        showToast('측정이 제대로 되지 않았습니다\n다시 시도해주세요');
      }
    } catch (e) {
      log(e.toString());
      showToast('측정이 제대로 되지 않았습니다\n다시 시도해주세요');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
