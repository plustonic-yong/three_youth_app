import 'dart:developer';

class UserModel {
  final String name;
  final String birth;
  final String gender;
  final double height;
  final double weight;
  final String imgUrl;
  final String code;

  UserModel({
    required this.name,
    required this.birth,
    required this.gender,
    required this.height,
    required this.weight,
    required this.imgUrl,
    required this.code,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] ?? '',
        birth: json['birth'] ?? '',
        gender: json['gender'] ?? 'M',
        height: double.parse(json['height']),
        weight: double.parse(json['weight']),
        imgUrl: json['imgUrl'] ?? '',
        code: json['code'] ?? '',
      );
}
