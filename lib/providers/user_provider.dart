import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_youth_app/models/user_model.dart';
import 'package:three_youth_app/services/api/api_auth.dart';
import 'package:three_youth_app/utils/enums.dart';

class UserProvider extends ChangeNotifier {
  String _profileImg = '';
  String get progileImg => _profileImg;
  GenderState _gender = GenderState.woman;
  GenderState get gender => _gender;
  String _name = '';
  String get name => _name;
  String _height = '';
  String get height => _height;
  String _weight = '';
  String get weight => _weight;
  String _year = '';
  String get year => _year;
  String _month = '';
  String get month => _month;
  String _day = '';
  String get day => _day;
  UserModel? _userInfo;
  UserModel? get userInfo => _userInfo;

  void onChangeHeight({required String value}) {
    _height = value;
    notifyListeners();
  }

  void onChangeWeight({required String value}) {
    _weight = value;
    notifyListeners();
  }

  Future<void> getUserInfo() async {
    var response = await ApiAuth.getUserInfoService();
    int statusCode = response!.statusCode;
    if (statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      log('user data: $data');
      UserModel userInfo = UserModel.fromJson(data);
      log('user model: $userInfo');
      _userInfo = userInfo;
      _height = _userInfo!.height.toString();
      _weight = _userInfo!.weight.toString();
      notifyListeners();
    } else if (statusCode == 401) {
      var pref = await SharedPreferences.getInstance();
      String? refreshToken = pref.getString('refreshToken');
      await ApiAuth.getTokenService(refreshToken: refreshToken!);
      final data = json.decode(utf8.decode(response.bodyBytes));
      log('user data: $data');
      UserModel userInfo = UserModel.fromJson(data);
      _userInfo = userInfo;
      notifyListeners();
    }
  }

  Future<bool> updateUser(
      {required String height, required String weight, String? img}) async {
    var response = await ApiAuth.updateUserService(
      height: int.parse(height),
      weight: int.parse(weight),
      img: img,
    );
    int stautsCode = response!.statusCode;
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      log('update? ${data}');
      int status = data['status'];
      if (status == -1) {
        return false;
      }
      return true;
    }
    return false;
  }

  Future<bool> deleteUser() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var response = await ApiAuth.deleteUserService();
    GoogleSignIn _googleSignIn = GoogleSignIn();
    if (response!.statusCode == 200) {
      var lastLoginMethod = sharedPreferences.getString('lastLoginMethod');
      if (lastLoginMethod == 'google') {
        _googleSignIn.disconnect();
        FirebaseAuth.instance.signOut();
      } else if (lastLoginMethod == 'kakao') {
        try {
          await UserApi.instance.unlink();
          print('회원탈퇴 성공, SDK에서 토큰 삭제');
        } catch (error) {
          print('회원탈퇴 실패 $error');
        }
      }
      sharedPreferences.remove('accessToken');
      sharedPreferences.remove('refreshToken');
      return true;
    }
    return false;
  }
}
