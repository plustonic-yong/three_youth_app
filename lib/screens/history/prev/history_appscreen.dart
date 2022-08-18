import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/screens/base/base_app_bar.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/screens/history/prev/history_screen.dart';
import 'package:three_youth_app/utils/color.dart';

class HistoryAppScreen extends StatefulWidget {
  const HistoryAppScreen({Key? key}) : super(key: key);

  @override
  _HistoryAppScreenState createState() => _HistoryAppScreenState();
}

class _HistoryAppScreenState extends State<HistoryAppScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  // int _currentIndex = 0;
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
          child: isLoading ? spinkit : const Center(child: HistoryScreen()),
        ),
      ),
    );
  }
}
