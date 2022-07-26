import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/base/base_app_bar.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/custom/gradient_small_button.dart';
import 'package:three_youth_app/php/cube_class_api.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/toast.dart';

import 'findpwd_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormFieldState> _emailFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFormKey = GlobalKey<FormFieldState>();
  bool _isEmailForm = false;
  bool _isPasswordForm = false;
  bool _isSubmitButtonEnabled = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _screenWidth = MediaQuery.of(context).size.width;
      _screenHeight = MediaQuery.of(context).size.height;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: ColorAssets.commonBackgroundDark,
        appBar: const BaseAppBar(),
        //drawer: ,
        body: SingleChildScrollView(
          child: isLoading
              ? spinkit
              : Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      emailTextFormField(),
                      const SizedBox(
                        height: 30,
                      ),
                      passwordTextFormField(),
                      LoginButton(
                        id: _emailController.text,
                        pwd: _passwordController.text,
                        isEnabled: _isSubmitButtonEnabled,
                      ),
                      FindPasswordButton(context),
                      const SignUpButton(),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Updated 22.05.28'),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  SizedBox emailTextFormField() {
    return SizedBox(
      width: _screenWidth * 0.8,
      child: TextFormField(
        style: const TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 14),
        decoration: const InputDecoration(
          suffixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              Icons.check_circle_outline,
              size: 24,
            ),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          suffixIconConstraints: BoxConstraints(maxHeight: 20),
          labelText: '이메일 입력',
          labelStyle: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 16, fontWeight: FontWeight.bold),
          hintText: '이메일을 입력하세요',
          hintStyle: TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorAssets.fontDarkGrey),
          ),
        ),
        controller: _emailController,
        textInputAction: TextInputAction.next,
        key: _emailFormKey,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            _isEmailForm = _emailFormKey.currentState!.validate();
            _isSubmitButtonEnabled = _isFormValid();
          });
        },
        validator: (value) {
          //!Error: Pattern pattern => String pattern;
          String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(pattern);
          return (regex.hasMatch(value!)) ? null : '이메일 형식으로 입력해주세요';
        },
      ),
    );
  }

  SizedBox passwordTextFormField() {
    return SizedBox(
      width: _screenWidth * 0.8,
      child: TextFormField(
        style: const TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 14),
        decoration: const InputDecoration(
          suffixIcon: Align(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Icon(
              Icons.check_circle_outline,
              size: 24,
            ),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          suffixIconConstraints: BoxConstraints(maxHeight: 20),
          labelText: '비밀번호 입력',
          labelStyle: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 16, fontWeight: FontWeight.bold),
          hintText: '비밀번호를 입력하세요',
          hintStyle: TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorAssets.fontDarkGrey),
          ),
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        controller: _passwordController,
        key: _passwordFormKey,
        onChanged: (value) {
          setState(() {
            _isPasswordForm = _passwordFormKey.currentState!.validate();
            _isSubmitButtonEnabled = _isFormValid();
          });
        },
        validator: (value) {
          if (value!.length < 6) {
            return '6자리 이상 입력해주세요';
          }
          return null;
        },
      ),
    );
  }

  bool _isFormValid() {
    return ((_emailFormKey.currentState!.isValid && _passwordFormKey.currentState!.isValid));
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, required this.id, required this.pwd, required this.isEnabled}) : super(key: key);

  final String id;
  final String pwd;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 60.0, right: 60.0, bottom: 10.0, top: 60.0),
      child: GradientSmallButton(
        width: double.infinity,
        height: 60,
        radius: 50.0,
        child: const Text(
          '로그인',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[ColorAssets.greenGradient1, ColorAssets.purpleGradient2],
        ),
        onPressed: () async {
          CubeClassAPI cubeClassAPI = CubeClassAPI();
          if (isEnabled) {
            String sql = 'SELECT * FROM login_info WHERE 아이디=("$id")';
            //String sql = 'SELECT * FROM login_info';
            //String sql = "INSERT INTO login_info (아이디, 패스워드, 신장, 몸무게, 성별, 생년월일, 이메일 ) VALUES ('bbb@gmail.com', '1234', '180cm', '100kg', '여', '001225', 'bbb@gmail.com')";\
            String result = '';
            try {
              result = await cubeClassAPI.sqlToText(sql);
            } on FormatException catch (e) {
              log(e.toString());
              showToast('로그인 에러');
            }

            Map mapResult = jsonDecode(result);
            if (mapResult['result'].toString() == '[]') {
              showToast('가입되지 않은 이메일 주소입니다.');
            }
            if (mapResult['result'][0]['3'] == pwd) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLogin', true);
              await prefs.setString('id', id);
              await prefs.setString('empname', mapResult['result'][0]['8']);
              Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
            } else {
              showToast('비밀번호가 맞지 않습니다.');
            }
          } else {
            showToast('이메일과 비밀번호를 올바르게 입력해주세요');
          }
        },
      ),
    );
  }
}

Widget FindPasswordButton(context)
{
  return Container(
    margin: const EdgeInsets.only(left: 60.0, right: 60.0, bottom: 10.0, top: 10.0),
    child: GradientSmallButton(
      width: double.infinity,
      height: 60,
      radius: 50.0,
      child: const Text(
        '비밀번호 찾기',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18.0),
      ),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[ColorAssets.greenGradient1, ColorAssets.purpleGradient2],
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const FindPwd()),
        );
        // Navigator.pushNamedAndRemoveUntil(context, '/findpwd', (route) => false);
      },
    ),
  );
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 60.0, right: 60.0, bottom: 10.0, top: 10.0),
      child: GradientSmallButton(
        width: double.infinity,
        height: 60,
        radius: 50.0,
        child: const Text(
          '회원가입',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[ColorAssets.greenGradient1, ColorAssets.purpleGradient2],
        ),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/signup', (route) => false);
        },
      ),
    );
  }
}
