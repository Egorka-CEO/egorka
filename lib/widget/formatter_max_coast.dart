import 'package:flutter/services.dart';

class CustomInputFormatterMaxCoast extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > oldValue.text.length) {
      int str = int.parse(newValue.text);
      if (str <= 100000) {
        return newValue;
      } else {
        return oldValue;
      }
    }
    return newValue;
  }
}
