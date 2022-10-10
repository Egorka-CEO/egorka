import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

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
                      alignment: Alignment.centerRight,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text('Отмена',
                              style: CustomTextStyle.red15),
                        ),
                        const Align(
                          child: Text(
                            'Оформление заказа',
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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Доставка до маркетплейса',
                            style: CustomTextStyle.black15w700,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Как это работает?',
                            style: CustomTextStyle.red15,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: const [
                              Text(
                                'Откуда забрать?',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: false,
                                fillColor:
                                    MaterialStateProperty.all(Colors.red),
                                shape: const CircleBorder(),
                                onChanged: ((value) {}),
                              ),
                              const Expanded(child: TextField()),
                              const Icon(
                                Icons.gps_fixed,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: const [
                              Text(
                                'Не обязательно к заполнению',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Подъезд',
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Этаж',
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Офис/кв.',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: const [
                              Text('Куда отвезти?',
                                  style: CustomTextStyle.grey15bold),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: false,
                                fillColor:
                                    MaterialStateProperty.all(Colors.blue),
                                shape: const CircleBorder(),
                                onChanged: ((value) {}),
                              ),
                              const Expanded(child: TextField()),
                              const Icon(
                                Icons.map_outlined,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: const [
                              Text(
                                'Когда забрать?',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Expanded(child: TextField()),
                              Icon(
                                Icons.help_outline_outlined,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: const [
                              Text(
                                'Оформить доставку до Маркетплейса на завтра\nможно строго до 15:00.',
                                style: CustomTextStyle.grey15,
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Text(
                                'Ваши контакты',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Имя',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: '+7 (999) 888-77-66',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Text(
                                'Кол-во коробок?',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(text: '0'),
                                ),
                              ),
                              const Icon(
                                Icons.help_outline_outlined,
                                color: Colors.red,
                              ),
                              Expanded(
                                flex: 2,
                                child: Slider(
                                    thumbColor: Colors.red,
                                    value: 0,
                                    onChanged: (value) {}),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Text(
                                'Кол-во паллет?',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(text: '0'),
                                ),
                              ),
                              const Icon(
                                Icons.help_outline_outlined,
                                color: Colors.red,
                              ),
                              Expanded(
                                flex: 2,
                                child: Slider(
                                    thumbColor: Colors.red,
                                    value: 0,
                                    onChanged: (value) {}),
                              )
                            ],
                          ),
                          const SizedBox(height: 210)
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 180,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'assets/images/ic_leg.png',
                                  color: Colors.red,
                                  height: 90,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Пеший',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w300)),
                                    Text('1900 ₽',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const Text(
                                  '}',
                                  style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.w200),
                                ),
                                // SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('400 ₽ доставка'),
                                    Text('0 ₽ доп. услуги'),
                                    Text('11 ₽ сбор-плат. сист.'),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text('ОПЛАТИТЬ ЗАКАЗ',
                                    style: CustomTextStyle.white15w600
                                        .copyWith(letterSpacing: 3)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}