import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_youth_app/screens/base/base_app_bar.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/screens/signup/pagecontroller_widget.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:three_youth_app/utils/current_user.dart';

enum Gender { male, female }

class SignupScreen3 extends StatefulWidget {
  const SignupScreen3({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;

  @override
  _SignupScreen3State createState() => _SignupScreen3State();
}

class _SignupScreen3State extends State<SignupScreen3> {
  bool isLoading = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final GlobalKey<FormFieldState> _nameFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _heightFormKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _weightFormKey = GlobalKey<FormFieldState>();
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  bool isMale = false;
  bool isBirthDate = false;
  Gender? gender = Gender.male;
  String dateTime = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        _nameController.text =
            Provider.of<CurrentUser>(context, listen: false).name;
        _heightController.text =
            Provider.of<CurrentUser>(context, listen: false).height;
        _weightController.text =
            Provider.of<CurrentUser>(context, listen: false).weight;
        dateTime = Provider.of<CurrentUser>(context, listen: false).birthDate;
        gender = Provider.of<CurrentUser>(context, listen: false).isMale
            ? Gender.male
            : Gender.female;
        if (dateTime != '') {
          isBirthDate = true;
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
                      '회원가입 4/4',
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
                          value: 0.999,
                          backgroundColor: ColorAssets.progressBackground,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorAssets.purpleGradient2),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: _screenWidth * 0.8,
                      child: TextFormField(
                        style: const TextStyle(
                            color: ColorAssets.fontDarkGrey, fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          suffixIconConstraints: BoxConstraints(maxHeight: 20),
                          labelText: '이름',
                          labelStyle: TextStyle(
                              color: ColorAssets.fontDarkGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          hintText: '성함을 입력해주세요',
                          hintStyle: TextStyle(
                              fontSize: 14, color: ColorAssets.fontDarkGrey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorAssets.fontDarkGrey),
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
                        style: const TextStyle(
                            color: ColorAssets.fontDarkGrey, fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          suffixIconConstraints: BoxConstraints(maxHeight: 20),
                          labelText: '신장 cm',
                          labelStyle: TextStyle(
                              color: ColorAssets.fontDarkGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          hintText: '175.0',
                          hintStyle: TextStyle(
                              fontSize: 14, color: ColorAssets.fontDarkGrey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorAssets.fontDarkGrey),
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
                        style: const TextStyle(
                            color: ColorAssets.fontDarkGrey, fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          suffixIconConstraints: BoxConstraints(maxHeight: 20),
                          labelText: '몸무게 kg',
                          labelStyle: TextStyle(
                              color: ColorAssets.fontDarkGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          hintText: '88.0',
                          hintStyle: TextStyle(
                              fontSize: 14, color: ColorAssets.fontDarkGrey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorAssets.fontDarkGrey),
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
                      height: 40,
                    ),
                    birthDateForm(context),
                    const SizedBox(
                      height: 50,
                    ),
                    PagecontrollerWidget(
                      screenHeight: _screenHeight,
                      screenWidth: _screenWidth,
                      widget3: widget,
                      isAble: _isFormValid(),
                      name: _nameController.text,
                      height: _heightController.text,
                      weight: _weightController.text,
                      birthDate: dateTime,
                      isMale: gender == Gender.male,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  bool _isFormValid() {
    return ((_nameController.text != '' &&
        _weightController.text != '' &&
        _heightController.text != '' &&
        isBirthDate));
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
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return ColorAssets.white;
                      } else {
                        return ColorAssets.white;
                      }
                    })),
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 1, 1),
                          maxTime: DateTime(2021, 12, 31),
                          onChanged: (date) {}, onConfirm: (date) {
                        setState(() {
                          dateTime = DateFormat('yyyy년 MM월 dd일').format(date);
                          isBirthDate = true;
                        });
                      },
                          currentTime:
                              DateTime.parse("1960-10-10T14:58:04+09:00"),
                          locale: LocaleType.ko);
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
                    style: const TextStyle(
                        fontSize: 16, color: ColorAssets.fontDarkGrey),
                  )
                ],
              ),
              Image.asset(
                isBirthDate
                    ? "assets/images/check.png"
                    : "assets/images/circle.png",
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
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 21,
                        color: ColorAssets.fontDarkGrey),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Radio(
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => ColorAssets.fontDarkGrey),
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
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 21,
                        color: ColorAssets.fontDarkGrey),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Radio(
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => ColorAssets.fontDarkGrey),
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
