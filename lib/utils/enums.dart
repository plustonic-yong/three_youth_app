library enums;

enum ButtonColor {
  primary,
  white,
  orange,
  inactive,
  warning,
}

enum GenderState {
  woman,
  man,
}

enum LoginStatus {
  success,
  failed,
  noAccount,
}

enum SignupStatus {
  success,
  duplicatedEmailApple,
  duplicatedEmailKakao,
  duplicatedEmailNaver,
  duplicatedEmailGoogle,
  error,
}

enum EcgScanStatus {
  waiting,
  scanning,
  complete,
  failed,
}

enum HistoryType {
  ecg,
  bp,
}

enum HistoryCalendarType {
  week,
  month,
}
