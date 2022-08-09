import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/firebase_options.dart';
import 'package:three_youth_app/providers/auth_provider.dart';
import 'package:three_youth_app/providers/signup_agreement_provider.dart';
import 'package:three_youth_app/providers/signup_provider.dart';
import 'package:three_youth_app/screens/agreement/agreement_screen.dart';
import 'package:three_youth_app/screens/agreement/safecontent_screen.dart';
import 'package:three_youth_app/screens/ble_bp_connect/ble_bp_connect_screen.dart';
import 'package:three_youth_app/screens/ble_bp_connect/ble_bp_scan_screen.dart';
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
  KakaoSdk.init(nativeAppKey: 'e36a07410b2e00cd113dbf6a2102876a');

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
        ChangeNotifierProvider(create: (context) => SignupAgreementProvider()),
        ChangeNotifierProvider(create: (context) => SignupProvider()),
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
          '/scan': (context) => const BleBpScanScreen(),
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
