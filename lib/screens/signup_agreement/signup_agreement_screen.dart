import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/providers/signup_agreement_provider.dart';
import 'package:three_youth_app/widget/agreement/personal_info_policy.dart';
import 'package:three_youth_app/widget/agreement/use_of_terms.dart';

class SignupAgreementScreen extends StatefulWidget {
  const SignupAgreementScreen({Key? key}) : super(key: key);

  @override
  State<SignupAgreementScreen> createState() => _SignupAgreementScreenState();
}

class _SignupAgreementScreenState extends State<SignupAgreementScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    PageController _pageController = PageController(initialPage: 0);
    bool _isInfoAgreeChecked =
        context.watch<SignupAgreementProvider>().isInfoAgreeChecked;
    bool _isTermsAgreeChecked =
        context.watch<SignupAgreementProvider>().isTermsAgreeChecked;
    int _currentPage = context.watch<SignupAgreementProvider>().currentPage;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          _currentPage == 0 ? '이용약관' : '개인정보 처리방침',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                pageSnapping: false,
                onPageChanged: (page) {
                  context
                      .read<SignupAgreementProvider>()
                      .onChangeAgreementCurrentPage(page: page);
                },
                children: [
                  SingleChildScrollView(
                    child: useOfTerms(),
                  ),
                  SingleChildScrollView(
                    child: personalInfoPolicy(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 160.0,
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            decoration: const BoxDecoration(
              color: Color(0xff464646),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_currentPage == 0) {
                      context
                          .read<SignupAgreementProvider>()
                          .onChangeInfoAgree();
                    } else {
                      context
                          .read<SignupAgreementProvider>()
                          .onChangeTermsAgree();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: _currentPage == 0
                            ? Icon(
                                Icons.check,
                                color: _isInfoAgreeChecked
                                    ? Colors.black
                                    : Colors.transparent,
                              )
                            : Icon(
                                Icons.check,
                                color: _isTermsAgreeChecked
                                    ? Colors.black
                                    : Colors.transparent,
                              ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        '위 약관에 동의합니다.',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //이전 버튼
                    _currentPage != 0
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutSine,
                                );
                              });
                            },
                            child: Container(
                              width: width * 0.38,
                              height: height * 0.053,
                              decoration: BoxDecoration(
                                color: const Color(0xffffffff).withOpacity(0.3),
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
                    _currentPage == 1
                        ? const SizedBox(width: 15.0)
                        : Container(),
                    //다음 버튼
                    GestureDetector(
                      onTap: () {
                        if (_currentPage == 0) {
                          if (!_isInfoAgreeChecked) return;

                          setState(() {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          });
                        } else {
                          if (!_isTermsAgreeChecked) return;
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => const SignupScreen(),
                          //   ),
                          // );
                          Navigator.of(context).pushNamed('/signup');
                        }
                      },
                      child: Container(
                        width: _currentPage == 0 ? width * 0.68 : width * 0.38,
                        // width: double.infinity,
                        height: height * 0.053,
                        decoration: _currentPage == 0
                            ? _isInfoAgreeChecked
                                ? BoxDecoration(
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
                                          0,
                                          3,
                                        ), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(25.0),
                                  )
                                : BoxDecoration(
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
                                  )
                            : _isTermsAgreeChecked
                                ? BoxDecoration(
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
                                          0,
                                          3,
                                        ), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(25.0),
                                  )
                                : BoxDecoration(
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
