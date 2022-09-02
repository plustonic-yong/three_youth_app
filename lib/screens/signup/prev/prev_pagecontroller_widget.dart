import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/services/php/cube_class_api.dart';
import 'package:three_youth_app/screens/custom/gradient_small_button.dart';
import 'package:three_youth_app/screens/signup/prev/prev_signup_screen_1.dart';
import 'package:three_youth_app/screens/signup/prev/prev_signup_screen_1a.dart';
import 'package:three_youth_app/screens/signup/prev/prev_signup_screen_2.dart';
import 'package:three_youth_app/screens/signup/prev/prev_signup_screen_3.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/providers/current_user_provider.dart';
import 'package:three_youth_app/utils/toast.dart';

class PrevPagecontrollerWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final PrevSignupScreen1? widget1;
  final PrevSignupScreen1a? widget1a;
  final PrevSignupScreen2? widget2;
  final PrevSignupScreen3? widget3;
  final bool isAble;
  final String? id;
  final String? pwd;
  final String? name;
  final String? height;
  final String? weight;
  final bool? isMale;
  final String? birthDate;

  const PrevPagecontrollerWidget(
      {Key? key,
      required this.screenHeight,
      required this.screenWidth,
      this.widget1,
      this.widget1a,
      this.widget2,
      this.widget3,
      required this.isAble,
      this.id,
      this.pwd,
      this.name,
      this.height,
      this.weight,
      this.isMale,
      this.birthDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: screenHeight * 0.08,
          ),
          alignment: Alignment.bottomCenter,
          child: GradientSmallButton(
            width: screenWidth * 0.4,
            height: 60,
            radius: 50.0,
            child: const Text(
              '뒤로가기',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                ColorAssets.greenGradient1,
                ColorAssets.purpleGradient2
              ],
            ),
            onPressed: () {
              if (widget1 != null) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              } else if (widget1a != null) {
                widget1a!.pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else if (widget2 != null) {
                Provider.of<CurrentUserProvider>(context, listen: false).id =
                    id!;
                Provider.of<CurrentUserProvider>(context, listen: false).pwd =
                    pwd!;

                widget2!.pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                Provider.of<CurrentUserProvider>(context, listen: false)
                    .isMale = isMale!;
                Provider.of<CurrentUserProvider>(context, listen: false).name =
                    name!;
                Provider.of<CurrentUserProvider>(context, listen: false)
                    .height = height!;
                Provider.of<CurrentUserProvider>(context, listen: false)
                    .weight = weight!;
                Provider.of<CurrentUserProvider>(context, listen: false)
                    .birthDate = birthDate!;

                widget3!.pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: screenHeight * 0.08,
          ),
          alignment: Alignment.bottomCenter,
          child: GradientSmallButton(
            width: screenWidth * 0.4,
            height: 60,
            radius: 50.0,
            child: Text(
              widget3 != null ? '가입완료' : '다음으로',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isAble
                  ? <Color>[
                      ColorAssets.greenGradient1,
                      ColorAssets.purpleGradient2
                    ]
                  : <Color>[Colors.grey, Colors.grey],
            ),
            onPressed: () async {
              CubeClassAPI cubeClassAPI = CubeClassAPI();

              if (isAble) {
                if (widget3 != null) {
                  String sql =
                      "INSERT INTO login_info (아이디, 패스워드, 신장, 몸무게, 성별, 생년월일, 이름 ) VALUES ('${Provider.of<CurrentUserProvider>(context, listen: false).id}', '${Provider.of<CurrentUserProvider>(context, listen: false).pwd}', '$height', '$weight', '$isMale', '$birthDate', '$name')";
                  try {
                    await cubeClassAPI.sqlToText(sql);
                  } on FormatException catch (e) {
                    log(e.toString());
                    showToast('서버 연결 에러, 인터넷 연결 확인 후 다시 시도해보세요');
                  }
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                } else if (widget1 != null) {
                  widget1!.pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else if (widget1a != null) {
                  widget1a!.pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Provider.of<CurrentUserProvider>(context, listen: false).id =
                      id!;
                  Provider.of<CurrentUserProvider>(context, listen: false).pwd =
                      pwd!;

                  String sql = 'SELECT * FROM login_info WHERE 아이디=("$id")';
                  String result = '';
                  try {
                    result = await cubeClassAPI.sqlToText(sql);
                  } on FormatException catch (e) {
                    log(e.toString());
                    showToast('서버 연결 에러, 인터넷 연결 확인 후 다시 시도해보세요');
                  }
                  Map mapResult = jsonDecode(result);
                  if (mapResult['result'].toString() == '[]') {
                    widget2!.pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    showToast('이미 가입된 이메일 주소입니다.');
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
