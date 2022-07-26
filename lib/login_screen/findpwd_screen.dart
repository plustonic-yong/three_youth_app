import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/base/base_app_bar.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/custom/gradient_small_button.dart';
import 'package:three_youth_app/login_screen/resetpwd_screen.dart';
import 'package:three_youth_app/php/cube_class_api.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/toast.dart';

import '../base/back_app_bar.dart';
import '../base/navigate_app_bar.dart';

class FindPwd extends StatefulWidget {
  const FindPwd({Key? key}) : super(key: key);

  @override
  _FindPwdState createState() => _FindPwdState();
}

class _FindPwdState extends State<FindPwd> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _edtCheckNumController = TextEditingController();

  final GlobalKey<FormFieldState> _emailFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _edtCheckNumKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _passwordFormKey = GlobalKey<FormFieldState>();
  bool _isEmailForm = false;
  bool _isPasswordForm = false;
  bool _isSubmitButtonEnabled = false;

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

                      emailTextFormField(),
                      // const SizedBox(
                      //   height: 10,
                      // ),

                      btnSendEmail(),
                      const SizedBox(
                        height: 20,
                      ),

                      isSendCheckNum ? getInputCheckNum() :
                      const SizedBox(
                        height: 20,
                      ),
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

  bool _isFormValid() {
    return ((_emailFormKey.currentState!.isValid));
  }

  Widget btnSendEmail()
  {
    return Container(
      margin: const EdgeInsets.only(left: 60.0, right: 60.0, bottom: 10.0, top: 60.0),
      child: GradientSmallButton(
        width: double.infinity,
        height: 60,
        radius: 50.0,
        child: const Text(
          '이메일로 인증번호 보내기',
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

          List<String> ll = [];
          for(int i = 0; i < 6; i++)
          {
            String ss = Random().nextInt(9).toString();
            ll.add(ss);
          }

          sCheckNum = ll.join('');

          String toemail = _emailController.text;

          String sql = 'insert into email_send_list (kind, toemail, content) ';
          sql = sql + ' values (\'PWDRST\', \'$toemail\', \'$sCheckNum\') ';
          String result = '';
          try {
            result = await cubeClassAPI.emailSend(sql, toemail, sCheckNum);
            if(result.contains('TRUE'))
              {
                showToast('인증번호가 이메일로 발송되었습니다.');
                setState(() {
                  isSendCheckNum = true;
                });
              }
          } on FormatException catch (e) {
            print(e.toString());
            showToast('서버 처리 에러');
          }
        },
      ),
    );
  }

  Widget getInputCheckNum()
  {
    return Container(
      child: Column(
        children: [
          edtCheckNum(),
          btnCodeCheck(),
        ],
      ),
    );
  }

  Widget btnCodeCheck()
  {
    return Container(
      margin: const EdgeInsets.only(left: 60.0, right: 60.0, bottom: 10.0, top: 60.0),
      child: GradientSmallButton(
        width: double.infinity,
        height: 60,
        radius: 50.0,
        child: const Text(
          '인증번호 확인',
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
          String sCodeInput = _edtCheckNumController.text;
          if(sCodeInput == sCheckNum)
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ResetPwdScreen()),
              );
            }
          else{
            showToast('인증번호가 일치하지 않습니다.');
          }
        },
      ),
    );
  }

  Widget edtCheckNum()
  {
    return SizedBox(
      width: _screenWidth * 0.8,
      child: TextFormField(
        style: const TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 14),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          suffixIconConstraints: BoxConstraints(maxHeight: 20),
          labelText: '인증번호',
          labelStyle: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 16, fontWeight: FontWeight.bold),
          hintText: '이메일로 받은 인증번호를 입력하세요.',
          hintStyle: TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorAssets.fontDarkGrey),
          ),

        ),
        textInputAction: TextInputAction.next,
        controller: _edtCheckNumController,
        key: _edtCheckNumKey,

        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
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
          Navigator.pushNamedAndRemoveUntil(context, '/signup', (route) => false);
        },
      ),
    );
  }
}
