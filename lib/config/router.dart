import 'package:egorka/home/home.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const home = '/';

  static Route<dynamic>? onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return null;
    }
  }
}
