import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/services/api/api.dart';

class AccountManager {
  String get accessToken {
    return _accessToken!;
  }

  set accessToken(String accessToken) {
    _accessToken = accessToken;
    SharedPreferences.getInstance().then((sharedPreferences) {
      sharedPreferences.setString("accessToken", accessToken);
    });
  }

  Future<void> logout() async {
    await Api.logoutService();
    _accessToken = null;
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("accessToken");
  }

  String? _accessToken;
}
