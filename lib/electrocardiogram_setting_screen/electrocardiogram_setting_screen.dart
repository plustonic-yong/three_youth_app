import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/base/navigate_app_bar.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/custom/common_button.dart';
import 'package:three_youth_app/main.dart';
import 'package:three_youth_app/utils/color.dart';

class ElectrocardiogramSettingScreen extends StatefulWidget {
  const ElectrocardiogramSettingScreen({Key? key}) : super(key: key);

  @override
  _ElectrocardiogramSettingScreenState createState() => _ElectrocardiogramSettingScreenState();
}

class _ElectrocardiogramSettingScreenState extends State<ElectrocardiogramSettingScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;

  late SharedPreferences prefs;
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormFieldState> _nameFormKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;

        isLoading = false;
      });


        prefs = await SharedPreferences.getInstance();

      String id = prefs.getString('ecgpincode') ?? '';
      _nameController.text = id;
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '심전도 설정',
                      style: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
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
                          labelText: 'ECG PINCODE',
                          labelStyle: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 16, fontWeight: FontWeight.bold),
                          hintText: 'ECG 기기의 설정에서 PINCODE를 확인하세요.',
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

                    SizedBox(
                      height: 20,
                    ),

                    CommonButton(
                        screenWidth: _screenWidth * 0.6,
                        txt: '저장',
                        onPressed: () async {

                         await prefs.setString('ecgpincode', _nameController.text);
                        }),
                  ],
                ),
              ),
      ),
    );
  }
}
