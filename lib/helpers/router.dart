import 'package:egorka/model/marketplaces.dart' as mrkt;
import 'package:egorka/ui/auth/main_aut.dart';
import 'package:egorka/ui/home/home.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/ui/sidebar/about/about_page.dart';
import 'package:egorka/ui/sidebar/current_order/current_order_page.dart';
import 'package:egorka/ui/sidebar/history_orders/history_page.dart';
import 'package:egorka/ui/sidebar/market_place/market_page.dart';
import 'package:egorka/ui/sidebar/market_place/market_places.dart';
import 'package:egorka/ui/sidebar/profile/profile_page.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const home = '/';
  static const currentOrder = '/currentOrder';
  static const marketplaces = '/marketplaces';
  static const marketplacesMap = '/marketplacesMap';
  static const about = '/about';
  static const auth = '/auth';
  static const newOrder = '/newOrder';
  static const historyOrder = '/history';
  static const profile = '/profile';

  static Route<dynamic>? onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case currentOrder:
        return MaterialPageRoute(builder: (_) => const CurrentOrderPage());
      case marketplaces:
        return MaterialPageRoute(builder: (_) => const MarketPage());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case auth:
        return MaterialPageRoute(builder: (_) => const MainAuthPage());
      case newOrder:
        return MaterialPageRoute(builder: (_) => const NewOrderPage());
      case historyOrder:
        return MaterialPageRoute(builder: (_) => const HistoryOrdersPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case marketplacesMap:
        final value = route.arguments as mrkt.MarketPlaces;
        return MaterialPageRoute(builder: (_) => MarketPlacesMap(value));
      default:
        return null;
    }
  }
}
