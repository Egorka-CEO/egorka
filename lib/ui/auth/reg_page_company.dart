import 'dart:async';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/register_company.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final TextEditingController loginUserController = TextEditingController();
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
    // focusNode1.requestFocus();
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
                          SizedBox(height: 40.h),
                          Row(
                            children: [
                              Expanded(
                                child: SvgPicture.asset(
                                  'assets/icons/logo_egorka.svg',
                                  height: 40.h,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Егорка готов к сотрудничеству!\nОстается пройти быструю регистрацию',
                                style: TextStyle(fontSize: 19.sp),
                              ),
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
                                      idCompany =
                                          '${await Repository().searchINN(int.parse(innController.text))}';
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
                          if (idCompany != null && idCompany!.isNotEmpty)
                            const Text(
                              'Ни одной компании не найдено ',
                              style: CustomTextStyle.red15,
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
                                value: true,
                                fillColor:
                                    MaterialStateProperty.all(Colors.red),
                                shape: const CircleBorder(),
                                onChanged: (value) {},
                              ),
                              Expanded(
                                child: RichText(
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Нажимаю кнопку «Начать работать» Вы соглашаетесь с ',
                                        style: CustomTextStyle.black15w500
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
                                        text:
                                            'и Политикой конфиденциальности ООО «Егорка»',
                                        style: CustomTextStyle.black15w500
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
    bool? res;
    if (innController.text.isNotEmpty &&
        loginCompanyController.text.isNotEmpty &&
        phoneCompanyController.text.isNotEmpty &&
        emailCompanyController.text.isNotEmpty &&
        loginUserController.text.isNotEmpty &&
        phoneUserController.text.isNotEmpty &&
        emailUserController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        repeatPasswordController.text.isNotEmpty &&
        idCompany != null) {
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

      if (res != null && res) {
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
      _btnController.reset();
    }
  }
}
