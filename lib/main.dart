import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/firebase_options.dart';
import 'package:three_youth_app/providers/auth_provider.dart';
import 'package:three_youth_app/providers/ble_bp_provider.dart';
import 'package:three_youth_app/providers/ble_ecg_connect_provider.dart';
import 'package:three_youth_app/providers/ble_ecg_scan_provider.dart';
import 'package:three_youth_app/providers/history_provider.dart';
import 'package:three_youth_app/providers/signup_agreement_provider.dart';
import 'package:three_youth_app/providers/signup_provider.dart';
import 'package:three_youth_app/providers/user_provider.dart';
import 'package:three_youth_app/screens/agreement/agreement_screen.dart';
import 'package:three_youth_app/screens/agreement/safecontent_screen.dart';
import 'package:three_youth_app/screens/ble_bp_connect/ble_bp_connect_info_screen.dart';
import 'package:three_youth_app/screens/ble_bp_connect/ble_bp_connect_pairing_screen.dart';
import 'package:three_youth_app/screens/ble_bp_connect/ble_bp_connect_screen.dart';
import 'package:three_youth_app/screens/ble_bp_scan/ble_bp_scan_camera_screen.dart';
import 'package:three_youth_app/screens/ble_bp_scan/ble_bp_scan_measurement_screen.dart';
import 'package:three_youth_app/screens/ble_bp_scan/ble_bp_scan_screen.dart';
import 'package:three_youth_app/screens/ble_ecg_connect/ble_ecg_connect_info_screen.dart';
import 'package:three_youth_app/screens/ble_ecg_connect/ble_ecg_connect_pairing_screen.dart';
import 'package:three_youth_app/screens/ble_ecg_connect/ble_ecg_connect_screen.dart';
import 'package:three_youth_app/screens/ble_ecg_scan/ble_ecg_scan_measurement_screen.dart';
import 'package:three_youth_app/screens/ble_ecg_scan/ble_ecg_scan_screen.dart';
import 'package:three_youth_app/screens/electrocardiogram_setting/electrocardiogram_setting_screen.dart';
import 'package:three_youth_app/screens/history/history_screen.dart';
import 'package:three_youth_app/screens/login/findpwd_screen.dart';
import 'package:three_youth_app/screens/login/login_screen.dart';
import 'package:three_youth_app/screens/main/main_screen.dart';
import 'package:three_youth_app/screens/profile_setting/prev/profile_setting_screen.dart';
import 'package:three_youth_app/screens/signup/signup_screen.dart';
import 'package:three_youth_app/screens/signup_agreement/signup_agreement_screen.dart';
import 'package:three_youth_app/screens/sphygmomanometer_setting/sphygmomanometer_setting_screen.dart';
import 'package:three_youth_app/utils/current_user.dart';
import 'package:intl/date_symbol_data_local.dart';

late final SharedPreferences prefsmain;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: 'e36a07410b2e00cd113dbf6a2102876a');
  prefsmain = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting().then((_) => runApp(const MyApp()));
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
        ChangeNotifierProvider(create: (context) => BleBpProvider()),
        ChangeNotifierProvider(create: (context) => BleEcgConnectProvider()),
        ChangeNotifierProvider(create: (context) => BleEcgScanProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider.value(value: CurrentUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '위드케어',
        //initialRoute: _auth.currentUser != null ? '/overview' : '/login',
        initialRoute: prefsmain.containsKey('accessToken') ? '/main' : '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainScreen(),
          '/connect': (context) => const BleBpConnectScreen(),
          '/connect/info': (context) => const BleBpConnectInfoScreen(),
          '/connect/pairing': (context) => const BleBpConnectPairingScreen(),
          '/scan': (context) => const BleBpScanScreen(),
          '/scan/mesurement': (context) => const BleBpScanMesurementScreen(),
          '/scan/camera': (context) => const BleBpScanCameraScreen(),
          '/connectecg': (context) => const BleEcgConnectScreen(),
          '/connectecg/info': (context) => const BleEcgConnectInfoScreen(),
          '/connectecg/pairing': (context) =>
              const BleEcgConnectPairingScreen(),
          '/scanecg': (context) => const BleEcgScanScreen(),
          '/scanecg/mesurement': (context) =>
              const BleEcgScanMeasurementScreen(),
          '/history': (context) => const HistoryScreen(),
          '/agreement': (context) => const AgreementScreen(),
          '/profile': (context) => const ProfileSettingScreen(),
          '/safecontent': (context) => const SafeContentScreen(),
          '/electrocardiogram': (context) =>
              const ElectrocardiogramSettingScreen(),
          '/sphygmomanometer': (context) =>
              const SphygmomanometerSettingScreen(),
          '/signup': (context) => const SignupScreen(),
          '/signup/agreement': (context) => const SignupAgreementScreen(),
          '/findpwd': (context) => const FindPwd(),
        },
        theme: ThemeData(fontFamily: 'NotoSansCJKkr'),
      ),
    );
  }
}
