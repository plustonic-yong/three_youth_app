import 'package:flutter/material.dart';
import 'package:three_youth_app/base/navigate_app_bar.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/utils/color.dart';

class SphygmomanometerSettingScreen extends StatefulWidget {
  const SphygmomanometerSettingScreen({Key? key}) : super(key: key);

  @override
  _SphygmomanometerSettingScreenState createState() => _SphygmomanometerSettingScreenState();
}

class _SphygmomanometerSettingScreenState extends State<SphygmomanometerSettingScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      setState(() {
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
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '혈압계 설정',
                      style: TextStyle(color: ColorAssets.fontDarkGrey, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
