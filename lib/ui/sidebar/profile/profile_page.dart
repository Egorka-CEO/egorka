import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Профиль',
          style: CustomTextStyle.black15w500,
        ),
        foregroundColor: Colors.red,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: Image.asset(
                              'assets/images/company.jpg',
                              height: 80.w,
                              width: 80.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20.w),
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
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
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
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Text(
                                  '200 367 ₽',
                                  style: CustomTextStyle.black15w700.copyWith(
                                    fontSize: 30,
                                    color: Colors.green[600],
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, AppRoute.addDeposit),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: const [
                      Text('Основные данные',
                          style: CustomTextStyle.black15w500),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    padding: EdgeInsets.all(20.0.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20.r),
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
                            SizedBox(height: 15.h),
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
                            SizedBox(height: 15.h),
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
                            SizedBox(height: 15.h),
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
                            SizedBox(height: 15.h),
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
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: const [
                      Text('Пароль', style: CustomTextStyle.black15w500),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20.r),
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
                              fillColor: Colors.white,
                              textEditingController:
                                  TextEditingController(text: 'password'),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
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
                              fillColor: Colors.white,
                              textEditingController:
                                  TextEditingController(text: 'password'),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
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
                              fillColor: Colors.white,
                              textEditingController:
                                  TextEditingController(text: 'password'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.h)
              ],
            ),
          )
        ],
      ),
    );
  }
}
