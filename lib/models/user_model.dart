class UserModel {
  final String name;
  final String birth;
  final String gender;
  final int height;
  final int weight;
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
        gender: json['gender'] ?? '',
        height: json['height'] ?? 0,
        weight: json['weight'] ?? 0,
        imgUrl: json['imgUrl'] ?? '',
        code: json['code'] ?? '',
      );
}
