import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';

class DeliveryProfilePage extends StatelessWidget {
  const DeliveryProfilePage({super.key});

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
                          child: Text('Профиль',
                              style: CustomTextStyle.black15w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/images/deliver.jpeg',
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
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
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: const [
                  Text('Личные данные', style: CustomTextStyle.black15w500),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Номер: ',
                                style: CustomTextStyle.black15w700.copyWith(
                                  color: Colors.grey[400],
                                ),
                              ),
                              const TextSpan(
                                text: '+7 988 003 4712',
                                style: CustomTextStyle.black15w700,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Способ доставки: ',
                                style: CustomTextStyle.black15w700.copyWith(
                                  color: Colors.grey[400],
                                ),
                              ),
                              const TextSpan(
                                text: 'авто',
                                style: CustomTextStyle.black15w700,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: const [
                  Text('Статистика', style: CustomTextStyle.black15w500),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Заказов: ',
                                style: CustomTextStyle.black15w700.copyWith(
                                  color: Colors.grey[400],
                                ),
                              ),
                              const TextSpan(
                                text: '10',
                                style: CustomTextStyle.black15w700,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Средняя оценка: ',
                                style: CustomTextStyle.black15w700.copyWith(
                                  color: Colors.grey[400],
                                ),
                              ),
                              const TextSpan(
                                text: '4.2',
                                style: CustomTextStyle.black15w700,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
