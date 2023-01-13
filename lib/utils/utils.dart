import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd(E)').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('a hh:mm').format(dateTime);
  }

  static String formatDatetime(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd(E) a hh:mm').format(dateTime);
  }

  static String getAge(String? birth) {
    var today = DateTime.now();
    var newBirth = DateTime.parse(birth!);
    int birthDays = today.difference(newBirth).inDays;
    int age = (birthDays / 365).floor();

    return '$age';
  }
}
