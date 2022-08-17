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
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    var response =
        await Api.loginGoogleService(token: '${googleAuth?.idToken}');
    var statusCode = response!.statusCode;

    final data = json.decode(utf8.decode(response.bodyBytes));
    if (statusCode == 200) {
      sharedPreferences.setString('accessToken', data['accessToken']);
      return LoginStatus.success;
    } else if (statusCode == 404) {
      return LoginStatus.noAccount;
    } else {
      return LoginStatus.failed;
    }
  }

  //kakao login
  Future<void> signinWithKakao({
    BuildContext? context,
  }) async {
    var sharedPreferencesInstance = await SharedPreferences.getInstance();
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
      }
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        await Api.loginKakaoService(token: token.accessToken);
        sharedPreferencesInstance.setString('accessToken', token.accessToken);
      } catch (e) {
        print('카카오계정으로 로그인 실패 $e');
      }
    } else {
      print('발급된 토큰 없음');
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        await Api.loginKakaoService(token: token.accessToken);
        print('로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('로그인 실패 $error');
      }
    }
  }

  // Future<void> logout() async {
  //   try {
  //     Client client = InterceptedClient.build(interceptors: [
  //       AuthInterceptor(),
  //     ]);
  //     await client.post(
  //       Uri.parse('${Constants.API_HOST}/logout'),
  //       headers: _getHeader(),
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
