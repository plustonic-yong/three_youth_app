import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/screens/base/base_app_bar.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/screens/signup/prev/prev_pagecontroller_widget.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/providers/current_user_provider.dart';

class PrevSignupScreen2 extends StatefulWidget {
  const PrevSignupScreen2({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;

  @override
  _SignupScreen2State createState() => _SignupScreen2State();
}

class _SignupScreen2State extends State<PrevSignupScreen2> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final GlobalKey<FormFieldState> _emailFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFormKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFormKey2 =
      GlobalKey<FormFieldState>();
  bool _isEmailForm = false;
  bool _isPasswordForm = false;
  bool _isPasswordForm2 = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        _emailController.text =
            Provider.of<CurrentUserProvider>(context, listen: false).id;
        _passwordController.text =
            Provider.of<CurrentUserProvider>(context, listen: false).pwd;
        _passwordController2.text = _passwordController.text;
        if (_emailController.text != '') {
          _isEmailForm = true;
          _isPasswordForm = true;
          _isPasswordForm2 = true;
        }
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? spinkit
        : Scaffold(
            backgroundColor: ColorAssets.commonBackgroundDark,
            appBar: const BaseAppBar(),
            //drawer: ,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '회원가입 3/4',
                      style: TextStyle(
                          color: ColorAssets.fontDarkGrey,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      width: 300,
                      height: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          value: 0.666,
                          backgroundColor: ColorAssets.progressBackground,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorAssets.purpleGradient2),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    emailTextFormField(),
                    const SizedBox(
                      height: 30,
                    ),
                    passwordTextFormField(),
                    const SizedBox(
                      height: 30,
                    ),
                    repasswordTextFormField(),
                    const SizedBox(
                      height: 50,
                    ),
                    PrevPagecontrollerWidget(
                      screenHeight: _screenHeight,
                      screenWidth: _screenWidth,
                      widget2: widget,
                      isAble: _isFormValid(),
                      id: _emailController.text,
                      pwd: _passwordController.text,
                    ),
                  ],
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
        decoration: InputDecoration(
          suffixIcon: Image.asset(
            _isEmailForm
                ? "assets/images/check.png"
                : "assets/images/circle.png",
          ),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          suffixIconConstraints: const BoxConstraints(maxHeight: 20),
          labelText: '이메일 입력',
          labelStyle: const TextStyle(
              color: ColorAssets.fontDarkGrey,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          hintText: '이메일을 입력하세요',
          hintStyle:
              const TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
          enabledBorder: const UnderlineInputBorder(
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
          });
        },
        validator: (value) {
          //!Error: Pattern pattern => String pattern;
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
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
        decoration: InputDecoration(
          suffixIcon: Image.asset(
            _isPasswordForm
                ? "assets/images/check.png"
                : "assets/images/circle.png",
          ),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          suffixIconConstraints: const BoxConstraints(maxHeight: 20),
          labelText: '비밀번호 입력',
          labelStyle: const TextStyle(
              color: ColorAssets.fontDarkGrey,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          hintText: '비밀번호를 입력하세요',
          hintStyle:
              const TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
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
            _isPasswordForm2
                ? "assets/images/check.png"
                : "assets/images/circle.png",
          ),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          suffixIconConstraints: const BoxConstraints(maxHeight: 20),
          labelText: '비밀번호 재입력',
          labelStyle: const TextStyle(
              color: ColorAssets.fontDarkGrey,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          hintText: '비밀번호를 입력하세요',
          hintStyle:
              const TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorAssets.fontDarkGrey),
          ),
        ),
        obscureText: true,
        controller: _passwordController2,
        textInputAction: TextInputAction.done,
        key: _passwordFormKey2,
        onChanged: (value) {
          setState(() {
            _isPasswordForm = _passwordFormKey.currentState!.validate();
            _isPasswordForm2 = _passwordFormKey2.currentState!.validate();
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

  bool _isFormValid() {
    return ((_isEmailForm && _isPasswordForm && _isPasswordForm2));
  }
}
