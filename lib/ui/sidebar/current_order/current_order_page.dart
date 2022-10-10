import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/map.dart';
import 'package:flutter/material.dart';

class CurrentOrderPage extends StatelessWidget {
  const CurrentOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
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
                            'Текущий заказ',
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
                      const Text('Заказ №123 / 6 марта',
                          style: CustomTextStyle.black15w500),
                      const SizedBox(height: 10),
                      const Text('Статус: поиск Егорки',
                          style: CustomTextStyle.grey14w400),
                      const SizedBox(height: 10),
                      const SizedBox(
                        height: 150,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: MapView()),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          children: const [
                            Text('Дата и время забора',
                                style: CustomTextStyle.grey15bold),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Row(
                          children: const [
                            SizedBox(width: 10),
                            Text('Суббота, 7 марта с 13:00 до 14:00',
                                style: CustomTextStyle.black15w500),
                          ],
                        ),
                      ),
                      Row(
                        children: const [
                          Text('Маршрут', style: CustomTextStyle.grey15bold),
                        ],
                      ),
                      const SizedBox(height: 200),
                      Row(
                        children: const [
                          Text('Кто везёт', style: CustomTextStyle.grey15bold),
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
                                  Text('Евгений',
                                      style: CustomTextStyle.black15w700),
                                  SizedBox(height: 10),
                                  Text('Румянцев',
                                      style: CustomTextStyle.black15w700),
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
                                  Text('Lada Largus / У081МО799',
                                      style: CustomTextStyle.black15w700),
                                  SizedBox(height: 10),
                                  Text('Цвет: белый',
                                      style: CustomTextStyle.black15w700),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: const [
                          Text('Сводная информация',
                              style: CustomTextStyle.grey15bold),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          SizedBox(width: 10),
                          Text('Объявленная ценность',
                              style: CustomTextStyle.grey15bold),
                          Spacer(),
                          Text('1000 ₽', style: CustomTextStyle.black15w700),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          SizedBox(width: 10),
                          Text('Что везем', style: CustomTextStyle.grey15bold),
                          Spacer(),
                          Text('Зарядка', style: CustomTextStyle.black15w700),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          SizedBox(width: 10),
                          Text('Стоимость заказа',
                              style: CustomTextStyle.grey15bold),
                          Spacer(),
                          Text('562 ₽', style: CustomTextStyle.black15w700),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          SizedBox(width: 10),
                          Text('Способ оплаты',
                              style: CustomTextStyle.grey15bold),
                          Spacer(),
                          Text('Депозит', style: CustomTextStyle.black15w700),
                        ],
                      ),
                      const SizedBox(height: 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: const [
                              Icon(
                                Icons.call,
                                color: Colors.red,
                                size: 50,
                              ),
                              Text('Позвонить\nводителю',
                                  style: CustomTextStyle.black15w700),
                            ],
                          ),
                          Column(
                            children: const [
                              Icon(
                                Icons.send,
                                color: Colors.red,
                                size: 50,
                              ),
                              Text('Написать в\nподдержку',
                                  style: CustomTextStyle.black15w700),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
