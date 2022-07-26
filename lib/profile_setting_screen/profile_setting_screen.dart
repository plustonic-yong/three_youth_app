import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/base/navigate_app_bar.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/custom/common_button.dart';
import 'package:three_youth_app/php/cube_class_api.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/toast.dart';

enum Gender { male, female }

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({Key? key}) : super(key: key);

  @override
  _ProfileSettingScreenState createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  bool isBirthDate = true;
  String dateTime = '';
  CubeClassAPI cubeClassAPI = CubeClassAPI();
  Gender? gender = Gender.male;
  late SharedPreferences prefs;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final GlobalKey<FormFieldState> _nameFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _heightFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _weightFormKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {

        prefs = await SharedPreferences.getInstance();

      String id = prefs.getString('id') ?? '';
      String sql = 'SELECT * FROM login_info WHERE 아이디=("$id")';
      String result = '';
      try {
        result = await cubeClassAPI.sqlToText(sql);
      } on FormatException catch (e) {
        log(e.toString());
        showToast('서버 연결 에러, 인터넷 연결 확인 후 다시 시도해보세요');
      }
      Map mapResult = jsonDecode(result);
      setState(() {
        _nameController.text = mapResult['result'][0]['8'];
        _heightController.text = mapResult['result'][0]['4'];
        _weightController.text = mapResult['result'][0]['5'];
        gender = mapResult['result'][0]['6'] == 'true' ? Gender.male : Gender.female;
        dateTime = mapResult['result'][0]['7'];
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorAssets.commonBackgroundDark,
      appBar: const NavigateAppBar(),
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
                    const Text(
                      '프로필 설정',
                      style: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: _screenWidth * 0.8,
                      child: TextFormField(
                        style: const TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          suffixIconConstraints: BoxConstraints(maxHeight: 20),
                          labelText: '이름',
                          labelStyle: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 16, fontWeight: FontWeight.bold),
                          hintText: '성함을 입력해주세요',
                          hintStyle: TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorAssets.fontDarkGrey),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        controller: _nameController,
                        key: _nameFormKey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: _screenWidth * 0.8,
                      child: TextFormField(
                        style: const TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          suffixIconConstraints: BoxConstraints(maxHeight: 20),
                          labelText: '신장 cm',
                          labelStyle: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 16, fontWeight: FontWeight.bold),
                          hintText: '175.0',
                          hintStyle: TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorAssets.fontDarkGrey),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: _heightController,
                        key: _heightFormKey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: _screenWidth * 0.8,
                      child: TextFormField(
                        style: const TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          suffixIconConstraints: BoxConstraints(maxHeight: 20),
                          labelText: '몸무게 kg',
                          labelStyle: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 16, fontWeight: FontWeight.bold),
                          hintText: '88.0',
                          hintStyle: TextStyle(fontSize: 14, color: ColorAssets.fontDarkGrey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorAssets.fontDarkGrey),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        key: _weightFormKey,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    genderSelect(),
                    const SizedBox(
                      height: 20,
                    ),
                    birthDateForm(context),
                    const SizedBox(
                      height: 30,
                    ),
                    CommonButton(
                        screenWidth: _screenWidth * 0.6,
                        txt: '프로필 변경',
                        onPressed: () async {
                          String id = prefs.getString('id') ?? '';
                          String sql =
                              'UPDATE login_info SET 신장 = "${_heightController.text}", 몸무게 = "${_weightController.text}" , 성별 = "${gender == Gender.male}", 생년월일 = "$dateTime", 이름 = "${_nameController.text}" WHERE 아이디=("$id")';
                          //'UPDATE login_info SET 신장 = ${_heightController.text}, 몸무게 = ${_weightController.text}, 성별 = ${gender == Gender.male}, 생년월일 = $dateTime, 이름 = ${_nameController.text} WHERE 아이디=("$id")';
                          try {
                            await cubeClassAPI.sqlToText(sql);
                            showToast('변경완료');
                            Navigator.pop(context);
                          } on FormatException catch (e) {
                            log(e.toString());
                            showToast('서버 연결 에러, 인터넷 연결 확인 후 다시 시도해보세요');
                          }
                        }),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  SizedBox birthDateForm(BuildContext context) {
    return SizedBox(
      width: _screenWidth * 0.8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return ColorAssets.white;
                      } else {
                        return ColorAssets.white;
                      }
                    })),
                    onPressed: () {
                      DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(1900, 1, 1), maxTime: DateTime(2021, 12, 31), onChanged: (date) {}, onConfirm: (date) {
                        setState(() {
                          dateTime = DateFormat('yyyy년 MM월 dd일').format(date);
                          isBirthDate = true;
                        });
                      }, currentTime: DateTime.parse("1960-10-10T14:58:04+09:00"), locale: LocaleType.ko);
                    },
                    child: const Text(
                      '생년월일',
                      style: TextStyle(color: ColorAssets.fontDarkGrey),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    dateTime,
                    style: const TextStyle(fontSize: 16, color: ColorAssets.fontDarkGrey),
                  )
                ],
              ),
              Image.asset(
                isBirthDate ? "assets/images/check.png" : "assets/images/circle.png",
                width: 20,
              ),
            ],
          ),
          Container(
            color: Colors.grey,
            width: _screenWidth * 0.8,
            height: 1,
          ),
        ],
      ),
    );
  }

  Row genderSelect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 60,
          width: _screenWidth * 0.45,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorAssets.borderGrey,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: ColorAssets.white,
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    Icons.male_outlined,
                    size: 24,
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    '남자',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21, color: ColorAssets.fontDarkGrey),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Radio(
                  fillColor: MaterialStateColor.resolveWith((states) => ColorAssets.fontDarkGrey),
                  value: Gender.male,
                  groupValue: gender,
                  onChanged: (Gender? value) {
                    setState(() {
                      gender = value;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          height: 60,
          width: _screenWidth * 0.45,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorAssets.borderGrey,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: ColorAssets.white,
          ),

          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Icon(
                  Icons.female_outlined,
                  size: 24,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    '여자',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21, color: ColorAssets.fontDarkGrey),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Radio(
                  fillColor: MaterialStateColor.resolveWith((states) => ColorAssets.fontDarkGrey),
                  value: Gender.female,
                  groupValue: gender,
                  onChanged: (Gender? value) {
                    setState(() {
                      gender = value;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
