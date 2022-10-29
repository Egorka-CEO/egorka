import 'package:egorka/core/bloc/current_order/current_order_bloc.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/route_order.dart';
import 'package:egorka/widget/mini_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryOrdersPage extends StatelessWidget {
  const HistoryOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<RouteOrder> routeOrder = [
      RouteOrder(adress: 'москва солнечная 6'),
      RouteOrder(adress: 'москва межевая 24'),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentOrderBloc>(
          create: (context) => CurrentOrderBloc(),
        ),
      ],
      child: Material(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_outlined,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                          const Align(
                            child: Text(
                              'История',
                              style: CustomTextStyle.black15w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Заказ №123 / 6 марта',
                          style: CustomTextStyle.black15w500,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 250,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: MiniMapView(routeOrder: routeOrder),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Text(
                              'Дата и время забора',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: const [
                            SizedBox(width: 10),
                            Text(
                              'Суббота, 7 марта с 13:00 до 14:00',
                              style: CustomTextStyle.black15w500,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: const [
                            Text(
                              'Маршрут',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: routeOrder.length,
                          itemBuilder: ((context, index) {
                            if (index != routeOrder.length - 1) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/from.png',
                                            height: 25,
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            routeOrder[index].adress,
                                            style: CustomTextStyle.black15w500,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_downward_rounded,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(width: 15),
                                          const Text(
                                            'Посмотреть детали',
                                            style: CustomTextStyle.red15,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/to.png',
                                          height: 25,
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          routeOrder[index].adress,
                                          style: CustomTextStyle.black15w500,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.flag,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(width: 15),
                                        const Text(
                                          'Посмотреть детали',
                                          style: CustomTextStyle.red15,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: const [
                            Text(
                              'Кто везёт',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    'assets/images/deliver.jpeg',
                                    height: 80,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Евгений',
                                      style: CustomTextStyle.black15w700,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Румянцев',
                                      style: CustomTextStyle.black15w700,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/ic_leg.png',
                                        color: Colors.red,
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Lada Largus / У081МО799',
                                      style: CustomTextStyle.black15w700,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Цвет: белый',
                                      style: CustomTextStyle.black15w700,
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: const [
                            Text(
                              'Сводная информация',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: const [
                            SizedBox(width: 10),
                            Text(
                              'Объявленная ценность',
                              style: CustomTextStyle.grey15bold,
                            ),
                            Spacer(),
                            Text(
                              '1000 ₽',
                              style: CustomTextStyle.black15w700,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: const [
                            SizedBox(width: 10),
                            Text(
                              'Что везем',
                              style: CustomTextStyle.grey15bold,
                            ),
                            Spacer(),
                            Text(
                              'Зарядка',
                              style: CustomTextStyle.black15w700,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: const [
                            SizedBox(width: 10),
                            Text(
                              'Стоимость заказа',
                              style: CustomTextStyle.grey15bold,
                            ),
                            Spacer(),
                            Text(
                              '562 ₽',
                              style: CustomTextStyle.black15w700,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: const [
                            SizedBox(width: 10),
                            Text(
                              'Способ оплаты',
                              style: CustomTextStyle.grey15bold,
                            ),
                            Spacer(),
                            Text(
                              'Депозит',
                              style: CustomTextStyle.black15w700,
                            ),
                          ],
                        ),
                        const SizedBox(height: 70),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
