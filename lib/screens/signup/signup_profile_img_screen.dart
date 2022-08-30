import 'package:flutter/material.dart';

class SignupProfileImgScreen extends StatelessWidget {
  const SignupProfileImgScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: height * 0.12),
        //로고
        Image.asset(
          'assets/icons/ic_logo.png',
          width: width * 0.25,
        ),
        SizedBox(height: height * 0.12),
        const Text(
          '프로필 사진을 등록해주세요.',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        const SizedBox(height: 40.0),
        Container(
          padding: const EdgeInsets.all(50.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Image.asset(
            'assets/images/camera.png',
            width: 80.0,
            height: 80.0,
          ),
        ),
      ],
    );
  }
}
