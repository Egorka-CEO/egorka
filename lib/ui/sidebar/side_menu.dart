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
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/images/company.jpg',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Иванов Дмитрий Игоревич, ИП',
                          style: CustomTextStyle.black15w500
                              .copyWith(fontSize: 17),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoute.profile),
                  child: Text(
                    'Профиль',
                    style: CustomTextStyle.black15w500.copyWith(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoute.currentOrder),
                  child: Text(
                    'Текущий заказ',
                    style: CustomTextStyle.black15w500.copyWith(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<HistoryOrdersBloc>(context)
                        .add(OpenBtmSheetHistoryEvent());
                  },
                  child: Text(
                    'История заказов',
                    style: CustomTextStyle.black15w500.copyWith(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoute.marketplaces),
                  child: Text(
                    'Маркетплейсы',
                    style: CustomTextStyle.black15w500.copyWith(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoute.about),
                  child: Text(
                    'О приложении',
                    style: CustomTextStyle.black15w500.copyWith(fontSize: 17),
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
