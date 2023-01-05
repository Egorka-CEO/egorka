import 'package:intl/intl.dart';

class DateMonth {
  String monthDate(DateTime dateTime) {
    String res = '';
    switch (dateTime.month) {
      case 1:
        res = 'января';
        break;
      case 2:
        res = 'февраля';
        break;
      case 3:
        res = 'марта';
        break;
      case 4:
        res = 'апреля';
        break;
      case 5:
        res = 'мая';
        break;
      case 6:
        res = 'июня';
        break;
      case 7:
        res = 'июля';
        break;
      case 8:
        res = 'августа';
        break;
      case 9:
        res = 'сентября';
        break;
      case 10:
        res = 'октября';
        break;
      case 11:
        res = 'ноября';
        break;
      case 12:
        res = 'декабря';
        break;
      default:
        res = DateFormat.MMMM(dateTime).toString();
    }
    return res;
  }
}
