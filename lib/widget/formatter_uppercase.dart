import 'package:flutter/services.dart';

class CustomInputFormatterUpperCase extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > oldValue.text.length) {
      List<String> word = newValue.text.split(' ');
      String str = '';
      for (int i = 0; i < word.length; i++) {
        String temp = '';
        for (int j = 0; j < word[i].length; j++) {
          if (j == 0)
            temp = word[i][j].toUpperCase();
          else
            temp += word[i][j];
        }
        word[i] = temp;
      }

      for (int i = 0; i < word.length; i++) {
        if (i == word.length - 1)
          str += word[i];
        else
          str += '${word[i]} ';
      }
      return newValue.copyWith(
        text: str,
        selection: TextSelection.collapsed(offset: str.length),
      );
    }
    return newValue;
  }
}
