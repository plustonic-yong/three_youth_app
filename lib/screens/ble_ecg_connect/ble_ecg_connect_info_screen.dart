import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/providers/ble_ecg_provider.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/utils/toast.dart';
import 'package:three_youth_app/widget/common/common_button.dart';

import '../../providers/current_user_provider.dart';

class BleEcgConnectInfoScreen extends StatefulWidget {
  final int? initPage;

  const BleEcgConnectInfoScreen({Key? key, this.initPage}) : super(key: key);

  @override
  State<BleEcgConnectInfoScreen> createState() =>
      _BleEcgConnectInfoScreenState();
}

class _BleEcgConnectInfoScreenState extends State<BleEcgConnectInfoScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final TextEditingController _numCtrl = TextEditingController();
  late BleEcgProvider _provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<BleEcgProvider>()
          .onChangeCurrentPage(page: widget.initPage ?? 0);
      _pageController.jumpToPage(widget.initPage ?? 0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _currentPage = context.watch<BleEcgProvider>().currentPage;
    _provider = Provider.of<BleEcgProvider>(context);
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
            title: const Text('심전계 연동안내'),
            leading: GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil('/main', (route) => false),
              child: const Icon(Icons.arrow_back),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    context.read<BleEcgProvider>().onChangeCurrentPage(page: 2);
                    _pageController.jumpToPage(2);
                  },
                  child: const Center(
                      child: Icon(CupertinoIcons.xmark, color: Colors.white)),
                ),
              ),
            ],
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
                        .read<BleEcgProvider>()
                        .onChangeCurrentPage(page: page),
                    children: [
                      _getInfo0(),
                      _getInfo1(),
                      _getInfo2(),
                      _getInfo3(),
                    ],
                  ),
                ),
                DotsIndicator(
                  dotsCount: 4,
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
                _buildBottomButton(),
                const SizedBox(height: 30.0)
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildBottomButton() {
    switch (_currentPage) {
      case 0:
        return CommonButton(
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          title: '다음',
          buttonColor: ButtonColor.primary,
          onTap: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
            context
                .read<BleEcgProvider>()
                .onChangeCurrentPage(page: _currentPage);
          },
        );
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //이전버튼
            Expanded(
              child: CommonButton(
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
                      .read<BleEcgProvider>()
                      .onChangeCurrentPage(page: _currentPage);
                },
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            //다음버튼
            Expanded(
              child: CommonButton(
                width: 150.0,
                height: 50.0,
                title: '다음',
                buttonColor: ButtonColor.primary,
                onTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                  context
                      .read<BleEcgProvider>()
                      .onChangeCurrentPage(page: _currentPage);
                },
              ),
            )
          ],
        );
      case 2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //이전버튼
            Expanded(
              child: CommonButton(
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
                      .read<BleEcgProvider>()
                      .onChangeCurrentPage(page: _currentPage);
                },
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            //다음버튼
            Expanded(
              child: CommonButton(
                width: 150.0,
                height: 50.0,
                title: '심전계찾기',
                buttonColor: ButtonColor.primary,
                onTap: () => _tapEcgScan(),
              ),
            )
          ],
        );
      case 3:
        return _provider.isPaired
            ? CommonButton(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                title: '측정화면으로 이동',
                buttonColor: ButtonColor.primary,
                onTap: () {
                  Navigator.pushNamed(context, '/scanecg');
                  Provider.of<CurrentUserProvider>(context, listen: false)
                      .isER2000S = true;
                  context
                      .read<BleEcgProvider>()
                      .onChangeCurrentPage(page: _currentPage);
                },
              )
            : CommonButton(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                title: '중단하기',
                buttonColor: ButtonColor.orange,
                onTap: () async {
                  await _provider.disConnectPairing();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/main', (route) => false);
                },
              );
      default:
        return const Center();
    }
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
          '※ 심전계의 전력이\n충분한지 확인해주세요.',
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
        const SizedBox(height: 100.0),
        const Text(
          "심전계 화면 우측하단의\n'환경설정' 메뉴에 진입",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 40.0),
        Image.asset('assets/icons/ic_arrow_down.png', width: 24.0),
        const SizedBox(height: 40.0),
        const Text(
          "환경설정 목록 중\n하단의 '블루투스 설정' 선택",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 40.0),
        Image.asset('assets/icons/ic_arrow_down.png', width: 24.0),
        const SizedBox(height: 40.0),
        const Text(
          "'블루투스 켜기'를 선택",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  //3페이지
  Widget _getInfo2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 100.0),
          const Text(
            "심전계 화면에 안내되는\n4자리 번호를 입력해주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 100.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: _numCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              maxLength: 4,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                hintText: '4자리 번호',
                hintStyle: const TextStyle(color: Colors.grey),
                // ignore: use_full_hex_values_for_flutter_colors
                fillColor: const Color(0xff00000033).withOpacity(0.25),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40.0),
        ],
      ),
    );
  }

  //4페이지
  Widget _getInfo3() {
    return _provider.isPaired
        ? Column(
            children: [
              const Spacer(),
              Center(
                child: Image.asset(
                  'assets/images/electrocardiogram_1@2x.png',
                  width: 100.0,
                ),
              ),
              const SizedBox(height: 40.0),
              Center(
                child: Image.asset(
                  'assets/images/check.png',
                  width: 50.0,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "심전계 연동 완료!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(height: 40.0),
              const Text(
                "이제 측정 기록이 스마트폰에\n자동으로 저장됩니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ],
          )
        : Column(
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
            ],
          );
  }

  _tapEcgScan() async {
    (await SharedPreferences.getInstance())
        .setString('ecgNum', _numCtrl.text.trim());
    _provider.startScanAndConnect();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    context.read<BleEcgProvider>().onChangeCurrentPage(page: _currentPage);
  }
}
