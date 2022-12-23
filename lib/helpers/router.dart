import 'package:egorka/model/address.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/history.dart';
import 'package:egorka/model/marketplaces.dart' as mrkt;
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/ui/auth/main_aut.dart';
import 'package:egorka/ui/home/home.dart';
import 'package:egorka/ui/newOrder/details_page.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/ui/sidebar/about/about_page.dart';
import 'package:egorka/ui/sidebar/book/book_page.dart';
import 'package:egorka/ui/sidebar/current_order/current_order_page.dart';
import 'package:egorka/ui/sidebar/deposit/add_deposit.dart';
import 'package:egorka/ui/sidebar/deposit/traffic_deposit.dart';
import 'package:egorka/ui/sidebar/history_orders/details_page.dart';
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
  static const trafficDeposit = '/trafficDeposit';
  static const addDeposit = '/addDeposit';
  static const detailsOrder = '/detailsOrder';
  static const historyDetailsOrder = '/historyDetailsOrder';
  static const book = '/book';

  static Route<dynamic>? onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case currentOrder:
        final list = route.arguments as CreateFormModel;
        return MaterialPageRoute(builder: (_) => CurrentOrderPage(coast: list));
      case marketplaces:
        var history;
        if (route.arguments != null) {
          final list = route.arguments as List<HistoryModel>;
          history = list[0];
        }
        return MaterialPageRoute(
            builder: (_) => MarketPage(historyModel: history));
      case about:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case auth:
        return MaterialPageRoute(builder: (_) => const MainAuthPage());
      case newOrder:
        var order;
        var delivery;
        var start;
        var end;
        if (route.arguments != null) {
          final arg = route.arguments as List;
          final list = arg[0] as CoastResponse;
          final listChoice = arg[1] as DeliveryChocie;
          final startPoint = arg[2] as Suggestions;
          final endPoint = arg[3] as Suggestions;
          order = list;
          delivery = listChoice;
          start = startPoint;
          end = endPoint;
        }
        return MaterialPageRoute(
            builder: (_) => NewOrderPage(
                  order: order,
                  deliveryChocie: delivery,
                  start: start,
                  end: end,
                ));
      case historyOrder:
        final list = route.arguments as CreateFormModel;
        return MaterialPageRoute(
            builder: (_) => HistoryOrdersPage(coast: list));
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case marketplacesMap:
        final value = route.arguments as mrkt.MarketPlaces;
        return MaterialPageRoute(builder: (_) => MarketPlacesMap(value));
      case trafficDeposit:
        return MaterialPageRoute(builder: (_) => TrafficDeposit());
      case addDeposit:
        return MaterialPageRoute(builder: (_) => AddDeposit());
      case detailsOrder:
        final list = route.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (_) => DetailsPage(
                typeAdd: list[0], index: list[1], routeOrder: list[2]));
      case historyDetailsOrder:
        final list = route.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (_) => HistoryDetailsPage(
                  typeAdd: list[0],
                  index: list[1],
                  locations: list[2],
                ));
      case book:
        return MaterialPageRoute(builder: (_) => BookPage());
      default:
        return null;
    }
  }
}
