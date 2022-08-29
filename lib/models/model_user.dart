class ModelUser {
  final String name;
  final String birth;
  final String gender;
  final int height;
  final int weight;
  final String imgUrl;
  final String code;

  ModelUser({
    required this.name,
    required this.birth,
    required this.gender,
    required this.height,
    required this.weight,
    required this.imgUrl,
    required this.code,
  });

  factory ModelUser.fromJson(Map<String, dynamic> json) => ModelUser(
        name: json['name'],
        birth: json['birth'],
        gender: json['gender'],
        height: json['height'],
        weight: json['weight'],
        imgUrl: json['imgUrl'] ?? '',
        code: json['code'],
      );
}
