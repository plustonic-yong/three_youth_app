import 'package:intl/intl.dart';

class Utils {
  static String formatDatetime(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd(E) ahh:mm').format(dateTime);
  }

  static String getAge(String? birth) {
    var today = DateTime.now();
    var newBirth = DateTime.parse(birth!);
    int birthDays = today.difference(newBirth).inDays;
    int age = (birthDays / 365).floor();

    return '$age';
  }
}
