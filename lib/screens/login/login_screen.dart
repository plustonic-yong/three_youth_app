// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/auth_provider.dart';
import 'package:three_youth_app/screens/main/main_screen.dart';
import 'package:three_youth_app/screens/signup_agreement/signup_agreement_screen.dart';
import 'package:three_youth_app/utils/enums.dart';

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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      // const SignupAgreementScreen(),
                                      const MainScreen(),
                                ),
                              );
                            },
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
                                    '애플 로그인',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        :
                        //구글 회원가입
                        GestureDetector(
                            onTap: () async {
                              var result = await context
                                  .read<AuthProvider>()
                                  .loginGoogle();
                              if (result == LoginStatus.success) {
                                Navigator.of(context).pushNamed('/main');
                              } else if (result == LoginStatus.noAccount) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('취소'),
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed('/signup'),
                                            child: const Text('확인'),
                                          ),
                                        ],
                                        content: Container(
                                          child: const Text(
                                              '회원가입이 되어있지 않습니다. 신규가입을 진행하시겠습니까?'),
                                        ),
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          child: const Text('로그인에 실패하였습니다.'),
                                        ),
                                      );
                                    });
                              }
                            },
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
                                    '구글 로그인',
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
                      onTap: () async {
                        String kakaoId;
                        try {
                          await context.read<AuthProvider>().signinWithKakao();
                          User user = await UserApi.instance.me();
                          kakaoId = '${user.id}';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SignupAgreementScreen(),
                            ),
                          );
                        } catch (e) {
                          print(e);
                        }
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
                              '카카오 로그인',
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
                      onTap: () => Navigator.of(context).pushNamed('/main'),
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
                              '네이버 로그인',
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
