import 'package:flutter/material.dart';
import 'package:three_youth_app/widget/common_button.dart';

class BleEcgScanMeasurementScreen extends StatelessWidget {
  const BleEcgScanMeasurementScreen({Key? key}) : super(key: key);

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
            title: const Text('측정준비'),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40.0),
                Center(
                  child: Image.asset(
                    'assets/images/electrocardiogram_1@2x.png',
                    width: 100.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Center(
                  child: Text(
                    '심전계의 측정이 시작되면\n이 화면은 자동으로 닫힙니다.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Container(
                  padding: const EdgeInsets.all(25.0),
                  width: _screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    '심전계 상부 전극판(금속판)에 오른손\n손가락을 왼쪽 가슴 밑에 심전계 하부\n전극판을 접촉한 후 기기의 "O" 버튼을\n누르면 측정이 시작됩니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 2.0,
                    ),
                  ),
                ),
                const Spacer(),
                CommonButton(
                  height: 50.0,
                  width: _screenWidth,
                  title: '이전 화면으로',
                  buttonColor: ButtonColor.inactive,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
