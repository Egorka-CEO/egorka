import 'dart:developer';

import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/employee.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/formatter_uppercase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:scale_button/scale_button.dart';

class EmployeePage extends StatefulWidget {
  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  List<Employee> employee = [];
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  FocusNode focusNode7 = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int countEmployee = 0;

  @override
  void initState() {
    super.initState();
    getEmployee();
  }

  void getEmployee() async {
    employee.clear();
    employee = await Repository().getListEmployee();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    countEmployee = 0;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          title: const Text(
            'Список сотрудников',
            style: CustomTextStyle.black17w400,
          ),
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: employee.length + 1,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          itemBuilder: (context, index) {
            if (index == employee.length) {
              return Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: ScaleButton(
                  bound: 0.02,
                  onTap: () {
                    addEmloyee(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.4),
                        width: 1.h,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              );
            }
            if (employee[index].username == 'Admin') return SizedBox();
            ++countEmployee;
            return itemEmployee(employee[index], index);
          },
        ),
      ),
    );
  }

  Widget itemEmployee(Employee employee, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: ScaleButton(
        bound: 0.02,
        onTap: () {
          nameController.text = '${employee.name!} ${employee.surname!}';
          phoneController.text = employee.phoneMobile ?? '';
          emailController.text = employee.email ?? '';
          loginController.text = employee.username ?? '';
          editEmployee(context, employee);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 30.r,
                  color: Colors.black.withOpacity(0.1))
            ],
          ),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: SizedBox(
                      height: 130.h,
                      child: Text(
                        (countEmployee).toString(),
                        style: TextStyle(
                          fontSize: 140.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.all(16.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Имя: ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                            '${employee.name ?? ''} ${employee.surname ?? ''}'),
                        // Text(employee.surname ?? ''),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        const Text(
                          'Телефон: ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(employee.phoneMobile ?? '-'),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        const Text(
                          'Почта: ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(employee.email ?? '-'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addEmloyee(
    BuildContext context,
  ) =>
      showDialog(
        useSafeArea: false,
        barrierColor: Colors.black.withOpacity(0.2),
        context: context,
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: StatefulBuilder(builder: (context, snapshot) {
              return AlertDialog(
                insetPadding: EdgeInsets.only(top: 80.h),
                alignment: Alignment.topCenter,
                contentPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    width: MediaQuery.of(context).size.width - 30.w,
                    height: 600.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Укажите данные нового сотрудника',
                              style: CustomTextStyle.black17w400,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Expanded(
                          child: SizedBox(
                            child: ListView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.all(24.w),
                              children: [
                                const Text('Имя'),
                                GestureDetector(
                                  child: CustomTextField(
                                    focusNode: focusNode1,
                                    hintText: 'Иван',
                                    formatters: [
                                      CustomInputFormatterUpperCase()
                                    ],
                                    textEditingController: nameController,
                                    fillColor: Colors.grey[100],
                                    height: 45.h,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                const Text('Телефон'),
                                CustomTextField(
                                  focusNode: focusNode4,
                                  textEditingController: phoneController,
                                  fillColor: Colors.grey[100],
                                  hintText: '+7 999-888-7766',
                                  formatters: [
                                    MaskTextInputFormatter(
                                      initialText: '+7 ',
                                      mask: '+7 ###-###-####',
                                      filter: {"#": RegExp(r'[0-9]')},
                                    )
                                  ],
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                ),
                                SizedBox(height: 10.h),
                                const Text('Email'),
                                CustomTextField(
                                  focusNode: focusNode5,
                                  hintText: 'test@mail.ru',
                                  textEditingController: emailController,
                                  fillColor: Colors.grey[100],
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                ),
                                SizedBox(height: 10.h),
                                const Text('Логин'),
                                CustomTextField(
                                  focusNode: focusNode6,
                                  hintText: 'Petrov',
                                  textEditingController: loginController,
                                  fillColor: Colors.grey[100],
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                ),
                                SizedBox(height: 10.h),
                                const Text('Пароль'),
                                CustomTextField(
                                  focusNode: focusNode7,
                                  hintText: '**********',
                                  textEditingController: passwordController,
                                  fillColor: Colors.grey[100],
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24.w),
                          child: GestureDetector(
                            onTap: () async {
                              if (nameController.text.isNotEmpty &&
                                  phoneController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  loginController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                String? res = await Repository().addEmployee(
                                  nameController.text,
                                  phoneController.text,
                                  emailController.text,
                                  loginController.text,
                                  passwordController.text,
                                );
                                log('$res');
                                if (res == null) {
                                  getEmployee();
                                  nameController.text = '';
                                  phoneController.text = '';
                                  emailController.text = '';
                                  loginController.text = '';
                                  passwordController.text = '';
                                  Navigator.of(context).pop();
                                } else {
                                  if (res == 'Wrong Name') {
                                    MessageDialogs().showAlert(
                                        'Ошибка', 'Укажите правильное имя');
                                  } else if (res == 'User mobile is wrong') {
                                    MessageDialogs().showAlert('Ошибка',
                                        'Укажите правильный номер телефона');
                                  } else if (res == 'User email is wrong') {
                                    MessageDialogs().showAlert(
                                        'Ошибка', 'Укажите правильный email');
                                  } else if (res == 'Wrong Username') {
                                    MessageDialogs().showAlert(
                                        'Ошибка', 'Укажите правильный Логин');
                                  }
                                  // MessageDialogs().showAlert('Ошибка',
                                  //     'Пользватель с таким email или телефоном уже зарегистрирован');
                                }
                              } else {
                                String error = '';
                                if (nameController.text.isEmpty) {
                                  error = 'Укажите Имя';
                                } else if (phoneController.text.isEmpty) {
                                  error = 'Укажите Номер телефона';
                                } else if (emailController.text.isEmpty) {
                                  error = 'Укажите Почту';
                                } else if (loginController.text.isEmpty) {
                                  error = 'Укажите Логин';
                                } else if (passwordController.text.isEmpty) {
                                  error = 'Укажите Пароль';
                                }
                                MessageDialogs().showAlert('Ошибка', error);
                              }
                            },
                            child: Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Добавить сотрудника',
                                  style: CustomTextStyle.white15w600.copyWith(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: MediaQuery.of(context).viewInsets.bottom / 5,
                        // )
                      ],
                    )),
              );
            }),
          );
        },
      );

  void editEmployee(BuildContext context, Employee employee) => showDialog(
        useSafeArea: false,
        barrierColor: Colors.black.withOpacity(0.2),
        context: context,
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: StatefulBuilder(builder: (context, snapshot) {
              return AlertDialog(
                insetPadding: EdgeInsets.only(top: 80.h),
                alignment: Alignment.topCenter,
                contentPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    width: MediaQuery.of(context).size.width - 30.w,
                    height: 600.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Укажите данные нового сотрудника',
                              style: CustomTextStyle.black17w400,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Expanded(
                          child: SizedBox(
                            child: ListView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.all(24.w),
                              children: [
                                const Text('Имя'),
                                GestureDetector(
                                  child: CustomTextField(
                                    focusNode: focusNode1,
                                    hintText: 'Иван',
                                    textEditingController: nameController,
                                    fillColor: Colors.grey[100],
                                    height: 45.h,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                const Text('Телефон'),
                                CustomTextField(
                                  focusNode: focusNode4,
                                  textEditingController: phoneController,
                                  fillColor: Colors.grey[100],
                                  hintText: '+7 999-888-7766',
                                  formatters: [
                                    MaskTextInputFormatter(
                                      initialText: '+7 ',
                                      mask: '+7 ###-###-####',
                                      filter: {"#": RegExp(r'[0-9]')},
                                    )
                                  ],
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                ),
                                SizedBox(height: 10.h),
                                const Text('Email'),
                                CustomTextField(
                                  focusNode: focusNode5,
                                  hintText: 'test@mail.ru',
                                  textEditingController: emailController,
                                  fillColor: Colors.grey[100],
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                ),
                                SizedBox(height: 10.h),
                                const Text('Логин'),
                                CustomTextField(
                                  focusNode: focusNode6,
                                  hintText: 'Petrov',
                                  textEditingController: loginController,
                                  fillColor: Colors.grey[100],
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                ),
                                SizedBox(height: 10.h),
                                const Text('Пароль'),
                                CustomTextField(
                                  focusNode: focusNode7,
                                  hintText: '**********',
                                  textEditingController: passwordController,
                                  fillColor: Colors.grey[100],
                                  height: 45.h,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24.w),
                          child: GestureDetector(
                            onTap: () async {
                              if (nameController.text.isNotEmpty &&
                                  phoneController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  loginController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                bool res = await Repository().editEmployee(
                                  nameController.text,
                                  phoneController.text,
                                  emailController.text,
                                  loginController.text,
                                  passwordController.text,
                                  employee.id!,
                                );
                                if (res) {
                                  getEmployee();
                                  nameController.text = '';
                                  phoneController.text = '';
                                  emailController.text = '';
                                  loginController.text = '';
                                  passwordController.text = '';
                                  Navigator.of(context).pop();
                                }
                              } else {
                                String error = '';
                                if (nameController.text.isEmpty) {
                                  error = 'Укажите Имя';
                                } else if (phoneController.text.isEmpty) {
                                  error = 'Укажите Номер телефона';
                                } else if (emailController.text.isEmpty) {
                                  error = 'Укажите Почту';
                                } else if (loginController.text.isEmpty) {
                                  error = 'Укажите Логин';
                                } else if (passwordController.text.isEmpty) {
                                  error = 'Укажите Пароль';
                                }
                                MessageDialogs().showAlert('Ошибка', error);
                              }
                            },
                            child: Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Изменить',
                                  style: CustomTextStyle.white15w600.copyWith(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: MediaQuery.of(context).viewInsets.bottom / 5,
                        // )
                      ],
                    )),
              );
            }),
          );
        },
      );
}
