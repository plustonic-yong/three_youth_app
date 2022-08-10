import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:three_youth_app/providers/signup_provider.dart';
import 'package:three_youth_app/screens/signup/signup_birth_gender_screen.dart';
import 'package:three_youth_app/screens/signup/signup_name_screen.dart';
import 'package:three_youth_app/screens/signup/signup_tall_screen.dart';
import 'package:three_youth_app/screens/signup/signup_weight_screen.dart';
import 'package:three_youth_app/widget/common_button.dart';
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
    String _name = context.watch<SignupProvider>().nameController.text;
    String _tall = context.watch<SignupProvider>().tallController.text;
    String _weight = context.watch<SignupProvider>().weightController.text;
    String _year = context.watch<SignupProvider>().yearController.text;
    String _month = context.watch<SignupProvider>().monthController.text;
    String _day = context.watch<SignupProvider>().dayController.text;
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
                    ? CommonButton(
                        width: 280.0,
                        height: 50.0,
                        title: '다음',
                        buttonColor: _name != ''
                            ? ButtonColor.primary
                            : ButtonColor.inactive,
                        onTap: () {
                          if (_name == '') return;
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
                          CommonButton(
                            width: 150.0,
                            height: 50.0,
                            title: '이전',
                            buttonColor: ButtonColor.inactive,
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
                          CommonButton(
                            width: 150.0,
                            height: 50.0,
                            title: '다음',
                            buttonColor: _currentPage == 1
                                ? _tall != ''
                                    ? ButtonColor.primary
                                    : ButtonColor.inactive
                                : _currentPage == 2
                                    ? _weight != ''
                                        ? ButtonColor.primary
                                        : ButtonColor.inactive
                                    : _year != '' && _month != '' && _day != ''
                                        ? ButtonColor.primary
                                        : ButtonColor.inactive,
                            onTap: () {
                              if (_currentPage == 1 && _tall == '') {
                                return;
                              }
                              if (_currentPage == 2 && _weight == '') {
                                return;
                              }
                              if (_currentPage == 3) {
                                if (_year != '' && _month != '' && _day != '') {
                                  Navigator.of(context).pushNamed('/main');
                                } else {
                                  return;
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
                SizedBox(height: height * 0.045),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
