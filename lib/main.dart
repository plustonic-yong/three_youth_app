import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/firebase_options.dart';
import 'package:three_youth_app/providers/auth_provider.dart';
import 'package:three_youth_app/screens/agreement/agreement_screen.dart';
import 'package:three_youth_app/screens/agreement/safecontent_screen.dart';
import 'package:three_youth_app/screens/ble_bp_connect/ble_bp_connect_screen.dart';
import 'package:three_youth_app/screens/ble_ecg_connect/ble_ecg_connect_screen.dart';
import 'package:three_youth_app/screens/electrocardiogram_setting/electrocardiogram_setting_screen.dart';
import 'package:three_youth_app/screens/history/history_screen.dart';
import 'package:three_youth_app/screens/login/findpwd_screen.dart';
import 'package:three_youth_app/screens/login/login_screen.dart';
import 'package:three_youth_app/screens/main/main_screen.dart';
import 'package:three_youth_app/screens/profile_setting/profile_setting_screen.dart';
import 'package:three_youth_app/screens/signup/signup_screen.dart';
import 'package:three_youth_app/screens/sphygmomanometer_setting/sphygmomanometer_setting_screen.dart';
import 'package:three_youth_app/utils/current_user.dart';

late final SharedPreferences prefsmain;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefsmain = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider.value(value: CurrentUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '위드케어',
        //initialRoute: _auth.currentUser != null ? '/overview' : '/login',
        initialRoute:
            prefsmain.getBool('isLogin') ?? false ? '/main' : '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainScreen(),
          '/connect': (context) => const BleBPConnectScreen(),
          '/connectecg': (context) => const BleECGConnectScreen(),
          '/history': (context) => const HistoryScreen(),
          '/agreement': (context) => const AgreementScreen(),
          '/profile': (context) => const ProfileSettingScreen(),
          '/safecontent': (context) => const SafeContentScreen(),
          '/electrocardiogram': (context) =>
              const ElectrocardiogramSettingScreen(),
          '/sphygmomanometer': (context) =>
              const SphygmomanometerSettingScreen(),
          '/signup': (context) => const SignupScreen(),
          '/findpwd': (context) => const FindPwd(),
        },
        theme: ThemeData(fontFamily: 'NotoSansCJKkr'),
      ),
    );
  }
}
