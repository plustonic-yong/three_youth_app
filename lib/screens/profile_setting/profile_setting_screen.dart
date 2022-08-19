import 'package:flutter/material.dart';
import 'package:three_youth_app/providers/auth_provider.dart';
import 'package:three_youth_app/screens/profile_setting/components/profile_setting_birth_input_form.dart';
import 'package:three_youth_app/screens/profile_setting/components/profile_setting_id_input_form.dart';
import 'package:three_youth_app/screens/profile_setting/components/profile_setting_tall_input_form.dart';
import 'package:three_youth_app/screens/profile_setting/components/profile_setting_weight_input_form.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/widget/common_button.dart';
import 'package:provider/provider.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //프로필 사진, 이름, 나이, 성별
              Row(
                children: [
                  CircleAvatar(
                    radius: 32.0,
                    child: Image.asset(
                      'assets/images/profile_img_1.png',
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '홍길동님',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '60세 여성',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              //생년월일
              // _birthInputForm(context: context, width: width, height: height),
              const ProfileSettingBirthInputForm(),
              const SizedBox(height: 20.0),
              //키
              const ProfileSettingTallInputForm(),
              const SizedBox(height: 20.0),
              //몸무게
              const ProfileSettingWeightInputForm(),
              const SizedBox(height: 20.0),
              CommonButton(
                height: 40.0,
                width: width,
                title: '저장',
                buttonColor: ButtonColor.inactive,
              ),
              const SizedBox(height: 20.0),
              //ID
              const ProfileSettingIdInputForm(),
              const Spacer(),
              //버전
              const Text(
                'Ver.22.06.07.a',
                style: TextStyle(
                  color: Color(0xffC8C8C8),
                ),
              ),

              const SizedBox(height: 30.0),
              //이용약관, 개인정보처리방침
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: '이용약관',
                    buttonColor: ButtonColor.inactive,
                    fontSize: 16.0,
                  ),
                  CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: '개인정보 처리방침',
                    buttonColor: ButtonColor.inactive,
                    fontSize: 16.0,
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              //탈퇴, 로그아웃
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: '탈퇴',
                    buttonColor: ButtonColor.warning,
                    fontSize: 16.0,
                  ),
                  CommonButton(
                    height: 40.0,
                    width: 160.0,
                    title: '로그아웃',
                    buttonColor: ButtonColor.inactive,
                    fontSize: 16.0,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              contentPadding: const EdgeInsets.all(30.0),
                              actionsPadding: const EdgeInsets.all(10.0),
                              actions: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    '취소',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                GestureDetector(
                                  onTap: () {
                                    context.read<AuthProvider>().logout();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      '/login',
                                      (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    '확인',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                              ],
                              content: const Text(
                                '로그아웃 하시겠습니까?',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: kBottomNavigationBarHeight + 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
