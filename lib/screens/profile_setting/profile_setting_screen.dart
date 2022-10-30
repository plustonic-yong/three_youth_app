import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:three_youth_app/models/user_model.dart';
import 'package:three_youth_app/providers/auth_provider.dart';
import 'package:three_youth_app/providers/user_provider.dart';
import 'package:three_youth_app/screens/profile_setting/components/profile_setting_birth_input_form.dart';
import 'package:three_youth_app/screens/profile_setting/components/profile_setting_id_input_form.dart';
import 'package:three_youth_app/screens/profile_setting/components/profile_setting_height_input_form.dart';
import 'package:three_youth_app/screens/profile_setting/components/profile_setting_weight_input_form.dart';
import 'package:three_youth_app/screens/profile_setting/personal_info_policy_screen.dart';
import 'package:three_youth_app/screens/profile_setting/use_of_terms_screen.dart';
import 'package:three_youth_app/utils/enums.dart';
import 'package:three_youth_app/utils/utils.dart';
import 'package:three_youth_app/widget/common/common_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as foundation;

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double botomNavigationBarHeight =
        foundation.defaultTargetPlatform == foundation.TargetPlatform.android
            ? kBottomNavigationBarHeight + 27.0
            : 140.0;
    UserModel? _userInfo = context.watch<UserProvider>().userInfo;
    String _height = context.watch<UserProvider>().height;
    String _weight = context.watch<UserProvider>().weight;
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - botomNavigationBarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //프로필 사진, 이름, 나이, 성별
              _userInfo != null
                  ? Row(
                      children: [
                        Stack(
                          fit: StackFit.loose,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final ImagePicker _picker = ImagePicker();
                                XFile? value = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  maxWidth: 750,
                                  maxHeight: 750,
                                );
                                if (value != null) {
                                  var result = await context
                                      .read<UserProvider>()
                                      .updateUser(
                                        height: _height,
                                        weight: _weight,
                                        img: value.path,
                                      );

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          contentPadding:
                                              const EdgeInsets.all(30.0),
                                          actionsPadding:
                                              const EdgeInsets.all(10.0),
                                          actions: [
                                            GestureDetector(
                                              onTap: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text(
                                                '확인',
                                                style:
                                                    TextStyle(fontSize: 18.0),
                                              ),
                                            ),
                                          ],
                                          content: Text(
                                            result
                                                ? '프로필 사진이 수정되었습니다.'
                                                : '프로필 사진 수정에 실패했습니다.',
                                            style:
                                                const TextStyle(fontSize: 18.0),
                                          ),
                                        );
                                      });
                                  await context
                                      .read<UserProvider>()
                                      .getUserInfo();
                                }
                              },
                              child: _userInfo.imgUrl !=
                                      "https://3youth.s3.ap-northeast-2.amazonaws.com/undefined"
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(90.0),
                                      child: Image.network(
                                        _userInfo.imgUrl,
                                        fit: BoxFit.cover,
                                        width: 64.0,
                                        height: 64.0,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 32.0,
                                      child: Image.asset(
                                          'assets/icons/ic_user.png'),
                                    ),
                            ),
                            Positioned(
                              right: 0.0,
                              bottom: 0.0,
                              child: Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/camera.png',
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userInfo.name,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${_userInfo.birth != '' ? Utils.getAge(_userInfo.birth) : '0'}세 ${_userInfo.gender == "M" ? '남성' : '여성'}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 20.0),
              //생년월일
              // _birthInputForm(context: context, width: width, height: height),
              const ProfileSettingBirthInputForm(),
              const SizedBox(height: 20.0),
              // //키
              const ProfileSettingHeightInputForm(),
              const SizedBox(height: 20.0),
              // //몸무게
              const ProfileSettingWeightInputForm(),
              const SizedBox(height: 20.0),
              CommonButton(
                height: 40.0,
                width: _screenWidth,
                title: '저장',
                buttonColor: ButtonColor.primary,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  var result = await context
                      .read<UserProvider>()
                      .updateUser(height: _height, weight: _weight);
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
                                '확인',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ],
                          content: Text(
                            result ? '프로필이 수정되었습니다.' : '프로필 수정에 실패했습니다.',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        );
                      });

                  await context.read<UserProvider>().getUserInfo();
                },
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
                children: [
                  Expanded(
                    child: CommonButton(
                      height: 40.0,
                      width: 160.0,
                      title: '이용약관',
                      buttonColor: ButtonColor.inactive,
                      fontSize: 16.0,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UseOfTermsScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CommonButton(
                      height: 40.0,
                      width: 160.0,
                      title: '개인정보 처리방침',
                      buttonColor: ButtonColor.inactive,
                      fontSize: 16.0,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const PersonalInfoPolicyScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              //탈퇴, 로그아웃
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CommonButton(
                      height: 40.0,
                      width: 160.0,
                      title: '탈퇴',
                      buttonColor: ButtonColor.warning,
                      fontSize: 16.0,
                      onTap: () async {
                        bool result =
                            await context.read<UserProvider>().deleteUser();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return result
                                ? AlertDialog(
                                    contentPadding: const EdgeInsets.all(30.0),
                                    actionsPadding: const EdgeInsets.all(10.0),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
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
                                      '회원탈퇴가 완료되었습니다.',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  )
                                : AlertDialog(
                                    contentPadding: const EdgeInsets.all(30.0),
                                    actionsPadding: const EdgeInsets.all(10.0),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          '확인',
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                    ],
                                    content: const Text(
                                      '회원탈퇴를 실패했습니다..',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CommonButton(
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
                  ),
                ],
              ),
              // SizedBox(
              //   height: botomNavigationBarHeight,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
