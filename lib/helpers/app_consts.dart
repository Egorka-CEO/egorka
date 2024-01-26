import 'package:flutter/material.dart';

abstract class AppConsts {
  static const server = 'https://app.egorka.dev'; // migrate to .env
  static const apiKey = 'AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ'; // migrate to .env
  static const backgroundColor = Colors.white;
  static const helperTextColor = Color.fromRGBO(55, 55, 55, 1);
  static const textScalerStd = TextScaler.linear(1.0);
}