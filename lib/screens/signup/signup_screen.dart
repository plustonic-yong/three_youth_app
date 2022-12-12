import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:three_youth_app/providers/auth_provider.dart';
import 'package:three_youth_app/providers/signup_provider.dart';
import 'package:three_youth_app/screens/signup/signup_birth_gender_screen.dart';
import 'package:three_youth_app/screens/signup/signup_name_screen.dart';
import 'package:three_youth_app/screens/signup/signup_height_screen.dart';
import 'package:three_youth_app/screens/signup/signup_profile_img_screen.dart';
import 'package:three_youth_app/screens/signup/signup_weight_screen.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenScreenState();
}

class _SignupScreenScreenState extends State<SignupScreen> {
  final _pageController = PageController();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    int _currentPage = context.watch<SignupProvider>().currentPage;
    String _name = context.watch<SignupProvider>().nameController.text;
    String _height = context.watch<SignupProvider>().heightController.text;
    String _weight = context.watch<SignupProvider>().weightController.text;
    GenderState _gender = context.read<SignupProvider>().gender;
    DateTime _birth = context.watch<SignupProvider>().birth;
    XFile? _selectedImg = context.watch<SignupProvider>().selectedImg;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
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
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () => _tapBack(_currentPage),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              elevation: 0.0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => _tapBack(-1),
                    child: const Center(
                        child: Icon(CupertinoIcons.xmark, color: Colors.white)),
                  ),
                ),
              ],
            ),
            body: WillPopScope(
              onWillPop: () async {
                _tapBack(_currentPage);
                return false;
              },
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (page) => context
                          .read<SignupProvider>()
                          .onChangeCurrentPage(page: page),
                      children: const [
                        SignupNameScreen(),
                        SignupHeightScreen(),
                        SignupWeightScreen(),
                        SignupBirthGenderScreen(),
                        SignupProfileImgScreen(),
                      ],
                    ),
                  ),
                  DotsIndicator(
                    dotsCount: 5,
                    position: _currentPage.roundToDouble(),
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(30.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  SizedBox(height: _screenHeight * 0.05),
                  _currentPage == 0
                      //첫페이지 다음버튼
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonButton(
                              width: 150.0,
                              height: 50.0,
                              title: '이전',
                              buttonColor: ButtonColor.inactive,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.of(context).pop();
                              },
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            CommonButton(
                                width: 150.0,
                                height: 50.0,
                                title: '다음',
                                buttonColor: _name != ''
                                    ? ButtonColor.primary
                                    : ButtonColor.inactive,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (_name == '') return;
                                  setState(() {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                    );
                                  });
                                }),
                          ],
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
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                });
                              },
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            //다음버튼
                            CommonButton(
                              width: 150.0,
                              height: 50.0,
                              title: _currentPage == 4 ? '회원가입' : '다음',
                              buttonColor: _currentPage == 1
                                  ? _height != ''
                                      ? ButtonColor.primary
                                      : ButtonColor.inactive
                                  : _currentPage == 2
                                      ? _weight != ''
                                          ? ButtonColor.primary
                                          : ButtonColor.inactive
                                      : _currentPage == 3
                                          ? ButtonColor.primary
                                          : _currentPage == 4
                                              ? _selectedImg != null
                                                  ? ButtonColor.primary
                                                  : ButtonColor.primary
                                              : ButtonColor.primary,
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                if (_currentPage == 1 && _height == '') {
                                  return;
                                }
                                if (_currentPage == 2 && _weight == '') {
                                  return;
                                }
                                if (_currentPage == 4) {
                                  try {
                                    setState(() => _loading = true);
                                    var signupState = context
                                        .read<SignupProvider>()
                                        .signupState;
                                    if (signupState == SignupState.google) {
                                      var result = await context
                                          .read<AuthProvider>()
                                          .signupGoogle(
                                            name: _name,
                                            birth: _birth,
                                            gender: _gender,
                                            height: _height,
                                            weight: _weight,
                                            img: _selectedImg?.path ?? '',
                                          );
                                      if (result == SignupStatus.success) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content:
                                                  const Text('회원가입이 완료되었습니다.'),
                                              actions: [
                                                GestureDetector(
                                                  onTap: () => Navigator.of(
                                                          context)
                                                      .pushNamedAndRemoveUntil(
                                                          '/main',
                                                          (route) => false),
                                                  child: const Text(
                                                    '확인',
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    } else if (signupState ==
                                        SignupState.kakao) {
                                      var result = await context
                                          .read<AuthProvider>()
                                          .signupKakao(
                                            name: _name,
                                            birth: _birth,
                                            gender: _gender,
                                            height: _height,
                                            weight: _weight,
                                            img: _selectedImg?.path ?? '',
                                          );
                                      if (result == SignupStatus.success) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content:
                                                  const Text('회원가입이 완료되었습니다.'),
                                              actions: [
                                                GestureDetector(
                                                  onTap: () => Navigator.of(
                                                          context)
                                                      .pushNamedAndRemoveUntil(
                                                          '/main',
                                                          (route) => false),
                                                  child: const Text(
                                                    '확인',
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    } else if (signupState ==
                                        SignupState.naver) {
                                      log('naver');
                                      var result = await context
                                          .read<AuthProvider>()
                                          .signupNaver(
                                            name: _name,
                                            birth: _birth,
                                            gender: _gender,
                                            height: _height,
                                            weight: _weight,
                                            img: _selectedImg?.path ?? '',
                                          );
                                      if (result == SignupStatus.success) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content:
                                                  const Text('회원가입이 완료되었습니다.'),
                                              actions: [
                                                GestureDetector(
                                                  onTap: () => Navigator.of(
                                                          context)
                                                      .pushNamedAndRemoveUntil(
                                                          '/main',
                                                          (route) => false),
                                                  child: const Text(
                                                    '확인',
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    log(e.toString());
                                  } finally {
                                    setState(() => _loading = false);
                                  }
                                }
                                setState(() {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                });
                                context
                                    .read<SignupProvider>()
                                    .onChangeCurrentPage(page: _currentPage);
                              },
                            ),
                          ],
                        ),
                  SizedBox(height: _screenHeight * 0.045),
                ],
              ),
            ),
          ),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  _tapBack(int curPage) {
    if (curPage == -1) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(30.0),
              actionsPadding: const EdgeInsets.all(10.0),
              actions: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Text(
                    '취소',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
              content: const Text(
                '회원가입 절차를\n중단하시겠습니까?',
                style: TextStyle(fontSize: 18.0),
              ),
            );
          });
    } else if (curPage == 0) {
      Navigator.pop(context);
    } else {
      setState(() {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutSine,
        );
      });
    }
  }
}
