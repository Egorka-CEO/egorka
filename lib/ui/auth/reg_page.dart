import 'dart:async';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/register_user.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/formatter_uppercase.dart';
import 'package:egorka/widget/policy_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

class RegPage extends StatefulWidget {
  RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController =
      TextEditingController(text: '+7 ');
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final streamSwap = StreamController<int>();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

  bool confirmTermPolitics = false;

  bool state = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    focusNode1.addListener(() {
      state = focusNode1.hasFocus;
      setState(() {});
    });
    focusNode2.addListener(() {
      state = focusNode2.hasFocus;
      setState(() {});
    });
    focusNode3.addListener(() {
      state = focusNode3.hasFocus;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSwap.close();
  }

  @override
  Widget build(BuildContext context) {
    final heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;
    TextStyle labelStyle =
        const TextStyle(fontWeight: FontWeight.w300, fontSize: 16);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: StreamBuilder<int>(
        stream: streamSwap.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 0.h),
            child: Material(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Физ. лицо'),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text('Логин', style: labelStyle),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                focusNode: focusNode6,
                                textEditingController: usernameController,
                                hintText: 'Ivanov',
                                height: 60.h,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text('Укажите Ваше имя', style: labelStyle),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                focusNode: focusNode1,
                                textEditingController: nameController,
                                hintText: 'Ivanov',
                                formatters: [CustomInputFormatterUpperCase()],
                                height: 60.h,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text('Ваш мобильный', style: labelStyle),
                        CustomTextField(
                          focusNode: focusNode2,
                          textEditingController: phoneController,
                          hintText: '+7 999-888-7766',
                          height: 60.h,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 20.w,
                          ),
                          formatters: [
                            MaskTextInputFormatter(
                              initialText: '+7 ',
                              mask: '+7 ###-###-####',
                              filter: {"#": RegExp(r'[0-9]')},
                            )
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text('Email', style: labelStyle),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                focusNode: focusNode3,
                                textEditingController: emailController,
                                hintText: 'ivanov@mail.ru',
                                height: 60.h,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text('Пароль', style: labelStyle),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                focusNode: focusNode4,
                                textEditingController: passwordController,
                                hintText: '******',
                                height: 60.h,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text('Пароль ещё раз', style: labelStyle),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                focusNode: focusNode5,
                                textEditingController: repeatPasswordController,
                                hintText: '******',
                                height: 60.h,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Checkbox(
                              value: confirmTermPolitics,
                              fillColor: MaterialStateProperty.all(Colors.red),
                              shape: const CircleBorder(),
                              onChanged: (value) {
                                setState(() {
                                  confirmTermPolitics = !confirmTermPolitics;
                                });
                              },
                            ),
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Нажимаю кнопку «Начать работать» Вы соглашаетесь с ',
                                      style: CustomTextStyle.black17w400
                                          .copyWith(fontSize: 13.sp),
                                    ),
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => launch(
                                            'https://egorka.delivery/egorka_rules.pdf'),
                                      text: 'Договором оферты ',
                                      style: CustomTextStyle.red15
                                          .copyWith(fontSize: 13.sp),
                                    ),
                                    TextSpan(
                                      text: 'и ',
                                      style: CustomTextStyle.black17w400
                                          .copyWith(fontSize: 13.sp),
                                    ),
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap =
                                            () => Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: ((context) {
                                                      return PolicyView();
                                                    }),
                                                  ),
                                                ),
                                      text: 'Политикой конфиденциальности',
                                      style: CustomTextStyle.red15
                                          .copyWith(fontSize: 13.sp),
                                    ),
                                    TextSpan(
                                      text: ' ООО «Егорка»',
                                      style: CustomTextStyle.black17w400
                                          .copyWith(fontSize: 13.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        RoundedLoadingButton(
                          controller: _btnController,
                          onPressed: _signIn,
                          color: Colors.red,
                          child: const Text(
                            'Зарегистрироваться',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: heightKeyBoard),
                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _signIn() async {
    int? res;
    if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        repeatPasswordController.text.isNotEmpty &&
        (passwordController.text == repeatPasswordController.text) &&
        confirmTermPolitics) {
      _btnController.start();
      RegisterUserModel userModel = RegisterUserModel(
        name: nameController.text,
        mobile: phoneController.text,
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
      );
      res = await Repository().registerUser(userModel);

      if (res != null) {
        String messageAlert = '';

        switch (res) {
          case 14810:
            messageAlert = 'Имя должно состоять из кирилицы';
            break;
          case 14811:
            messageAlert = 'Мобильный номер не указан/указан не верно';
            break;
          case 14822:
            messageAlert = 'Пользователь с таким Номером уже зарегистрирован';
            break;
          case 14812:
            messageAlert = 'Email указан не верно';
            break;
          case 14813:
            messageAlert = 'Логин должен быть на латинице';
            break;
          case 14831:
            messageAlert = 'Пользователь с таким Логином уже зарегистрирован';
            break;
          case 14821:
            messageAlert = 'Указан неверный номер телефона';
            break;
          case 14814:
            messageAlert = 'Пароль должен состоять из 6-30 символов';
            break;
          default:
            messageAlert = 'Введены неверные данные';
        }

        MessageDialogs().showMessage('Ошибка', messageAlert);
      }

      if (res == null) {
        _btnController.success();
        Future.delayed(const Duration(seconds: 1), (() {
          _btnController.reset();
          Navigator.of(context).pop();
        }));
      } else {
        _btnController.error();
        Future.delayed(const Duration(seconds: 1), (() {
          _btnController.reset();
        }));
      }
    } else {
      if (usernameController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите логин');
      } else if (passwordController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите пароль');
      } else if (repeatPasswordController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите пароль ещё раз');
      } else if (passwordController.text != repeatPasswordController.text) {
        MessageDialogs().showMessage('Ошибка', 'Пароли не совпадают');
      } else if (nameController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите ваше Имя');
      } else if (phoneController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите номер телефона');
      } else if (emailController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите email');
      } else if (!confirmTermPolitics) {
        MessageDialogs().showMessage('Ошибка',
            'Для продолжения дайте ваше согласие на Договор оферты и Политики конфиденциальности');
      }
      _btnController.reset();
    }
  }
}
