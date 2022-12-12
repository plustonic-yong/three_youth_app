import 'dart:convert';

import 'package:flutter/material.dart';

class EcgModel {
  final DateTime measureDatetime;
  final List<int> lDataECG;
  final int bpm;
  final String regDatetime;
  final int duration;

  EcgModel({
    required this.measureDatetime,
    required this.lDataECG,
    required this.regDatetime,
    required this.bpm,
    required this.duration,
  });

  factory EcgModel.fromJson(Map<String, dynamic> map) => EcgModel(
        measureDatetime: DateTime.parse(map['measureDatetime']),
        lDataECG: List<int>.from(map['ecg'].map((x) => x as int)),
        regDatetime: map['regDatetime'],
        bpm: map['bpm'],
        duration: map['duration'],
      );
}
