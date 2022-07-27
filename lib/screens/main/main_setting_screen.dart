import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/screens/base/simple_dialog.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/screens/custom/common_button.dart';
import 'package:three_youth_app/screens/history/locallog_appscreen.dart';

class MainSettingScreen extends StatefulWidget {
  const MainSettingScreen({Key? key}) : super(key: key);

  @override
  _MainSettingScreenState createState() => _MainSettingScreenState();
}

class _MainSettingScreenState extends State<MainSettingScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  late SharedPreferences prefs;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        isLoading = false;
      });
    });
    super.initState();
  }

  void func() async {
    prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLogin', false);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? spinkit
        : Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              CommonButton(
                screenWidth: _screenWidth * 0.6,
                txt: '프로필 설정',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/profile',
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              CommonButton(
                screenWidth: _screenWidth * 0.6,
                txt: '심전도 설정',
                onPressed: () {
                  Navigator.pushNamed(context, '/electrocardiogram');
                },
              ),
              const SizedBox(
                height: 30,
              ),
              CommonButton(
                screenWidth: _screenWidth * 0.6,
                txt: '로컬보관함 관리',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocalLogAppScreen()),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              CommonButton(
                screenWidth: _screenWidth * 0.6,
                txt: '예방 콘텐츠',
                onPressed: () {
                  Navigator.pushNamed(context, '/safecontent');
                },
              ),
              const SizedBox(
                height: 30,
              ),
              CommonButton(
                screenWidth: _screenWidth * 0.6,
                txt: '약관 및 지원',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/agreement',
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              CommonButton(
                screenWidth: _screenWidth * 0.6,
                txt: '로그아웃',
                onPressed: () async {
                  simpleDialog(context, '로그아웃', '로그아웃 하시겠습니까?', func);
                },
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          );
  }
}
