import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/screens/ble_bp_connect/ble_bp_connect_pairing_screen.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:provider/provider.dart';

class BleBpConnectInfoScreen extends StatefulWidget {
  const BleBpConnectInfoScreen({Key? key}) : super(key: key);

  @override
  State<BleBpConnectInfoScreen> createState() => _BleBpConnectInfoScreenState();
}

class _BleBpConnectInfoScreenState extends State<BleBpConnectInfoScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<BleBpProvider>().onInitCurrentPage();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    int _currentPage = context.watch<BleBpProvider>().currentPage;

    PageController _pageController = PageController();

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
            title: const Text('혈압계 연동안내'),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) => context
                        .read<BleBpProvider>()
                        .onChangeCurrentPage(page: page),
                    children: [
                      _getInfo0(),
                      _getInfo1(),
                      _getInfo2(),
                      // _getInfo3(),
                    ],
                  ),
                ),
                DotsIndicator(
                  dotsCount: 3,
                  position: _currentPage.roundToDouble(),
                  decorator: DotsDecorator(
                    size: const Size.square(9.0),
                    activeSize: const Size(30.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                _currentPage == 0
                    ? CommonButton(
                        width: _screenWidth,
                        height: 50.0,
                        title: '다음',
                        buttonColor: ButtonColor.primary,
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                          context
                              .read<BleBpProvider>()
                              .onChangeCurrentPage(page: _currentPage);
                        },
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //이전버튼
                          CommonButton(
                            width: 150.0,
                            height: 50.0,
                            title: '이전',
                            buttonColor: ButtonColor.inactive,
                            onTap: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                              context
                                  .read<BleBpProvider>()
                                  .onChangeCurrentPage(page: _currentPage);
                            },
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          //다음버튼
                          _currentPage == 2
                              ? CommonButton(
                                  width: 150.0,
                                  height: 50.0,
                                  title: '혈압계찾기',
                                  buttonColor: ButtonColor.primary,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BleBpConnectPairingScreen(),
                                      ),
                                    );
                                  },
                                )
                              : CommonButton(
                                  width: 150.0,
                                  height: 50.0,
                                  title: '다음',
                                  buttonColor: ButtonColor.primary,
                                  onTap: () {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                    );
                                    context
                                        .read<BleBpProvider>()
                                        .onChangeCurrentPage(
                                          page: _currentPage,
                                        );
                                  },
                                ),
                        ],
                      ),
                const SizedBox(height: 30.0)
              ],
            ),
          ),
        )
      ],
    );
  }

//1페이지
  Widget _getInfo0() {
    return Column(
      children: [
        const SizedBox(height: 80.0),
        Center(
          child: Image.asset('assets/icons/ic_bluetooth.png'),
        ),
        const SizedBox(height: 50.0),
        const Text(
          '스마트폰의 블루투스 설정을\n켜주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
        const SizedBox(height: 30.0),
        const Text(
          '※ 혈압계의 전력이\n충분한지 확인해주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xffC8C8C8),
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  //2페이지
  Widget _getInfo1() {
    return Column(
      children: [
        const SizedBox(height: 80.0),
        const Text(
          "혈압계의 'Start/전원' 버튼을\n길게 눌러주세요.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
        const SizedBox(height: 40.0),
        Center(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Image.asset(
              'assets/icons/ic_pr.png',
              width: 120.0,
            ),
          ),
        ),
        const SizedBox(height: 30.0),
        const Text(
          "혈압계의 화면에 'Pr' 이라는\n문자가 보이면 버튼에서 을 떼주세요.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
      ],
    );
  }

  //3페이지
  Widget _getInfo2() {
    return Column(
      children: [
        const SizedBox(height: 80.0),
        const Text(
          "스마트폰과 혈압계를 연동하기위해\n화면 하단의 '혈압계찾기'\n버튼을 눌러주세요.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
        // const SizedBox(height: 40.0),
        const Spacer(),
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
        Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Image.asset(
              'assets/icons/ic_pr_small.png',
              width: 25.0,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        const Text(
          "기기 화면에 'Pr' 문자가 보이나요?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xffC8C8C8),
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 40.0),
      ],
    );
  }

  //4페이지
  Widget _getInfo3() {
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/images/sphygmomanometer_1.png',
            width: 35.0,
          ),
        ),
        const SizedBox(height: 10.0),
        const Text(
          '연동 중 입니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xffC8C8C8),
            fontSize: 18.0,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
