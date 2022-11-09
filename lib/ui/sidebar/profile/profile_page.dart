import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Профиль',
          style: CustomTextStyle.black15w500,
        ),
        foregroundColor: Colors.red,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
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
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Иванов Дмитрий Игоревич, ИП',
                                style: CustomTextStyle.black15w700,
                              ),
                            ],
                          )
                        ],
                      )
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Депозит:',
                              style: CustomTextStyle.black15w700
                                  .copyWith(fontSize: 24),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '200 367 ₽',
                              style: CustomTextStyle.black15w700.copyWith(
                                fontSize: 30,
                                color: Colors.green[600],
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
                      Text('Основные данные',
                          style: CustomTextStyle.black15w500),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
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
                                    text: 'Логин: ',
                                    style: CustomTextStyle.black15w700.copyWith(
                                      color: Colors.grey[700],
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
                                    text: 'Моб. номер: ',
                                    style: CustomTextStyle.black15w700.copyWith(
                                      color: Colors.grey[700],
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
                                    text: 'Раб. номер: ',
                                    style: CustomTextStyle.black15w700.copyWith(
                                      color: Colors.grey[700],
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
                                    text: 'Email: ',
                                    style: CustomTextStyle.black15w700.copyWith(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'test@mail.ru',
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
                                    text: 'Временная зона: ',
                                    style: CustomTextStyle.black15w700.copyWith(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'Europe/Moscow',
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
                      Text('Пароль', style: CustomTextStyle.black15w500),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Текущий пароль: ',
                              style: CustomTextStyle.black15w700.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                            CustomTextField(
                              obscureText: true,
                              hintText: '',
                              textEditingController:
                                  TextEditingController(text: 'password'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Новый пароль: ',
                              style: CustomTextStyle.black15w700.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                            CustomTextField(
                              obscureText: true,
                              hintText: '',
                              textEditingController:
                                  TextEditingController(text: 'password'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Новый пароль повторно: ',
                              style: CustomTextStyle.black15w700.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                            CustomTextField(
                              obscureText: true,
                              hintText: '',
                              textEditingController:
                                  TextEditingController(text: 'password'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50)
              ],
            ),
          )
        ],
      ),
    );
  }
}
