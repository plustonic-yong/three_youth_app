import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/base/base_app_bar.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/custom/gradient_small_button.dart';
import 'package:three_youth_app/php/cube_class_api.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/toast.dart';

import '../base/back_app_bar.dart';
import '../base/navigate_app_bar.dart';
import '../php/classCubeAPI.dart';

class ResetPwdScreen extends StatefulWidget {
  const ResetPwdScreen({Key? key}) : super(key: key);

  @override
  _ResetPwdScreenState createState() => _ResetPwdScreenState();
}

class _ResetPwdScreenState extends State<ResetPwdScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  final GlobalKey<FormFieldState> _emailFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _edtCheckNumKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _passwordFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _password2FormKey = GlobalKey<FormFieldState>();

  bool _isPasswordForm = false;
  bool _isPassword2Form = false;

  String sCheckNum = '';
  bool isSendCheckNum = false;

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

  Widget getAppBar()
  {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      backgroundColor: ColorAssets.white,
      leading: SizedBox(
        width: 50,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorAssets.fontDarkGrey,
          ),
          onPressed: () {

          },
        ),
      ),
      title: InkWell(
        onTap: () {
          //Navigator.pushNamedAndRemoveUntil(context, '/overview', (route) => false);
        },
        child: Image.asset(
          'assets/images/logo_bg_none.png',
          width: 320,
          height: 65,
        ),
      ),
      centerTitle: true,
      actions: const [
        SizedBox(
          width: 55,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: ColorAssets.commonBackgroundDark,
        appBar: const BackAppBar(),
        //drawer: ,
        body: SingleChildScrollView(
          child: isLoading
              ? spinkit
              : Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),

                      passwordTextFormField(),
                      const SizedBox(
                        height: 10,
                      ),
                      repasswordTextFormField(),
                      const SizedBox(
                        height: 10,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      btnPwdSave(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  SizedBox passwordTextFormField() {
    return SizedBox(
      width: _screenWidth * 0.8,
      child: TextFormField(
        style: const TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 14),
        decoration: InputDecoration(
          suffixIcon: Image.asset(
            _isPasswordForm ? "assets/images/check.png" : "assets/images/circle.png",
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          suffixIconConstraints: const BoxConstraints(maxHeight: 20),
          labelText: '비밀번호 입력',
          labelStyle: const TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 16, fontWeight: FontWeight.bold),
          hintText: '비밀번호를 입력하세요',
          hintStyle: const TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorAssets.fontDarkGrey),
          ),
        ),
        obscureText: true,
        textInputAction: TextInputAction.next,
        controller: _passwordController,
        key: _passwordFormKey,
        onChanged: (value) {
          setState(() {
            _isPasswordForm = _passwordFormKey.currentState!.validate();
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

  SizedBox repasswordTextFormField() {
    return SizedBox(
      width: _screenWidth * 0.8,
      child: TextFormField(
        style: const TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 14),
        decoration: InputDecoration(
          suffixIcon: Image.asset(
            _isPassword2Form ? "assets/images/check.png" : "assets/images/circle.png",
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          suffixIconConstraints: const BoxConstraints(maxHeight: 20),
          labelText: '비밀번호 재입력',
          labelStyle: const TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 16, fontWeight: FontWeight.bold),
          hintText: '비밀번호를 입력하세요',
          hintStyle: const TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorAssets.fontDarkGrey),
          ),
        ),
        obscureText: true,
        controller: _password2Controller,
        textInputAction: TextInputAction.done,
        key: _password2FormKey,
        onChanged: (value) {
          setState(() {
            _isPasswordForm = _passwordFormKey.currentState!.validate();
            _isPassword2Form = _password2FormKey.currentState!.validate();
          });
        },
        validator: (value) {
          if (value!.length < 6) {
            return '6자리 이상 입력해주세요';
          } else if (value != _passwordController.text) {
            return '비밀번호가 다릅니다';
          }
          return null;
        },
      ),
    );
  }

  Widget btnPwdSave()
  {
    return Container(
      margin: const EdgeInsets.only(left: 60.0, right: 60.0, bottom: 10.0, top: 60.0),
      child: GradientSmallButton(
        width: double.infinity,
        height: 60,
        radius: 50.0,
        child: const Text(
          '비밀번호 변경',
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

          if(_passwordController.text.length < 6 || _password2Controller.text.length < 6)
          {
            showToast('비밀번호를 6자리 이상 입력하세요.');
            return;
          }
          if(_passwordController.text != _password2Controller.text)
          {
            showToast('확인용 비밀번호가 맞지 않습니다.');
            return;
          }

          SharedPreferences prefs = await SharedPreferences.getInstance();

          String id = prefs.getString('id') ?? '';
          String pwd = _passwordController.text;

          String sql = "update login_info set 패스워드 = '" + pwd + "' where 아이디 = '" + id + "' ";

          try {
            TCubeAPI ca = TCubeAPI();
            String result = await ca.sqlExecPost(sql);
            if(result.contains('TRUE'))
            {
              showToast('비밀번호가 변경되었습니다.');

              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            }
          } on FormatException catch (e) {
            print(e.toString());
            showToast('서버 처리 에러');
          }
        },
      ),
    );
  }
}
