class BpModel {
  final DateTime measureDatetime;
  final int sys;
  final int dia;
  final int pul;
  final String regDatetime;
  BpModel({
    required this.measureDatetime,
    required this.sys,
    required this.dia,
    required this.pul,
    required this.regDatetime,
  });

  factory BpModel.fromJson(Map<String, dynamic> json) => BpModel(
        measureDatetime: DateTime.parse(json['measureDatetime']),
        sys: json['sys'],
        dia: json['dia'],
        pul: json['pul'],
        regDatetime: json['regDatetime'],
      );
}
