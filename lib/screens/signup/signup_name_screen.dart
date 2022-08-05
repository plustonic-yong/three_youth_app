import 'package:flutter/material.dart';
import 'package:three_youth_app/screens/signup/components/signup_input.dart';

class SignupNameScreen extends StatelessWidget {
  const SignupNameScreen({Key? key}) : super(key: key);

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
          '당신의 이름은 무엇인가요?',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: height * 0.06),
        const SizedBox(height: 30.0),
        const SignupInput(page: 0),
      ],
    );
  }
}
