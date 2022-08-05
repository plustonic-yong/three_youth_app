import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:three_youth_app/providers/signup_provider.dart';
import 'package:three_youth_app/screens/signup/signup_birth_gender_screen.dart';
import 'package:three_youth_app/screens/signup/signup_name_screen.dart';
import 'package:three_youth_app/screens/signup/signup_tall_screen.dart';
import 'package:three_youth_app/screens/signup/signup_weight_screen.dart';
import 'package:three_youth_app/widget/common_button_large.dart';
import 'package:three_youth_app/widget/common_button_small.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenScreenState();
}

class _SignupScreenScreenState extends State<SignupScreen> {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int _currentPage = context.watch<SignupProvider>().currentPage;

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
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    // physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) => context
                        .read<SignupProvider>()
                        .onChangeCurrentPage(page: page),
                    children: const [
                      SignupNameScreen(),
                      SignupTallScreen(),
                      SignupWeightScreen(),
                      SignupBirthGenderScreen(),
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
                SizedBox(height: height * 0.05),
                _currentPage == 0
                    //첫페이지 다음버튼
                    ? CommonButtonLarge(
                        title: '다음',
                        isActive: true,
                        onTap: () {
                          setState(() {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          });
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //이전버튼
                          CommonButtonSmall(
                            title: '이전',
                            isActive: false,
                            onTap: () {
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
                          CommonButtonSmall(
                            title: '다음',
                            isActive: true,
                            onTap: () {
                              if (_currentPage == 3) {
                                Navigator.of(context).pushNamed('/main');
                              }
                              setState(() {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                SizedBox(height: height * 0.045),
              ],
            ),

            // SafeArea(
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: Column(
            //       children: [
            //         SizedBox(height: height * 0.08),
            //         //로고
            //         Image.asset(
            //           'assets/icons/logo.png',
            //           width: width * 0.25,
            //         ),
            //         // _currentPage >= 2
            //         //     ? SizedBox(height: height * 0.18)
            //         //     : SizedBox(height: height * 0.03),
            //         Padding(
            //           padding: _currentPage >= 2
            //               ? EdgeInsets.symmetric(vertical: height * 0.06)
            //               : EdgeInsets.symmetric(vertical: height * 0.02),
            //           child: Text(
            //             _currentPage == 0
            //                 ? '이용약관'
            //                 : _currentPage == 1
            //                     ? '개인정보 취급방침'
            //                     : _currentPage == 2
            //                         ? '당신의 이름은 무엇인가요?'
            //                         : _currentPage == 3
            //                             ? '키는 몇이신가요?'
            //                             : _currentPage == 4
            //                                 ? '몸무게는 어떻게 되세요?'
            //                                 : '생년월일과 성별을 입력해주세요.',
            //             style: const TextStyle(
            //                 color: Colors.white, fontSize: 22.0),
            //           ),
            //         ),
            //         // _currentPage >= 2
            //         //     ? SizedBox(height: height * 0.05)
            //         //     : SizedBox(height: height * 0.02),
            //         //input form
            //         Expanded(
            //           child: PageView(
            //             controller: _pageController,
            //             physics: const NeverScrollableScrollPhysics(),
            //             pageSnapping: false,
            //             onPageChanged: (page) {
            //               setState(() {
            //                 _currentPage = page;
            //               });
            //             },
            //             children: [
            //               SignupAgreement(
            //                 page: 0,
            //                 onChangeAgree: () {
            //                   context.read<SignupProvider>().changeInfoAgree();
            //                 },
            //               ),
            //               SignupAgreement(
            //                 page: 1,
            //                 onChangeAgree: () {
            //                   context.read<SignupProvider>().changeTermsAgree();
            //                 },
            //               ),
            //               const SignupInput(page: 2),
            //               const SignupInput(page: 3),
            //               const SignupInput(page: 4),
            //               const SignupInput(page: 5),
            //             ],
            //           ),
            //         ),
            //         // const Spacer(),
            //         //dots indicator
            //         DotsIndicator(
            //           dotsCount: 6,
            //           position: _currentPage.roundToDouble(),
            //           decorator: DotsDecorator(
            //             size: const Size.square(9.0),
            //             activeSize: const Size(30.0, 9.0),
            //             activeShape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(5.0),
            //             ),
            //           ),
            //         ),
            //         SizedBox(height: height * 0.05),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             //이전버튼
            //             _currentPage != 0
            //                 ? GestureDetector(
            //                     onTap: () {
            //                       setState(() {
            //                         _pageController.previousPage(
            //                           duration:
            //                               const Duration(milliseconds: 300),
            //                           curve: Curves.easeOutSine,
            //                         );
            //                       });
            //                     },
            //                     child: Container(
            //                       width: width * 0.38,
            //                       height: height * 0.053,
            //                       decoration: BoxDecoration(
            //                         color: const Color(0xffffffff)
            //                             .withOpacity(0.3),
            //                         boxShadow: const [
            //                           BoxShadow(
            //                             // ignore: use_full_hex_values_for_flutter_colors
            //                             color: Color(0xff00000029),
            //                             spreadRadius: 5,
            //                             blurRadius: 7,
            //                             // changes position of shadow
            //                             offset: Offset(0, 3),
            //                           ),
            //                         ],
            //                         borderRadius: BorderRadius.circular(25.0),
            //                       ),
            //                       child: const Center(
            //                         child: Text(
            //                           '이전',
            //                           style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: 20.0,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   )
            //                 : Container(),
            //             SizedBox(width: width * 0.05),
            //             //다음버튼
            //             GestureDetector(
            //               onTap: () {
            //                 if (_currentPage == 5) {
            //                   Navigator.of(context).push(
            //                     MaterialPageRoute(
            //                       builder: (context) => const MainScreen(),
            //                     ),
            //                   );
            //                 } else {
            //                   if (_currentPage == 0 && !_isInfoAgreeChecked) {
            //                     return;
            //                   }
            //                   if (_currentPage == 1 && !_isTermAgreeChecked) {
            //                     return;
            //                   }
            //                   setState(() {
            //                     _pageController.nextPage(
            //                       duration: const Duration(milliseconds: 300),
            //                       curve: Curves.easeOutSine,
            //                     );
            //                   });
            //                 }
            //               },
            //               child: Container(
            //                 width:
            //                     _currentPage == 0 ? width * 0.6 : width * 0.38,
            //                 height: height * 0.053,
            //                 decoration: BoxDecoration(
            //                   gradient: const LinearGradient(
            //                     begin: Alignment.topCenter,
            //                     end: Alignment.bottomCenter,
            //                     stops: [
            //                       0.05,
            //                       0.5,
            //                     ],
            //                     colors: [
            //                       Color(0xff46DFFF),
            //                       Color(0xff00B1E9),
            //                     ],
            //                   ),
            //                   boxShadow: const [
            //                     BoxShadow(
            //                       // ignore: use_full_hex_values_for_flutter_colors
            //                       color: Color(0xff00000029),
            //                       spreadRadius: 5,
            //                       blurRadius: 7,
            //                       offset: Offset(
            //                         0,
            //                         3,
            //                       ), // changes position of shadow
            //                     ),
            //                   ],
            //                   borderRadius: BorderRadius.circular(25.0),
            //                 ),
            //                 child: const Center(
            //                   child: Text(
            //                     '다음',
            //                     style: TextStyle(
            //                       color: Colors.white,
            //                       fontSize: 20.0,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //         SizedBox(height: height * 0.05),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
