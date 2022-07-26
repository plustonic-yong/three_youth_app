import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/base/base_app_bar.dart';
import 'package:three_youth_app/base/spinkit.dart';
import 'package:three_youth_app/history_screen/history_screen.dart';
import 'package:three_youth_app/main_screen/main_graph_screen.dart';
import 'package:three_youth_app/main_screen/main_select_screen.dart';
import 'package:three_youth_app/main_screen/main_setting_screen.dart';
import 'package:three_youth_app/utils/color.dart';
import 'package:three_youth_app/utils/current_user.dart';

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

      if(prefs.containsKey('isLogin') == false) {
        await prefs.setBool('isLogin', false);
      }
      if(prefs.containsKey('id') == false) {
        await prefs.setString('id', '');
      }
      if(prefs.containsKey('ecgpincode') == false) {
        await prefs.setString('ecgpincode', '');
      }


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
      color: Colors.white,
      child: Scaffold(
        backgroundColor: ColorAssets.commonBackgroundDark,
        appBar: const BaseAppBar(),
        //drawer: ,
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blueGrey,
            unselectedItemColor: Colors.grey,
            backgroundColor: ColorAssets.white,
            onTap: (index) => {
                  setState(() {
                    _currentIndex = index;
                  })
                },
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 27,
                ),
                activeIcon: Icon (
                  Icons.home,
                  color: ColorAssets.greenGradient1,
                  size: 27,
                ),
                label: '홈',
              ),

              BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                  size: 27,
                ),
                activeIcon: Icon (
                  Icons.list,
                  color: ColorAssets.greenGradient1,
                  size: 27,
                ),
                label: '히스토리',
              ),

              BottomNavigationBarItem(
                icon: Icon(
                  Icons.bar_chart,
                  size: 27,
                ),
                activeIcon: Icon (
                  Icons.bar_chart,
                  color: ColorAssets.greenGradient1,
                  size: 27,
                ),
                label: '데이터',
              ),

              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  size: 27,
                ),
                activeIcon: Icon (
                  Icons.settings,
                  color: ColorAssets.greenGradient1,
                  size: 27,
                ),
                label: '설정',
              )
            ]),
        body: SingleChildScrollView(
          child: isLoading
              ? spinkit
              : getContent()
        ),
      ),
    );
  }

  Widget getContent()
  {
    if(_currentIndex == 0) {
      return const Center(
        child: MainSelectScreen(),
      );
    }
    else if(_currentIndex == 1) {
      return const Center(child: HistoryScreen());
    }
    else if(_currentIndex == 2) {
      return const Center(child: MainGraphScreen());
    }
    else if(_currentIndex == 3) {
      return const Center(child: MainSettingScreen());
    }
    else
      {
        return Container();
      }
  }
}
