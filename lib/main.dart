import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/agreement_screen/agreement_screen.dart';
import 'package:three_youth_app/agreement_screen/safecontent_screen.dart';
import 'package:three_youth_app/ble_bp_connect_screen/ble_bp_connect_screen.dart';
import 'package:three_youth_app/ble_ecg_connect_screen/ble_ecg_connect_screen.dart';
import 'package:three_youth_app/electrocardiogram_setting_screen/electrocardiogram_setting_screen.dart';
import 'package:three_youth_app/main_screen/main_screen.dart';
import 'package:three_youth_app/profile_setting_screen/profile_setting_screen.dart';
import 'package:three_youth_app/signup_screen/signup_screen.dart';
import 'package:three_youth_app/sphygmomanometer_setting_screen/sphygmomanometer_setting_screen.dart';
import 'package:three_youth_app/utils/current_user.dart';

import 'history_screen/history_screen.dart';
import 'login_screen/findpwd_screen.dart';
import 'login_screen/login_screen.dart';

late final SharedPreferences prefsmain;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefsmain = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CurrentUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '위드케어',
        //initialRoute: _auth.currentUser != null ? '/overview' : '/login',
        initialRoute: prefsmain.getBool('isLogin') ?? false ? '/main' : '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainScreen(),
          '/connect': (context) => const BleBPConnectScreen(),
          '/connectecg': (context) => const BleECGConnectScreen(),
          '/history': (context) => const HistoryScreen(),
          '/agreement': (context) => const AgreementScreen(),
          '/profile': (context) => const ProfileSettingScreen(),
          '/safecontent': (context) => const SafeContentScreen(),
          '/electrocardiogram': (context) => const ElectrocardiogramSettingScreen(),
          '/sphygmomanometer': (context) => const SphygmomanometerSettingScreen(),
          '/signup': (context) => const SignupScreen(),
          '/findpwd': (context) => const FindPwd(),
        },
        theme: ThemeData(fontFamily: 'NotoSansCJKkr'),
      ),
    );
  }
}
