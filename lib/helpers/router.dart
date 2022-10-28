import 'package:egorka/ui/auth/main_aut.dart';
import 'package:egorka/ui/home/home.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/ui/sidebar/about/about_page.dart';
import 'package:egorka/ui/sidebar/current_order/current_order_page.dart';
import 'package:egorka/ui/sidebar/market_place/market_page.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const home = '/';
  static const currentOrder = '/currentOrder';
  static const marketplaces = '/marketplaces';
  static const about = '/about';
  static const auth = '/auth';
  static const newOrder = '/newOrder';

  static Route<dynamic>? onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case currentOrder:
        return MaterialPageRoute(builder: (_) => const CurrentOrderPage());
      case marketplaces:
        return MaterialPageRoute(builder: (_) => MarketPage());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case auth:
        return MaterialPageRoute(builder: (_) => const MainAuthPage());
      case newOrder:
        return MaterialPageRoute(builder: (_) => const NewOrderPage());
      default:
        return null;
    }
  }
}
