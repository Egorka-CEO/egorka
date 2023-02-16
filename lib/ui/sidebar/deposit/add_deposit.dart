import 'package:egorka/core/bloc/deposit/deposit_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/filter_invoice.dart';
import 'package:egorka/model/invoice.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
// import 'package:tinkoff_sdk/tinkoff_sdk.dart';

class AddDeposit extends StatefulWidget {
  @override
  State<AddDeposit> createState() => _AddDepositState();
}

class _AddDepositState extends State<AddDeposit> {
  List<Invoice> depositHistory = [];

  TextEditingController controllerAmount = TextEditingController();

  final focusCoast = FocusNode();

  void loadDeposit() => BlocProvider.of<DepositBloc>(context)
      .add(LoadReplenishmentDepositEvent(Filter(type: 'Invoice')));

  @override
  void initState() {
    super.initState();
    loadDeposit();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 0.5,
        //   title: const Text(
        //     'Пополнение депозита',
        //     style: CustomTextStyle.black15w500,
        //   ),
        //   leading: GestureDetector(
        //     onTap: () => Navigator.of(context).pop(),
        //     child: const Icon(
        //       Icons.arrow_back_ios,
        //       color: Colors.red,
        //     ),
        //   ),
        //   backgroundColor: Colors.white,
        // ),
        body: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.w),
          child: Column(
            children: [
              // SizedBox(height: 20.h),
              // const Text(
              //   'Укажите сумму пополнения:',
              //   style: CustomTextStyle.black15w500,
              // ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  CustomTextField(
                    hintText: '15 000',
                    textEditingController: controllerAmount,
                    width: 150.w,
                    fillColor: Colors.white,
                    height: 45.h,
                    focusNode: focusCoast,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    formatters: [DepositFormatter()],
                  ),
                  SizedBox(width: 15.w),
                  const Text('руб'),
                  const Spacer(),
                  // GestureDetector(
                  //   onTap: () async {
                  //     const _TERMINAL_KEY = 'TERMINAL_KEY';
                  //     const _PASSWORD = 'PASSWORD';
                  //     const _PUBLIC_KEY = 'PUBLIC_KEY';

                  //     final TinkoffSdk acquiring = TinkoffSdk();

                  //     await acquiring.activate(
                  //         terminalKey: _TERMINAL_KEY,
                  //         password: _PASSWORD,
                  //         publicKey: _PUBLIC_KEY,
                  //         logging: true,
                  //         isDeveloperMode: true);
                  //     final resultPaymentSuccessful =
                  //         await TinkoffSdk().openPaymentScreen(
                  //       orderOptions: const OrderOptions(
                  //           orderId: '1',
                  //           amount: 10000,
                  //           title: "Название платежа",
                  //           description: "Описание платежа",
                  //           saveAsParent: false),
                  //       customerOptions: const CustomerOptions(
                  //           customerKey: "CUSTOMER_KEY",
                  //           email: "email@example.com",
                  //           checkType: CheckType.no),
                  //       featuresOptions: const FeaturesOptions(
                  //         useSecureKeyboard: true,
                  //         enableCameraCardScanner: false,
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     height: 45.h,
                  //     width: 60.w,
                  //     decoration: BoxDecoration(
                  //       color: Colors.red,
                  //       borderRadius: BorderRadius.circular(15.r),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         'TinkOFF',
                  //         style:
                  //             CustomTextStyle.white15w600.copyWith(fontSize: 12),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(width: 5.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () async {
                      if (controllerAmount.text.isEmpty) {
                        MessageDialogs()
                            .showAlert('Ошибка', 'Введите сумму пополнения');
                      } else {
                        MessageDialogs()
                            .showLoadDialog('Формирование депозита...');
                        final res = await Repository().createInvoice(
                            (double.parse(controllerAmount.text) * 100)
                                .round());
                        if (res != null) {
                          loadDeposit();
                        }
                        SmartDialog.dismiss();
                      }
                    },
                    child: Center(
                      child: Text(
                        'CФОРМИРОВАТЬ',
                        style:
                            CustomTextStyle.white15w600.copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'Ранее выставленные счета',
                style: CustomTextStyle.black15w700.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: BlocBuilder<DepositBloc, DepositState>(
                  builder: (context, snapshot) {
                    if (snapshot is DepositLoad) {
                      depositHistory.clear();
                      depositHistory.addAll(snapshot.list!);
                      return RefreshIndicator(
                        onRefresh: () async {
                          loadDeposit();
                        },
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: depositHistory.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                height: 50.h,
                                color: index % 2 == 0
                                    ? Colors.white
                                    : Colors.grey[200],
                                child: Row(
                                  children: [
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '№',
                                        style: CustomTextStyle.black15w500
                                            .copyWith(fontSize: 13.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Дата выставления',
                                        style: CustomTextStyle.black15w500
                                            .copyWith(fontSize: 13.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Сумма',
                                        style: CustomTextStyle.black15w500
                                            .copyWith(fontSize: 13.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                  ],
                                ),
                              );
                            }
                            return Container(
                              color: index % 2 == 0
                                  ? Colors.white
                                  : Colors.grey[200],
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 15.h),
                                  Row(
                                    children: [
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '${depositHistory[index - 1].iD!}-${depositHistory[index - 1].pIN!}',
                                          style: CustomTextStyle.black15w500
                                              .copyWith(fontSize: 13.sp),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          DateFormat.yMMMMd('ru').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              depositHistory[index - 1].date! *
                                                  1000,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                          style: CustomTextStyle.black15w500
                                              .copyWith(fontSize: 13.sp),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '${depositHistory[index - 1].amount} руб.',
                                          style: CustomTextStyle.black15w500
                                              .copyWith(fontSize: 13.sp),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 10.w),
                                      TextButton(
                                        onPressed: () async {
                                          MessageDialogs().showLoadDialog(
                                              'Скачивание и открытие...');
                                          String pdf = await Repository()
                                              .getPDF(
                                                  depositHistory[index - 1].iD!,
                                                  depositHistory[index - 1]
                                                      .pIN!);
                                          await OpenFile.open(pdf);
                                          SmartDialog.dismiss();
                                        },
                                        child: Text(
                                          'Скачать PDF',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      TextButton(
                                        onPressed: () async {
                                          MessageDialogs().showLoadDialog(
                                              'Скачивание и открытие...');
                                          String excel = await Repository()
                                              .getEXCEL(
                                                  depositHistory[index - 1].iD!,
                                                  depositHistory[index - 1]
                                                      .pIN!);
                                          await OpenFile.open(excel);
                                          SmartDialog.dismiss();
                                        },
                                        child: Text(
                                          'Скачать EXCEL',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: const Color.fromARGB(
                                                255, 71, 170, 74),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DepositFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > oldValue.text.length) {
      final alphanumeric = RegExp(r'([0-9])|([0-9][.])|([0-9][.][0-9]{2})$');
      if (alphanumeric.hasMatch(newValue.text)) {
        return newValue;
      }
      return oldValue;
    }
    return newValue;
  }
}
