import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/receiver.dart';
import 'package:egorka/model/sender.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({super.key});

  static Sender sender = Sender(
    firstName: 'Олег',
    secondName: 'Бочко',
    phone: '+79223747362',
    address: 'г.Москва, ул.Кижеватова д.23',
  );

  static Receiver receiver = Receiver(
    firstName: 'Максим',
    secondName: 'Яковлев',
    phone: '+79111119393',
    address: 'г.Москва, ул.Солнечная д.6',
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        bottom: false,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0, bottom: 8),
                                child: Text(
                                  'Отправитель',
                                  style: CustomTextStyle.grey15bold,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Имя: ${sender.secondName}',
                                      style: CustomTextStyle.grey14w400),
                                  Text('Фамилия: ${sender.firstName}',
                                      style: CustomTextStyle.grey14w400),
                                  Text('Телефон: ${sender.phone}',
                                      style: CustomTextStyle.grey14w400),
                                  Text('Адрес: ${sender.address}',
                                      style: CustomTextStyle.grey14w400)
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, bottom: 8),
                                    child: Text(
                                      'Добавить отправителя',
                                      style: CustomTextStyle.red15,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0, bottom: 8),
                                child: Text(
                                  'Получатель',
                                  style: CustomTextStyle.grey15bold,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Имя: ${receiver.secondName}',
                                      style: CustomTextStyle.grey14w400),
                                  Text('Фамилия: ${receiver.firstName}',
                                      style: CustomTextStyle.grey14w400),
                                  Text('Телефон: ${receiver.phone}',
                                      style: CustomTextStyle.grey14w400),
                                  Text('Адрес: ${receiver.address}',
                                      style: CustomTextStyle.grey14w400)
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, bottom: 8),
                                    child: Text(
                                      'Добавить получателя',
                                      style: CustomTextStyle.red15,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0, top: 20),
                                child: Text(
                                  'Что везем?',
                                  style: CustomTextStyle.grey15bold,
                                ),
                              ),
                              CustomTextField(
                                hintText:
                                    'Документы / Цветы / Техника / Личная вещь',
                                textEditingController: TextEditingController(),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0, top: 20),
                                child: Text(
                                  'Ценность вашего груза?',
                                  style: CustomTextStyle.grey15bold,
                                ),
                              ),
                              CustomTextField(
                                hintText: 'До 100000 ₽',
                                textEditingController: TextEditingController(),
                              ),
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
                      height: 200,
                      padding: const EdgeInsets.only(bottom: 40),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
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
                                    Text(
                                      'Пеший',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      '1900 ₽',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  '}',
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
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
                            GestureDetector(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Text(
                                    'ОПЛАТИТЬ ЗАКАЗ',
                                    style: CustomTextStyle.white15w600
                                        .copyWith(letterSpacing: 3),
                                  ),
                                ),
                              ),
                            ),
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
