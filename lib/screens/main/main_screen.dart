import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/providers/user_provider.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/screens/history/history_screen.dart';
import 'package:three_youth_app/screens/main/main_select_screen.dart';
import 'package:three_youth_app/screens/profile_setting/profile_setting_screen.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:provider/provider.dart';

import '../../providers/ble_ecg_provider.dart';

class MainScreen extends StatefulWidget {
  final int currentIndex;

  const MainScreen({
    Key? key,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoading = true;
  // ignore: unused_field
  late final double _screenHeight;
  // ignore: unused_field
  late final double _screenWidth;
  int _currentIndex = 0;
  //bool isFairing = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('isLogin') == false) {
        await prefs.setBool('isLogin', false);
      }
      if (prefs.containsKey('id') == false) {
        await prefs.setString('id', '');
      }
      if (prefs.containsKey('ecgpincode') == false) {
        await prefs.setString('ecgpincode', '');
      }
      var ecgpincode = prefs.getString('ecgpincode');

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await context.read<BleBpProvider>().findIsPaired();
        await context.read<BleEcgProvider>().findIsPaired();
        await context.read<UserProvider>().getUserInfo();
        await context.read<BleBpProvider>().getLastBloodPressure();
        await context.read<BleEcgProvider>().getLastEcg();
        setState(() => isLoading = false);
      });

      setState(() {
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/bg.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            selectedItemColor: Colors.blueGrey,
            unselectedItemColor: Colors.grey,
            backgroundColor: ColorAssets.white,
            onTap: (index) => {
              setState(() {
                _currentIndex = index;
              })
            },
            currentIndex: _currentIndex,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 27.0,
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: ColorAssets.greenGradient1,
                  size: 27.0,
                ),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/ic_pie_chart.png',
                  width: 27.0,
                ),
                activeIcon: Image.asset(
                  'assets/icons/ic_pie_chart.png',
                  color: ColorAssets.greenGradient1,
                  width: 27.0,
                ),
                label: '기록',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/ic_profile.png',
                  width: 20.0,
                ),
                activeIcon: Image.asset(
                  'assets/icons/ic_profile.png',
                  color: ColorAssets.greenGradient1,
                  width: 20.0,
                ),
                label: '내 정보',
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(child: isLoading ? spinkit : getContent()),
      ),
    );
  }

  Widget getContent() {
    if (_currentIndex == 0) {
      return const Center(
        child: MainSelectScreen(),
      );
    } else if (_currentIndex == 1) {
      return const Center(
        child: HistoryScreen(),
      );
    } else if (_currentIndex == 2) {
      return const Center(
        child: ProfileSettingScreen(),
      );
    } else {
      return Container();
    }
  }
}
