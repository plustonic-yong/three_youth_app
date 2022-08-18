import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/services/api/api.dart';
import 'package:three_youth_app/utils/enums.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<LoginStatus> loginGoogle() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    // final credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth?.accessToken,
    //   idToken: googleAuth?.idToken,
    // );

    var response =
        await Api.loginGoogleService(token: '${googleAuth?.idToken}');
    int statusCode = response!.statusCode;

    final data = json.decode(utf8.decode(response.bodyBytes));
    if (statusCode == 200) {
      sharedPreferences.setString('accessToken', data['accessToken']);
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
    required String token,
    required String name,
    required String birth,
    required String gender,
    required int height,
    required int weight,
  }) async {
    var response = await Api.signupKakaoService(
      token: token,
      name: name,
      birth: birth,
      gender: gender,
      height: height,
      weight: weight,
    );
    int statusCode = response!.statusCode;
    if (statusCode == 201) {
      return SignupStatus.success;
    }
    final data = json.decode(utf8.decode(response.bodyBytes));

    switch (data['msg']) {
      case 'EMAIL_EXISTS_KAKAO':
        return SignupStatus.duplicatedEmailKakao;
      case 'EMAIL_EXISTS_NAVER':
        return SignupStatus.duplicatedEmailNaver;
      case 'EMAIL_EXISTS_GOOGLE':
        return SignupStatus.duplicatedEmailGoogle;
      default:
        return SignupStatus.error;
    }
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
        var response = await Api.loginKakaoService(token: token.accessToken);
        int statusCode = response!.statusCode;
        if (statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          sharedPreferences.setString('accessToken', data['accessToken']);
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
        await Api.loginKakaoService(token: token.accessToken);
        debugPrint('로그인 성공 ${token.accessToken}');
        var response = await Api.loginKakaoService(token: token.accessToken);
        int statusCode = response!.statusCode;
        if (statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          sharedPreferences.setString('accessToken', data['accessToken']);
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

  Future<void> logout() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await Api.logoutService();
    sharedPreferences.remove('accessToken');
  }
}
