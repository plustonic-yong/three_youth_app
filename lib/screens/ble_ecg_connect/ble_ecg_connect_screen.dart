import 'package:flutter/material.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common/common_button.dart';

import 'ble_ecg_connect_info_screen.dart';

class BleEcgConnectScreen extends StatelessWidget {
  const BleEcgConnectScreen({Key? key}) : super(key: key);

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
            title: const Text('심전계 연동'),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                const Center(
                  child: Text(
                    '심전계를 가지고 계신가요?\n스마트폰과 심전계를 연동하는\n방법을 안내해 드리겠습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 40.0),
                //직접 측정
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed('/connectecg/info'),
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    width: _screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          '안내 시작',
                          style: TextStyle(
                            color: ColorAssets.lightYellowGredient1,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 50.0),
                        Text(
                          '심전계 연동 방법을 안내합니다.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                //촬영 측정
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BleEcgConnectInfoScreen(initPage: 2),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    width: _screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          '안내 없이 바로 시작',
                          style: TextStyle(
                            color: ColorAssets.lightYellowGredient1,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 50.0),
                        Text(
                          '심전계 연동방법을 알고 있습니다.',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
        )
      ],
    );
  }
}
