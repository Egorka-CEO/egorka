import 'package:egorka/helpers/custom_page_route.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/marketplaces.dart' as mrkt;
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/model/type_group.dart';
import 'package:egorka/ui/auth/main_aut.dart';
import 'package:egorka/ui/auth/main_auth.dart';
import 'package:egorka/ui/auth/main_registration.dart';
import 'package:egorka/ui/home/home.dart';
import 'package:egorka/ui/newOrder/details_page.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/ui/newOrder/repeat_order.dart';
import 'package:egorka/ui/sidebar/about/about_page.dart';
import 'package:egorka/ui/sidebar/book/book_page.dart';
import 'package:egorka/ui/sidebar/current_order/current_order_page.dart';
import 'package:egorka/ui/sidebar/deposit/traffic_deposit.dart';
import 'package:egorka/ui/sidebar/employee/employee.dart';
import 'package:egorka/ui/sidebar/history_orders/details_page.dart';
import 'package:egorka/ui/sidebar/history_orders/history_page.dart';
import 'package:egorka/ui/sidebar/market_place/market_page.dart';
import 'package:egorka/ui/sidebar/market_place/market_places.dart';
import 'package:egorka/ui/sidebar/profile/profile_page.dart';
import 'package:egorka/widget/select_adres_map.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const home = '/';
  static const currentOrder = '/currentOrder';
  static const marketplaces = '/marketplaces';
  static const marketplacesMap = '/marketplacesMap';
  static const about = '/about';
  static const auth = '/auth';
  static const mainAuth = '/mainAuth';
  static const newOrder = '/newOrder';
  static const repeatOrder = '/repeatOrder';
  static const historyOrder = '/history';
  static const profile = '/profile';
  static const trafficDeposit = '/trafficDeposit';
  static const addDeposit = '/addDeposit';
  static const detailsOrder = '/detailsOrder';
  static const historyDetailsOrder = '/historyDetailsOrder';
  static const book = '/book';
  static const selectPoint = '/selectPoint';
  static const registration = '/registration';
  static const employee = '/employee';

  static Route<dynamic>? onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      case home:
        return createRoute(const HomePage());
      case employee:
        return createRoute(const EmployeePage());
      case currentOrder:
        final list = route.arguments as List<int?>;
        var number = list[0];
        var pin = list[1];
        return createRoute(
          CurrentOrderPage(
            recordNumber: number,
            recordPIN: pin,
          ),
        );
      case marketplaces:
        var number;
        var pin;
        var order;
        var delivery;
        var start;
        var end;
        TypeGroup? typeGroup = TypeGroup.fbo;

        if (route.arguments != null) {
          final arg = route.arguments as List;
          number = arg[0];
          pin = arg[1];

          order = arg[2] as CoastResponse?;
          delivery = arg[3] as DeliveryChocie?;
          start = arg[4] as Suggestions?;
          end = arg[5] as Suggestions?;
          typeGroup = arg[6] as TypeGroup?;
        }
        return createRoute(
          MarketPage(
            recorNumber: number,
            recordPIN: pin,
            order: order,
            deliveryChocie: delivery,
            start: start,
            end: end,
            typeGroup: typeGroup,
          ),
        );
      case about:
        return createRoute(const AboutPage());
      case auth:
        return createRoute(const MainAuthPage());
      case mainAuth:
        return createRoute(const MainAuthView());
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
          ),
        );
      case repeatOrder:
        var number;
        var pin;
        final arg = route.arguments as List;
        number = arg[0];
        pin = arg[1];
        return createRoute(
          RepeatOrderPage(
            recordNumber: number,
            recordPIN: pin,
          ),
        );
      case historyOrder:
        final list = route.arguments as CreateFormModel;
        return createRoute(HistoryOrdersPage(coast: list));
      case profile:
        return createRoute(const ProfilePage());
      case marketplacesMap:
        final value = route.arguments as mrkt.MarketPlaces;
        return createRoute(MarketPlacesMap(value));
      case trafficDeposit:
        return createRoute(const TrafficDeposit());
      case detailsOrder:
        final list = route.arguments as List<dynamic>;
        return createRoute(
          DetailsPage(
            typeAdd: list[0],
            index: list[1],
            routeOrder: list[2],
          ),
        );
      case historyDetailsOrder:
        final list = route.arguments as List<dynamic>;
        return createRoute(
          HistoryDetailsPage(
            typeAdd: list[0],
            index: list[1],
            locations: list[2],
          ),
        );
      case book:
        return createRoute(const BookPage());
      case selectPoint:
        return createRoute(const SelectAddressMap());
      case registration:
        final flag = route.arguments as bool;
        return createRoute(MainRegPage(flag: flag));
      default:
        return null;
    }
  }
}
