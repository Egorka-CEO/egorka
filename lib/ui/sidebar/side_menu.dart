import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListView(
              children: [
                SvgPicture.asset(
                  'assets/icons/logo_egorka.svg',
                  alignment: Alignment.centerLeft,
                  width: 100,
                  height: 30,
                ),
                const Divider(height: 30),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoute.currentOrder),
                  child: const Text(
                    'Текущий заказ',
                    style: CustomTextStyle.black15w500,
                  ),
                ),
                const Divider(height: 30),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<HistoryOrdersBloc>(context)
                        .add(OpenBtmSheetHistoryEvent());
                  },
                  child: const Text(
                    'История заказов',
                    style: CustomTextStyle.black15w500,
                  ),
                ),
                const Divider(height: 30),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoute.marketplaces),
                  child: const Text(
                    'Маркетплейсы',
                    style: CustomTextStyle.black15w500,
                  ),
                ),
                const Divider(height: 30),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoute.about),
                  child: const Text(
                    'О приложении',
                    style: CustomTextStyle.black15w500,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
