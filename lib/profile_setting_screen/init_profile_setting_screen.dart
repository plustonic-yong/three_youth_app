import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:three_youth_app/main_screen/main_screen.dart';
import 'package:three_youth_app/profile_setting_screen/component/init_profile_setting_input.dart';

class InitProfileSettingScreen extends StatefulWidget {
  const InitProfileSettingScreen({Key? key}) : super(key: key);
  @override
  State<InitProfileSettingScreen> createState() =>
      _InitProfileSettingScreenState();
}

class _InitProfileSettingScreenState extends State<InitProfileSettingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            //배경이미지
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            //contents
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 140.0),
                    //로고
                    Image.asset(
                      'assets/icons/logo.png',
                      width: 110.0,
                    ),
                    const SizedBox(height: 155.0),
                    Text(
                      _currentPage == 0
                          ? '당신의 이름은 무엇인가요?'
                          : _currentPage == 1
                              ? '키는 몇이신가요?'
                              : _currentPage == 2
                                  ? '몸무게는 어떻게 되세요?'
                                  : '생년월일과 성별을 입력해주세요.',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 22.0),
                    ),
                    const SizedBox(height: 50.0),
                    //input form
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        pageSnapping: false,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: const [
                          InitProfileSettingInput(page: 0),
                          InitProfileSettingInput(page: 1),
                          InitProfileSettingInput(page: 2),
                          InitProfileSettingInput(page: 3),
                        ],
                      ),
                    ),
                    const Spacer(),
                    //dots indicator
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
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //이전버튼
                        _currentPage != 0
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                    );
                                  });
                                },
                                child: Container(
                                  width: 190.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffffffff)
                                        .withOpacity(0.3),
                                    boxShadow: const [
                                      BoxShadow(
                                        // ignore: use_full_hex_values_for_flutter_colors
                                        color: Color(0xff00000029),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        // changes position of shadow
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '이전',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(width: 20.0),
                        //다음버튼
                        GestureDetector(
                          onTap: () {
                            if (_currentPage == 3) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(),
                                ),
                              );
                            } else {
                              setState(() {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              });
                            }
                          },
                          child: Container(
                            width: _currentPage == 0 ? 268.0 : 190.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [
                                  0.05,
                                  0.5,
                                ],
                                colors: [
                                  Color(0xff46DFFF),
                                  Color(0xff00B1E9),
                                ],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  // ignore: use_full_hex_values_for_flutter_colors
                                  color: Color(0xff00000029),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: const Center(
                              child: Text(
                                '다음',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
