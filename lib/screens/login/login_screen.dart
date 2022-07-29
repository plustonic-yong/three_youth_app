// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/auth_provider.dart';
import 'package:three_youth_app/screens/profile_setting/init_profile_setting_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isIos =
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  bool isAndroid =
      foundation.defaultTargetPlatform == foundation.TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                    SizedBox(height: height * 0.08),
                    //제목, 부제목
                    const Text(
                      '제3의 청춘',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    const Text(
                      'Social Value Creation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    //로고
                    Image.asset(
                      'assets/icons/logo.png',
                      width: width * 0.25,
                    ),
                    SizedBox(height: height * 0.06),
                    //로그인버튼
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const InitProfileSettingScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: width * 0.48,
                        height: height * 0.05,
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
                              color: Color(0xff00000029),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: const Center(
                          child: Text(
                            '로그인',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    const Text(
                      'SNS 회원가입',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: height * 0.02),

                    //애플 회원가입
                    isIos
                        ? GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: width * 0.48,
                              height: height * 0.05,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff00000026)
                                        .withOpacity(0.15),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                      6,
                                      8,
                                    ), // changes position of shadow
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.circular(width * 0.048),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/apple.png',
                                    width: width * 0.05,
                                  ),
                                  SizedBox(width: width * 0.048),
                                  const Text(
                                    '애플 회원가입',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(height: height * 0.02),
                    //구글 회원가입
                    GestureDetector(
                      onTap: () async {
                        var result = await context
                            .read<AuthProvider>()
                            .signInWithGoogle();
                        print('google sign in result: $result');
                      },
                      child: Container(
                        width: width * 0.48,
                        height: height * 0.05,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xff00000026).withOpacity(0.15),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                6,
                                8,
                              ), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/google.png',
                              width: width * 0.05,
                            ),
                            SizedBox(width: width * 0.048),
                            const Text(
                              '구글 회원가입',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    //카카오 회원가입
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: width * 0.48,
                        height: height * 0.05,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xff00000026).withOpacity(0.15),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                6,
                                8,
                              ), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(width * 0.048),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/kakao.png',
                              width: width * 0.05,
                            ),
                            SizedBox(width: width * 0.048),
                            const Text(
                              '카카오 회원가입',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    //네이버 회원가입
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: width * 0.48,
                        height: height * 0.05,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xff00000026).withOpacity(0.15),
                              spreadRadius: 5.0,
                              blurRadius: 7.0,
                              offset: const Offset(
                                6,
                                8,
                              ), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(width * 0.048),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/naver.png',
                              width: width * 0.04,
                            ),
                            SizedBox(width: width * 0.048),
                            const Text(
                              '네이버 회원가입',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    const Spacer(),
                    Text(
                      '제3의 청춘 주식회사',
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF).withOpacity(0.5),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
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
