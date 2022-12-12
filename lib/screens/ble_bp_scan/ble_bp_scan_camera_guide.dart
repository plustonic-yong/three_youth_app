import 'package:flutter/material.dart';

class BleBpScanCameraGuide extends StatelessWidget {
  const BleBpScanCameraGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.of(context).popAndPushNamed('/scan/camera'),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/cam_guide.png', fit: BoxFit.cover),
            const Positioned(
              top: 50,
              child: Text(
                '혈압계의 측정 결과 화면을\n아래 사각형에 맞추어\n촬영해 주세요.',
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
