import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/widget/common_button.dart';

class BleBpScanScreen extends StatelessWidget {
  const BleBpScanScreen({Key? key}) : super(key: key);

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
            title: const Text('혈압 측정 기록'),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                const Center(
                  child: Text(
                    '어떤 방식으로 측정할까요?',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 40.0),
                //직접 측정
                Container(
                  padding: const EdgeInsets.all(40.0),
                  width: _screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        '직접 측정 후 기록',
                        style: TextStyle(
                          color: ColorAssets.lightYellowGredient1,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Text(
                        '혈압계를 앱과 연동 후 측정을 시작합니다.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                //촬영 측정
                Container(
                  padding: const EdgeInsets.all(40.0),
                  width: _screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        '직접 측정 후 기록',
                        style: TextStyle(
                          color: ColorAssets.lightYellowGredient1,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Text(
                        '혈압계를 앱과 연동 후 측정을 시작합니다.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                CommonButton(
                  height: 50.0,
                  width: _screenWidth,
                  title: '이전 화면으로',
                  buttonColor: ButtonColor.inactive,
                  onTap: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
