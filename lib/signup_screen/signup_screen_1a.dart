import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:three_youth_app/base/base_app_bar.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/signup_screen/pagecontroller_widget.dart';
import 'package:three_youth_app/utils/color.dart';

class SignupScreen1a extends StatefulWidget {
  const SignupScreen1a({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;

  @override
  _SignupScreen1aState createState() => _SignupScreen1aState();
}

class _SignupScreen1aState extends State<SignupScreen1a> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  bool isConsent = false;

  String sAgree ='...';

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        isLoading = false;
      });
    });
    super.initState();

    readAgree();
  }

  void readAgree() async {
    final ss = await rootBundle.loadString('assets/person.txt');
    setState(() {
      sAgree = ss;
    });
  }

  Widget getAgreeText()
  {
    return Text(
      sAgree,
      style: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? spinkit
        : Scaffold(
      backgroundColor: ColorAssets.commonBackgroundDark,
      appBar: const BaseAppBar(),
      //drawer: ,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                '회원가입 2/4',
                style: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 300,
                height: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: 0.333,
                    backgroundColor: ColorAssets.progressBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(ColorAssets.purpleGradient2),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    color: ColorAssets.borderGrey,
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(10),
                width: _screenWidth * 0.8,
                height: 300,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Flexible(child: Text(
                      sAgree,
                      style: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 10, fontWeight: FontWeight.bold),
                    ),),
                  ),

                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '동의하기',
                    style: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: isConsent,
                      shape: const CircleBorder(),
                      side: const BorderSide(color: ColorAssets.borderGrey),
                      activeColor: ColorAssets.purpleGradient1,
                      onChanged: (value) {
                        setState(() {
                          isConsent = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              PagecontrollerWidget(
                screenHeight: _screenHeight,
                screenWidth: _screenWidth,
                widget1a: widget,
                isAble: isConsent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
