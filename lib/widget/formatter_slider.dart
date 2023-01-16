import 'package:flutter/services.dart';

class CustomInputFormatterSlider extends TextInputFormatter {
  double max;
  CustomInputFormatterSlider(this.max);
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    int? value = int.tryParse(newValue.text);

    if (value != null) {
      if (value <= max.toInt()) {
        return newValue;
      }
    }

    return oldValue;
  }
}
