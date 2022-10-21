import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({super.key});

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
                    // physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
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
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  return Text('item $index',
                                      style: CustomTextStyle.grey14w400);
                                }),
                                shrinkWrap: true,
                                itemCount: 10,
                              ),
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
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  return Text('item $index',
                                      style: CustomTextStyle.grey14w400);
                                }),
                                shrinkWrap: true,
                                itemCount: 10,
                              ),
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
