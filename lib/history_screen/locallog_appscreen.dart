import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/base/base_app_bar.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/history_screen/history_screen.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/current_user.dart';

import 'locallog_screen.dart';

class LocalLogAppScreen extends StatefulWidget {
  const LocalLogAppScreen({Key? key}) : super(key: key);

  @override
  _LocalLogAppScreenState createState() => _LocalLogAppScreenState();
}

class _LocalLogAppScreenState extends State<LocalLogAppScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  int _currentIndex = 0;
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
              :
            const Center(child: LocalLogScreen()),
        ),
      ),
    );
  }

}
