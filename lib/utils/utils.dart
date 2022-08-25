import 'package:intl/intl.dart';

class Utils {
  static String formatDatetime(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd(E) ahh:mm').format(dateTime);
  }
}
