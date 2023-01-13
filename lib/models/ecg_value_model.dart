import 'dart:convert';

class EcgValueModel {
  DateTime measureDatetime;
  List<double> lDataECG;
  EcgValueModel({
    required this.measureDatetime,
    required this.lDataECG,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'measureDatetime': measureDatetime.millisecondsSinceEpoch,
      'lDataECG': lDataECG,
    };
  }

  factory EcgValueModel.fromMap(Map<String, dynamic> map) {
    return EcgValueModel(
      measureDatetime:
          DateTime.fromMillisecondsSinceEpoch(map['measureDatetime'] as int),
      lDataECG: List<double>.from(
        (map['lDataECG'] as List<double>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory EcgValueModel.fromJson(String source) =>
      EcgValueModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
