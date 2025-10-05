import 'package:intl/intl.dart';

mixin DateFormatMixin {
  String getTime(DateTime? date) {
    String time = 'No time';
    if (date != null) {
      final local = date.toLocal();
      time = DateFormat('HH:mm').format(local);
    }
    return time;
  }

  String getDateFromDateTime(DateTime? dateTime) {
    String date = 'No date';
    if (dateTime != null) {
      final formatter = DateFormat('dd.MM.yyyy');
      date = formatter.format(dateTime);
    }
    return date;
  }

  String getDateFromString(String? dateString) {
    String date = 'No date';
    if (dateString == null) {
      return date;
    } else {
      final dateTime = (DateTime.parse(dateString));
      final formatter = DateFormat('dd.MM.yyyy');
      date = formatter.format(dateTime);
      return date;
    }
  }

  String getDateOrTime(DateTime? date) {
    String dateOrTime = 'No date';
    final now = DateTime.now();
    if (date != null) {
      if (date.day == now.day && date.month == now.month && date.year == now.year) {
        dateOrTime = getTime(date);
      } else {
        dateOrTime = getDateFromDateTime(date);
      }
    }
    return dateOrTime;
  }
}
