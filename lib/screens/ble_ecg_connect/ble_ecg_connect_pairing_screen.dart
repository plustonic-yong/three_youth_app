import 'package:flutter/material.dart';
import 'package:three_youth_app/widget/common_button.dart';

class BleEcgConnectPairingScreen extends StatelessWidget {
  const BleEcgConnectPairingScreen({Key? key}) : super(key: key);

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
            title: const Text('기기 연동'),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child:
                //연동화면
                _getConnecting(buttonWidth: _screenWidth),
            // _getConnectComplete(buttonWidth: _screenWidth)
            // _getConnectFailed(buttonWidth: _screenWidth),
          ),
        ),
      ],
    );
  }

  Widget _getConnecting({required double buttonWidth}) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        Center(
          child: Image.asset(
            'assets/images/electrocardiogram_1@2x.png',
            width: 100.0,
          ),
        ),
        const SizedBox(height: 50.0),
        const Text(
          '연동 중 입니다.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        CommonButton(
          width: buttonWidth,
          height: 50.0,
          title: '중단하기',
          buttonColor: ButtonColor.orange,
          onTap: () {},
        ),
        const SizedBox(height: 30.0)
      ],
    );
  }

  Widget _getConnectComplete({required double buttonWidth}) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        Center(
          child: Image.asset(
            'assets/images/electrocardiogram_1@2x.png',
            width: 100.0,
          ),
        ),
        const SizedBox(height: 20.0),
        Image.asset(
          'assets/icons/ic_check_circle.png',
          width: 30.0,
        ),
        const SizedBox(height: 10.0),
        const Text(
          '심전계 연동 완료!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 50.0),
        const Text(
          "이제 측정 기록이 스마트폰에\n자동으로 저장됩니다.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        CommonButton(
          width: buttonWidth,
          height: 50.0,
          title: '측정화면으로 이동',
          buttonColor: ButtonColor.primary,
          onTap: () {},
        ),
        const SizedBox(height: 30.0)
      ],
    );
  }

  Widget _getConnectFailed({required double buttonWidth}) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        Center(
          child: Image.asset(
            'assets/images/electrocardiogram_1@2x.png',
            width: 100.0,
          ),
        ),
        const SizedBox(height: 20.0),
        Image.asset(
          'assets/icons/ic_warning_circle.png',
          width: 30.0,
        ),
        const SizedBox(height: 10.0),
        const Text(
          "심전계 연동 실패!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40.0),
        // const Spacer(),
        Center(
          child: Image.asset(
            'assets/icons/ic_bluetooth_white.png',
            width: 35.0,
          ),
        ),
        const SizedBox(height: 10.0),
        const Text(
          '스마트폰의 블루투스가 켜져 있나요?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xffC8C8C8),
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 30.0),
        const Text(
          "심전계 화면에 안내되는 번호를 잘못\n입력하지는 않았나요?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xffC8C8C8),
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 30.0),
        const CommonButton(
          height: 40.0,
          width: 170.0,
          title: '번호입력',
          buttonColor: ButtonColor.inactive,
        ),
        const Spacer(),
        CommonButton(
          width: buttonWidth,
          height: 50.0,
          title: '다시 찾기',
          buttonColor: ButtonColor.primary,
          onTap: () {},
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }
}
