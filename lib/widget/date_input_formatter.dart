import 'package:flutter/services.dart';

class DateCustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    if (text.length == 4) {
      return oldValue.copyWith(
        text: '$text-',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    } else if (text.length == 7) {
      return oldValue.copyWith(
        text: '$text-',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }
    if (text.length > 10) {
      return oldValue;
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
