// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/auth_provider.dart';
import 'package:three_youth_app/providers/signup_agreement_provider.dart';
import 'package:three_youth_app/providers/signup_provider.dart';
import 'package:three_youth_app/utils/color.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<AuthProvider>().getLastLoginMethod();
      context.read<SignupAgreementProvider>().onInitSignupAgreementInputs();
      context.read<SignupProvider>().onInitSignupInputs();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String? lastLoginMethod = context.watch<AuthProvider>().lastLoginMethod;
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
                    SizedBox(height: height * 0.1),
                    //로고
                    Image.asset(
                      'assets/icons/ic_logo.png',
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

                    //애플 로그인
                    isIos
                        ? Container()
                        // Column(
                        //     children: [
                        //       GestureDetector(
                        //         onTap: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) =>
                        //                   // const SignupAgreementScreen(),
                        //                   const MainScreen(),
                        //             ),
                        //           );
                        //         },
                        //         child: Container(
                        //           width: width * 0.48,
                        //           height: height * 0.05,
                        //           padding: const EdgeInsets.symmetric(
                        //               horizontal: 12.0),
                        //           decoration: BoxDecoration(
                        //             color: lastLoginMethod == 'apple'
                        //                 ? ColorAssets.unselectedBottombar
                        //                 : Colors.white,
                        //             boxShadow: [
                        //               BoxShadow(
                        //                 color: const Color(0xff00000026)
                        //                     .withOpacity(0.15),
                        //                 spreadRadius: 5,
                        //                 blurRadius: 7,
                        //                 offset: const Offset(
                        //                   6,
                        //                   8,
                        //                 ), // changes position of shadow
                        //               ),
                        //             ],
                        //             borderRadius:
                        //                 BorderRadius.circular(width * 0.048),
                        //           ),
                        //           child: Row(
                        //             children: [
                        //               Image.asset(
                        //                 'assets/icons/apple.png',
                        //                 width: width * 0.05,
                        //               ),
                        //               SizedBox(width: width * 0.048),
                        //               const Text(
                        //                 '애플 로그인',
                        //                 style: TextStyle(
                        //                   color: Colors.black,
                        //                   fontSize: 16.0,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       lastLoginMethod == 'apple'
                        //           ? const Text(
                        //               '마지막으로 접속한 계정입니다.',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //               ),
                        //             )
                        //           : Container(),
                        //     ],
                        //   )
                        :
                        //구글 로그인
                        Column(
                            children: [
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
                                            contentPadding:
                                                const EdgeInsets.all(30.0),
                                            actionsPadding:
                                                const EdgeInsets.all(10.0),
                                            actions: [
                                              GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text(
                                                  '취소',
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<SignupProvider>()
                                                      .onChangeSignupState(
                                                        value:
                                                            SignupState.google,
                                                      );
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                    '/signup/agreement',
                                                  );
                                                },
                                                child: const Text(
                                                  '확인',
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                              ),
                                            ],
                                            content: const Text(
                                              '회원가입이 되어있지 않습니다.\n신규가입을 진행하시겠습니까?',
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                          );
                                        });
                                  }
                                },
                                child: Container(
                                  width: width * 0.48,
                                  height: height * 0.05,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: lastLoginMethod == 'google'
                                        ? ColorAssets.unselectedBottombar
                                        : Colors.white,
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
                              lastLoginMethod == 'google'
                                  ? const Text(
                                      '마지막으로 접속한 계정입니다.',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                    SizedBox(height: height * 0.02),
                    //카카오 로그인
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            var result =
                                await context.read<AuthProvider>().loginKakao();
                            if (result == LoginStatus.success) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/main',
                                (route) => false,
                              );
                            } else if (result == LoginStatus.noAccount) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      contentPadding:
                                          const EdgeInsets.all(30.0),
                                      actionsPadding:
                                          const EdgeInsets.all(10.0),
                                      actions: [
                                        GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text(
                                            '취소',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<SignupProvider>()
                                                .onChangeSignupState(
                                                  value: SignupState.kakao,
                                                );
                                            Navigator.of(context)
                                                .pushNamed('/signup/agreement');
                                          },
                                          child: const Text(
                                            '확인',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                      ],
                                      content: const Text(
                                        '회원가입이 되어있지 않습니다.\n신규가입을 진행하시겠습니까?',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    );
                                  });
                            }
                            //  else {
                            //   showDialog(
                            //       context: context,
                            //       builder: (context) {
                            //         return AlertDialog(
                            //           actions: [
                            //             GestureDetector(
                            //               onTap: () => Navigator.of(context).pop(),
                            //               child: const Text('확인'),
                            //             ),
                            //           ],
                            //           content: Container(
                            //             child: const Text('로그인에 실패하였습니다.'),
                            //           ),
                            //         );
                            //       });
                            // }
                          },
                          child: Container(
                            width: width * 0.48,
                            height: height * 0.05,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: lastLoginMethod == 'kakao'
                                  ? ColorAssets.unselectedBottombar
                                  : Colors.white,
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
                        lastLoginMethod == 'kakao'
                            ? const Text(
                                '마지막으로 접속한 계정입니다.',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    //네이버 로그인
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            log('naver');
                            var result =
                                await context.read<AuthProvider>().loginNaver();

                            if (result == LoginStatus.success) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/main',
                                (route) => false,
                              );
                            } else if (result == LoginStatus.noAccount) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      contentPadding:
                                          const EdgeInsets.all(30.0),
                                      actionsPadding:
                                          const EdgeInsets.all(10.0),
                                      actions: [
                                        GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text(
                                            '취소',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<SignupProvider>()
                                                .onChangeSignupState(
                                                  value: SignupState.naver,
                                                );
                                            Navigator.of(context)
                                                .pushNamed('/signup/agreement');
                                          },
                                          child: const Text(
                                            '확인',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                      ],
                                      content: const Text(
                                        '회원가입이 되어있지 않습니다.\n신규가입을 진행하시겠습니까?',
                                        style: TextStyle(fontSize: 18.0),
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
                              color: lastLoginMethod == 'naver'
                                  ? ColorAssets.unselectedBottombar
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xff00000026)
                                      .withOpacity(0.15),
                                  spreadRadius: 5.0,
                                  blurRadius: 7.0,
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
                        lastLoginMethod == 'naver'
                            ? const Text(
                                '마지막으로 접속한 계정입니다.',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                      ],
                    ),
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
