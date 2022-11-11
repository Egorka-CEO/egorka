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
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Drawer(
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
                    height: 40,
                  ),
                  const SizedBox(height: 30),
                  Container(
                    color: Colors.transparent,
                      width: double.infinity,
                      height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, AppRoute.trafficDeposit),
                            child: const Text(
                              'Движение по депозиту',
                              style: CustomTextStyle.black15w500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, AppRoute.addDeposit),
                            child: Icon(
                              Icons.add,
                              color: Colors.red.withOpacity(0.6),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // const Divider(height: 30),

                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoute.profile),
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: 50,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Профиль',
                          style: CustomTextStyle.black15w500,
                        ),
                      ),
                    ),
                  ),
                  // const Divider(height: 30),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoute.currentOrder),
                    child: Container(
                      color: Colors.transparent,
                      height: 50,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Текущий заказ',
                          style: CustomTextStyle.black15w500,
                        ),
                      ),
                    ),
                  ),
                  // const Divider(height: 30),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<HistoryOrdersBloc>(context)
                          .add(OpenBtmSheetHistoryEvent());
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 50,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'История заказов',
                          style: CustomTextStyle.black15w500,
                        ),
                      ),
                    ),
                  ),
                  // const Divider(height: 30),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoute.marketplaces),
                    child: Container(
                      color: Colors.transparent,
                      height: 50,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Маркетплейсы',
                          style: CustomTextStyle.black15w500,
                        ),
                      ),
                    ),
                  ),
                  // const Divider(height: 30),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoute.about),
                    child: Container(
                      color: Colors.transparent,
                      height: 50,
                      width: double.infinity,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'О приложении',
                          style: CustomTextStyle.black15w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
