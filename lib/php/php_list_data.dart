class Data {
  String s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30;

  Data(
    this.s1,
    this.s2,
    this.s3,
    this.s4,
    this.s5,
    this.s6,
    this.s7,
    this.s8,
    this.s9,
    this.s10,
    this.s11,
    this.s12,
    this.s13,
    this.s14,
    this.s15,
    this.s16,
    this.s17,
    this.s18,
    this.s19,
    this.s20,
    this.s21,
    this.s22,
    this.s23,
    this.s24,
    this.s25,
    this.s26,
    this.s27,
    this.s28,
    this.s29,
    this.s30,
  );

  factory Data.fromJson(dynamic json) {
    return Data(
        json['1'] as String,
        json['2'] as String,
        json['3'] as String,
        json['4'] as String,
        json['5'] as String,
        json['6'] as String,
        json['7'] as String,
        json['8'] as String,
        json['9'] as String,
        json['10'] as String,
        json['11'] as String,
        json['12'] as String,
        json['13'] as String,
        json['14'] as String,
        json['15'] as String,
        json['16'] as String,
        json['17'] as String,
        json['18'] as String,
        json['19'] as String,
        json['20'] as String,
        json['21'] as String,
        json['22'] as String,
        json['23'] as String,
        json['24'] as String,
        json['25'] as String,
        json['26'] as String,
        json['27'] as String,
        json['28'] as String,
        json['29'] as String,
        json['30'] as String);
  }
  @override
  String toString() {
    return '{$s1, $s2, $s3, $s4, $s5, $s6, $s7, $s8}';
  }
}
