import 'package:flutter/material.dart';
import 'package:three_youth_app/screens/signup/components/signup_input.dart';

class SignupWeightScreen extends StatelessWidget {
  const SignupWeightScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: height * 0.12),
        //로고
        Image.asset(
          'assets/icons/logo.png',
          width: width * 0.25,
        ),
        SizedBox(height: height * 0.16),
        const Text(
          '몸무게는 어떻게 되세요?',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: height * 0.06),
        const SizedBox(height: 30.0),
        const SignupInput(page: 2),
      ],
    );
  }
}
