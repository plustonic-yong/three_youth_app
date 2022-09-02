import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:three_youth_app/services/api/api_auth.dart';
import 'package:three_youth_app/utils/enums.dart';

import 'package:crypto/crypto.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? _lastLoginMethod = '';
  String? get lastLoginMethod => _lastLoginMethod;

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  //apple login
  Future<void> loginApple() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    debugPrint('hello apple');
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    debugPrint('idToken: ${appleCredential.identityToken}');
    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Future<SignupStatus> signupGoogle({
    required String name,
    required DateTime birth,
    required GenderState gender,
    required String height,
    required String weight,
    required String img,
  }) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? idToken = sharedPreferences.getString('idToken');
    String genderStr = gender == GenderState.man ? "W" : "W";
    var response = await ApiAuth.signupGoogleService(
      token: idToken!,
      name: name,
      birth: birth.toString(),
      gender: genderStr,
      height: double.parse(height),
      weight: double.parse(weight),
      img: img,
    );
    if (response!.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      int status = data['status'];
      if (status == -1) {
        return SignupStatus.error;
      }
      String accessToken = data['accessToken'] ?? '';
      String refreshToken = data['refreshToken'] ?? '';
      sharedPreferences.setString('accessToken', accessToken);
      sharedPreferences.setString('refreshToken', refreshToken);
      return SignupStatus.success;
    }
    return SignupStatus.error;
  }

  Future<LoginStatus> loginGoogle() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential

    var response =
        await ApiAuth.loginGoogleService(token: '${googleAuth?.idToken}');
    int statusCode = response!.statusCode;
    if (statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      int status = data['status'];

      //sns인증 성공했지만 회원가입 되어있지 않을 시
      if (status == 2) {
        return LoginStatus.noAccount;
      }
      String accessToken = data['accessToken'] ?? '';
      String refreshToken = data['refreshToken'] ?? '';
      if (accessToken == '') {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        sharedPreferences.setString('idToken', '${googleAuth?.idToken}');
        return LoginStatus.noAccount;
      }
      sharedPreferences.setString('accessToken', accessToken);
      sharedPreferences.setString('refreshToken', refreshToken);
      sharedPreferences.setString('lastLoginMethod', 'google');
      return LoginStatus.success;
    } else if (statusCode == 404) {
      return LoginStatus.noAccount;
    } else {
      return LoginStatus.failed;
    }
  }

  //kakao signup
  Future<SignupStatus> signupKakao({
    required String name,
    required DateTime birth,
    required GenderState gender,
    required String height,
    required String weight,
    required String img,
  }) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? kakaoAccessToken = sharedPreferences.getString('kakaoAccessToken');
    String genderStr = gender == GenderState.man ? "W" : "W";
    var response = await ApiAuth.signupKakaoService(
      token: kakaoAccessToken!,
      name: name,
      birth: birth.toString(),
      gender: genderStr,
      height: double.parse(height),
      weight: double.parse(weight),
      img: img,
    );
    int statusCode = response!.statusCode;

    if (response.statusCode == 200 || statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      int status = data['status'];
      if (status == -1) {
        return SignupStatus.error;
      }
      String accessToken = data['accessToken'] ?? '';
      String refreshToken = data['refreshToken'] ?? '';
      sharedPreferences.setString('accessToken', accessToken);
      sharedPreferences.setString('refreshToken', refreshToken);
      return SignupStatus.success;
    }
    return SignupStatus.error;
    // switch (data['msg']) {
    //   case 'EMAIL_EXISTS_KAKAO':
    //     return SignupStatus.duplicatedEmailKakao;
    //   case 'EMAIL_EXISTS_NAVER':
    //     return SignupStatus.duplicatedEmailNaver;
    //   case 'EMAIL_EXISTS_GOOGLE':
    //     return SignupStatus.duplicatedEmailGoogle;
    //   default:
    //     return SignupStatus.error;
    // }
  }

  //kakao login
  Future<LoginStatus> loginKakao() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        debugPrint('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          debugPrint('토큰 만료 $error');
        } else {
          debugPrint('토큰 정보 조회 실패 $error');
        }
      }
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        var response =
            await ApiAuth.loginKakaoService(token: token.accessToken);

        int statusCode = response!.statusCode;
        if (statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          int status = data['status'];

          //sns인증 성공했지만 회원가입 되어있지 않을 시
          if (status == 2) {
            sharedPreferences.setString('kakaoAccessToken', token.accessToken);
            return LoginStatus.noAccount;
          }
          String accessToken = data['accessToken'];
          String refreshToken = data['refreshToken'];
          sharedPreferences.setString('accessToken', accessToken);
          sharedPreferences.setString('refreshToken', refreshToken);
          sharedPreferences.setString('lastLoginMethod', 'kakao');
          return LoginStatus.success;
        } else if (statusCode == 404) {
          return LoginStatus.noAccount;
        } else {
          return LoginStatus.failed;
        }
      } catch (e) {
        debugPrint('카카오계정으로 로그인 실패 $e');
        return LoginStatus.failed;
      }
    } else {
      debugPrint('발급된 토큰 없음');
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        debugPrint('로그인 성공 ${token.accessToken}');
        var response =
            await ApiAuth.loginKakaoService(token: token.accessToken);
        debugPrint('res: ${response!.body}');
        int statusCode = response.statusCode;
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          int status = data['status'];

          //sns인증 성공했지만 회원가입 되어있지 않을 시
          if (status == 2) {
            return LoginStatus.noAccount;
          }
          sharedPreferences.setString('accessToken', data['accessToken']);
          sharedPreferences.setString('refreshToken', data['refreshToken']);
          sharedPreferences.setString('lastLoginMethod', 'kakao');
          return LoginStatus.success;
        } else if (statusCode == 404) {
          return LoginStatus.noAccount;
        } else {
          return LoginStatus.failed;
        }
      } catch (error) {
        debugPrint('로그인 실패 $error');
        return LoginStatus.failed;
      }
    }
  }

  //naver signup
  Future<SignupStatus> signupNaver({
    required String name,
    required DateTime birth,
    required GenderState gender,
    required String height,
    required String weight,
    required String img,
  }) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? naverAccessToken = sharedPreferences.getString('naverAccessToken');
    String genderStr = gender == GenderState.man ? "W" : "W";

    var response = await ApiAuth.signupNaverService(
      token: naverAccessToken!,
      name: name,
      birth: birth.toString(),
      gender: genderStr,
      height: double.parse(height),
      weight: double.parse(weight),
      img: img,
    );
    if (response!.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      int status = data['status'];
      if (status == -1) {
        return SignupStatus.error;
      }
      String accessToken = data['accessToken'] ?? '';
      String refreshToken = data['refreshToken'] ?? '';
      sharedPreferences.setString('accessToken', accessToken);
      sharedPreferences.setString('refreshToken', refreshToken);
      return SignupStatus.success;
    }
    return SignupStatus.error;
  }

  //naver login
  Future<LoginStatus> loginNaver() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    final NaverLoginResult naverLoginResult = await FlutterNaverLogin.logIn();
    NaverAccessToken naverTokens = await FlutterNaverLogin.currentAccessToken;
    var response =
        await ApiAuth.loginNaverService(token: naverTokens.accessToken);

    int statusCode = response!.statusCode;
    if (statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      int status = data['status'];

      //sns인증 성공했지만 회원가입 되어있지 않을 시
      if (status == 2) {
        sharedPreferences.setString(
            'naverAccessToken', naverTokens.accessToken);
        return LoginStatus.noAccount;
      }
      String accessToken = data['accessToken'];
      String refreshToken = data['refreshToken'];
      sharedPreferences.setString('naverAccessToken', accessToken);
      sharedPreferences.setString('refreshToken', refreshToken);
      sharedPreferences.setString('lastLoginMethod', 'naver');
      return LoginStatus.success;
    } else if (statusCode == 404) {
      return LoginStatus.noAccount;
    } else {
      return LoginStatus.failed;
    }
  }

  Future<void> logout() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // await Api.logoutService();
    GoogleSignIn _googleSignIn = GoogleSignIn();
    var lastLoginMethod = sharedPreferences.getString('lastLoginMethod');
    if (lastLoginMethod == 'google') {
      FirebaseAuth.instance.signOut();
      _googleSignIn.disconnect();
    } else if (lastLoginMethod == 'kakao') {
      try {
        await UserApi.instance.unlink();
        print('로그아웃 성공, SDK에서 토큰 삭제');
      } catch (error) {
        print('로그아웃 실패 $error');
      }
    } else if (lastLoginMethod == 'naver') {
      try {
        await FlutterNaverLogin.logOut();
      } catch (e) {
        print(e);
      }
    }
    sharedPreferences.remove('accessToken');
    sharedPreferences.remove('refreshToken');
  }

  Future<void> getLastLoginMethod() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? method = sharedPreferences.getString('lastLoginMethod');
    _lastLoginMethod = method;
    notifyListeners();
  }
}
