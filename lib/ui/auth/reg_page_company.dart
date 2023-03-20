import 'dart:async';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/register_company.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/policy_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

class RegPageCompany extends StatefulWidget {
  RegPageCompany({super.key});

  @override
  State<RegPageCompany> createState() => _RegPageCompanyState();
}

class _RegPageCompanyState extends State<RegPageCompany> {
  String? idCompany;
  final TextEditingController innController = TextEditingController();
  final TextEditingController loginCompanyController = TextEditingController();
  final TextEditingController phoneCompanyController =
      TextEditingController(text: '+7 ');
  final TextEditingController emailCompanyController = TextEditingController();
  final TextEditingController loginUserController =
      TextEditingController(text: 'Admin');
  final TextEditingController phoneUserController =
      TextEditingController(text: '+7 ');
  final TextEditingController emailUserController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final streamSwap = StreamController<int>();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  FocusNode focusNode7 = FocusNode();
  FocusNode focusNode8 = FocusNode();
  FocusNode focusNode9 = FocusNode();

  bool confirmTermPolitics = false;

  bool state = false;
  int index = 0;

  String? companyName;

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
    TextStyle labelStyle =
        const TextStyle(fontWeight: FontWeight.w300, fontSize: 16);
    final heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('ООО, ИП'),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text('ИНН организации', style: labelStyle),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  focusNode: focusNode1,
                                  textEditingController: innController,
                                  hintText: '4377373782382',
                                  height: 60.h,
                                  onChanged: (value) async {
                                    if (innController.text.isNotEmpty) {
                                      Map<String, dynamic>? temp =
                                          await Repository()
                                              .searchINN(innController.text);
                                      idCompany = temp?['ID'];
                                      companyName = temp?['Name'];

                                      idCompany = idCompany ?? '';
                                    } else {
                                      idCompany = null;
                                    }

                                    setState(() {});
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (idCompany != null && idCompany!.isEmpty)
                            const Text(
                              'Ни одной компании не найдено ',
                              style: CustomTextStyle.red15,
                            ),
                          if (companyName != null)
                            Text(
                              companyName!,
                              style: CustomTextStyle.red15
                                  .copyWith(color: Colors.green),
                            ),
                          SizedBox(height: 20.h),
                          Text('Логин компании', style: labelStyle),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  focusNode: focusNode2,
                                  textEditingController: loginCompanyController,
                                  hintText: 'EgorkaDelivery',
                                  height: 60.h,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Логин компании един для всех учетных записей Вашей организации. '
                            'Рекомендуем использовать короткое название. Может содержать только '
                            'латинские буквы и цифры.',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 20.h),
                          Text('Телефон компании', style: labelStyle),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  focusNode: focusNode3,
                                  textEditingController: phoneCompanyController,
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
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text('Email компании', style: labelStyle),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  focusNode: focusNode4,
                                  textEditingController: emailCompanyController,
                                  hintText: 'egorka@mail.ru',
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
                          Divider(
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 20.h),
                          Text('Логин пользователя', style: labelStyle),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  focusNode: focusNode5,
                                  textEditingController: loginUserController,
                                  hintText: 'Admin',
                                  height: 60.h,
                                  enabled: false,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Логин главной учётной записи',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 20.h),
                          Text('Ваш мобильный', style: labelStyle),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  focusNode: focusNode6,
                                  textEditingController: phoneUserController,
                                  hintText: '+7 (999) 888-77-66',
                                  height: 60.h,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.w,
                                  ),
                                  formatters: [
                                    MaskTextInputFormatter(
                                      initialText: '+7 (',
                                      mask: '+7 (###) ###-##-##',
                                      filter: {"#": RegExp(r'[0-9]')},
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text('Ваш Email', style: labelStyle),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  focusNode: focusNode7,
                                  textEditingController: emailUserController,
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
                          Text('Придумайте пароль', style: labelStyle),
                          CustomTextField(
                            focusNode: focusNode8,
                            textEditingController: passwordController,
                            hintText: '******',
                            height: 60.h,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.w,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text('Пароль еще раз', style: labelStyle),
                          CustomTextField(
                            focusNode: focusNode9,
                            textEditingController: repeatPasswordController,
                            hintText: '******',
                            height: 60.h,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.w,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Checkbox(
                                value: confirmTermPolitics,
                                fillColor:
                                    MaterialStateProperty.all(Colors.red),
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
                              'Начать работать',
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
          }),
    );
  }

  void _signIn() async {
    int? res;
    if (innController.text.isNotEmpty &&
        loginCompanyController.text.isNotEmpty &&
        phoneCompanyController.text.isNotEmpty &&
        emailCompanyController.text.isNotEmpty &&
        loginUserController.text.isNotEmpty &&
        phoneUserController.text.isNotEmpty &&
        emailUserController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        repeatPasswordController.text.isNotEmpty &&
        (passwordController.text == repeatPasswordController.text) &&
        idCompany != null &&
        confirmTermPolitics) {
      RegisterCompanyModel companyModel = RegisterCompanyModel(
        id: idCompany!,
        company: loginCompanyController.text,
        companyPhone: phoneCompanyController.text,
        companyEmail: emailCompanyController.text,
        userMobile: phoneUserController.text,
        userEmail: emailUserController.text,
        userPassword: passwordController.text,
      );
      _btnController.start();
      res = await Repository().registerCompany(companyModel);

      if (res != null) {
        String messageAlert = '';

        switch (res) {
          case 14710:
            messageAlert = 'Неверно указан ИНН компании';
            break;
          case 14720:
            messageAlert = 'Неверно указан ИНН компании';
            break;
          case 14721:
            messageAlert = 'Компания с таким ИНН уже зарегистрирована';
            break;
          case 14711:
            messageAlert =
                'Логин компании должен состоять из латинских символов и цифр';
            break;
          case 14722:
            messageAlert =
                'Логин компании должен состоять из латинских символов и цифр';
            break;
          case 14723:
            messageAlert = 'Компания с таким Логином уже зарегистрирована';
            break;
          case 14712:
            messageAlert = 'Неверно указан Телефон компании';
            break;
          case 14724:
            messageAlert = 'Неверно указан Телефон компании';
            break;
          case 14713:
            messageAlert = 'Неверно указан Email компании';
            break;
          case 14725:
            messageAlert = 'Неверно указан Email компании';
            break;
          case 14714:
            messageAlert = 'Неверно указан Номер пользователя';
            break;
          case 14726:
            messageAlert = 'Неверно указан Номер пользователя';
            break;
          case 14715:
            messageAlert = 'Неверно указан Email пользователя';
            break;
          case 14727:
            messageAlert = 'Неверно указан Email пользователя';
            break;
          case 14716:
            messageAlert = 'Пароль должен состоять из 6-30 символов';
            break;
          case 14728:
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
      if (companyName == null) {
        MessageDialogs().showMessage('Ошибка', 'Укажите ИНН компании');
      } else if (loginCompanyController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите логин компании');
      } else if (phoneCompanyController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите телефон компании');
      } else if (emailCompanyController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите email компании');
      } else if (phoneUserController.text.isEmpty) {
        MessageDialogs()
            .showMessage('Ошибка', 'Укажите телефон учетной записи');
      } else if (emailUserController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите email учетной записи');
      } else if (passwordController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите пароль');
      } else if (repeatPasswordController.text.isEmpty) {
        MessageDialogs().showMessage('Ошибка', 'Укажите пароль ещё раз');
      } else if (passwordController.text != repeatPasswordController.text) {
        MessageDialogs().showMessage('Ошибка', 'Пароли не совпадают');
      } else if (!confirmTermPolitics) {
        MessageDialogs().showMessage('Ошибка',
            'Для продолжения дайте ваше согласие на Договор оферты и Политики конфиденциальности');
      }
      _btnController.reset();
    }
  }
}
