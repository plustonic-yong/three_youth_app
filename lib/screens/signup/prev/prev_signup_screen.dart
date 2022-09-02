import 'package:flutter/material.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/screens/signup/prev/prev_signup_screen_1.dart';
import 'package:three_youth_app/screens/signup/prev/prev_signup_screen_1a.dart';
import 'package:three_youth_app/screens/signup/prev/prev_signup_screen_2.dart';
import 'package:three_youth_app/screens/signup/prev/prev_signup_screen_3.dart';

class PrevSignupScreen extends StatefulWidget {
  const PrevSignupScreen({Key? key}) : super(key: key);

  @override
  _PrevSignupScreenState createState() => _PrevSignupScreenState();
}

class _PrevSignupScreenState extends State<PrevSignupScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  final PageController pageController = PageController(
    initialPage: 0,
  );

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
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? spinkit
        : PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              PrevSignupScreen1(
                pageController: pageController,
              ),
              PrevSignupScreen1a(
                pageController: pageController,
              ),
              PrevSignupScreen2(
                pageController: pageController,
              ),
              PrevSignupScreen3(
                pageController: pageController,
              ),
            ],
          );
  }
}
