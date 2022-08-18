import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/screens/base/spinkit.dart';
import 'package:three_youth_app/screens/history/history_screen.dart';
import 'package:three_youth_app/screens/main/main_select_screen.dart';
import 'package:three_youth_app/screens/main/main_setting_screen.dart';
import 'package:three_youth_app/utils/color.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

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
      print('ecgpincode: $ecgpincode');

      // var isSphyFairing = prefs.getBool('isSphyFairing') ?? false;
      // var isErFairing = prefs.getBool('isErFairing') ?? false;
      setState(() {
        //isFairing = isSphyFairing || isErFairing;
        //Provider.of<CurrentUser>(context, listen: false).isFairing = isFairing;
        _screenWidth = MediaQuery.of(context).size.width;
        _screenHeight = MediaQuery.of(context).size.height;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //isFairing = Provider.of<CurrentUser>(context, listen: true).isFairing;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/bg.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: _currentIndex == 0 ? null : const BaseAppBar(),
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
                  size: 27,
                ),
                activeIcon: Icon(
                  Icons.home,
                  color: ColorAssets.greenGradient1,
                  size: 27,
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
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  size: 27,
                ),
                activeIcon: Icon(
                  Icons.settings,
                  color: ColorAssets.greenGradient1,
                  size: 27,
                ),
                label: '설정',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(
              //     Icons.list,
              //     size: 27,
              //   ),
              //   activeIcon: Icon(
              //     Icons.list,
              //     color: ColorAssets.greenGradient1,
              //     size: 27,
              //   ),
              //   label: '히스토리',
              // ),

              // BottomNavigationBarItem(
              //   icon: Icon(
              //     Icons.bar_chart,
              //     size: 27,
              //   ),
              //   activeIcon: Icon(
              //     Icons.bar_chart,
              //     color: ColorAssets.greenGradient1,
              //     size: 27,
              //   ),
              //   label: '데이터',
              // ),
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
      return const Center(child: MainSettingScreen());
    } else {
      return Container();
      // } else if (_currentIndex == 1) {
      //   return const Center(child: HistoryScreen());
      // } else if (_currentIndex == 2) {
      //   return const Center(child: MainGraphScreen());
      // } else if (_currentIndex == 3) {
      //   return const Center(child: MainSettingScreen());
      // } else {
      //   return Container();
    }
  }
}
