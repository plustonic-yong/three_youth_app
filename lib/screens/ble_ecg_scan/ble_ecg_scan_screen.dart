import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common_button.dart';

class BleEcgScanScreen extends StatelessWidget {
  const BleEcgScanScreen({Key? key}) : super(key: key);

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
            title: const Text('심전계 측정 기록'),
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 60.0),
                const Center(
                  child: Text(
                    '어떤 방식으로 측정할까요?',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 50.0),
                //심전도(30초)
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed('/scanecg/mesurement'),
                  child: Container(
                    padding: const EdgeInsets.all(25.0),
                    width: _screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      '심전도 (30초)',
                      style: TextStyle(
                        // color: ColorAssets.lightYellowGredient1,
                        color: Colors.white,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                //연속 심전도 측정
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed('/scanecg/mesurement'),
                  child: Container(
                    padding: const EdgeInsets.all(25.0),
                    width: _screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      '연속 심전도 측정',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                //실시간 심전도 측정
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed('/scanecg/mesurement'),
                  child: Container(
                    padding: const EdgeInsets.all(25.0),
                    width: _screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      '실시간 심전도 측정',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
