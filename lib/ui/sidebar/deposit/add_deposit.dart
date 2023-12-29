import 'package:egorka/core/bloc/deposit/deposit_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/filter_invoice.dart';
import 'package:egorka/model/invoice.dart';
import 'package:egorka/widget/allert_dialog.dart';
import 'package:egorka/widget/custom_button.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:scale_button/scale_button.dart';

class AddDeposit extends StatefulWidget {
  int page;
  AddDeposit(this.page);
  @override
  State<AddDeposit> createState() => _AddDepositState();
}

class _AddDepositState extends State<AddDeposit> {
  List<Invoice> depositHistory = [];

  TextEditingController controllerAmount = TextEditingController();

  final focusCoast = FocusNode();
  bool focus = false;

  void loadDeposit() => BlocProvider.of<DepositBloc>(context)
      .add(LoadReplenishmentDepositEvent(Filter(type: 'Invoice'), widget.page));

  @override
  void initState() {
    focusCoast.addListener(() {
      if (focusCoast.hasFocus) {
        setState(() {
          focus = true;
        });
      } else {
        setState(() {
          focus = false;
        });
      }
    });
    super.initState();
    loadDeposit();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            // SizedBox(height: 30.h),
            Row(
              children: [
                // SizedBox(
                //   height: 48.h,
                //   child: CustomTextField(
                //     hintText: '15 000',
                //     textEditingController: controllerAmount,
                //     width: 150.w,
                //     auth: true,
                //     fillColor: Colors.white,
                //     height: 45.h,
                //     focusNode: focusCoast,
                //     contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                //     formatters: [DepositFormatter()],
                //   ),
                // ),
                // SizedBox(width: 10.w),
                Text(
                  'Депозит',
                  style: GoogleFonts.manrope(
                    fontSize: 25.h,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 40.w),
                // const Spacer(),
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    // width: 200.w,
                    child: CustomButton(
                      title: 'Сформировать счёт',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          barrierColor: const Color.fromRGBO(51, 51, 51, 0.24),
                          isScrollControlled: true,
                          useSafeArea: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24.r),
                            ),
                          ),
                          builder: (context) {
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              focusCoast.requestFocus();
                            });
                            return Container(
                              height: 600.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32.r),
                                  topRight: Radius.circular(32.r),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 16.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Сумма',
                                    style: GoogleFonts.manrope(
                                      fontSize: 17.h,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  SizedBox(
                                    height: 64.h,
                                    child: CustomTextField(
                                      hintText: '10000 ₽',
                                      auth: true,
                                      inputAction: TextInputAction.unspecified,
                                      textInputType: TextInputType.number,
                                      textEditingController: controllerAmount,
                                      focusNode: focusCoast,
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  CustomButton(
                                    title: 'Сформировать счет',
                                    onTap: () async {
                                      Navigator.pop(context);
                                      if (controllerAmount.text.isEmpty) {
                                        MessageDialogs().showAlert('Ошибка',
                                            'Введите сумму пополнения');
                                      } else {
                                        controllerAmount.text = '';
                                        MessageDialogs().showLoadDialog(
                                            'Формирование депозита...');
                                        final res = await Repository()
                                            .createInvoice((double.parse(
                                                        controllerAmount.text) *
                                                    100)
                                                .round());
                                        SmartDialog.dismiss();
                                        if (res != null) {
                                          loadDeposit();
                                          MessageDialogs().showAlert(
                                              'Успешно', 'Счет сформирован');
                                        }
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8.h),
                                  ScaleButton(
                                    bound: 0.02,
                                    duration: const Duration(milliseconds: 200),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 64.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        color: const Color.fromRGBO(
                                            245, 245, 245, 1),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Отмена',
                                        style: GoogleFonts.manrope(
                                          fontSize: 17.h,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                              94, 94, 94, 1),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                // GestureDetector(
                //   // bound: 0.02,
                //   // duration: const Duration(milliseconds: 200),
                //   onTap: () {
                //     // if (controllerAmount.text.isEmpty) {
                //     //   MessageDialogs()
                //     //       .showAlert('Ошибка', 'Введите сумму пополнения');
                //     // } else {
                //     //   MessageDialogs()
                //     //       .showLoadDialog('Формирование депозита...');
                //     //   final res = await Repository().createInvoice(
                //     //       (double.parse(controllerAmount.text) * 100)
                //     //           .round());
                //     //   SmartDialog.dismiss();
                //     //   if (res != null) {
                //     //     loadDeposit();
                //     //     MessageDialogs()
                //     //         .showAlert('Успешно', 'Счет сформирован');
                //     //   }
                //     // }
                //     print('123');

                //     // showBottomSheet(
                //     //   context: context,
                //     //   backgroundColor: Colors.white,
                //     //   builder: (context) {
                //     //     return Container(
                //     //       height: 306.h,
                //     //       width: double.infinity,
                //     //       decoration: BoxDecoration(
                //     //         borderRadius: BorderRadius.only(
                //     //           topLeft: Radius.circular(32.r),
                //     //           topRight: Radius.circular(32.r),
                //     //         ),
                //     //       ),
                //     //     );
                //     //   },
                //     // );
                //   },
                //   child: Container(
                //     height: 48.h,
                //     padding: EdgeInsets.symmetric(horizontal: 20.w),
                //     decoration: BoxDecoration(
                //       color: const Color.fromRGBO(255, 102, 102, 1),
                //       borderRadius: BorderRadius.circular(20.r),
                //     ),
                //     child: Center(
                //       child: Text(
                //         'Сформировать счёт',
                //         style: GoogleFonts.manrope(
                //           fontSize: 15.h,
                //           fontWeight: FontWeight.w500,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            // SizedBox(height: 20.h),
            // Text(
            //   'Ранее выставленные счета',
            //   style: CustomTextStyle.black15w700.copyWith(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
            SizedBox(height: 10.h),
            Expanded(
              child: BlocBuilder<DepositBloc, DepositState>(
                builder: (context, snapshot) {
                  if (snapshot is DepositLoad) {
                    if (widget.page != snapshot.page) {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                    depositHistory.clear();
                    depositHistory.addAll(snapshot.list!);
                    return RefreshIndicator(
                      color: const Color.fromRGBO(255, 102, 102, 1),
                      onRefresh: () async {
                        loadDeposit();
                      },
                      child: ListView.builder(
                        // physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: depositHistory.length,
                        padding: EdgeInsets.only(top: 20.h),
                        itemBuilder: (context, index) {
                          // if (index == 0) {
                          //   return Container(
                          //     height: 50.h,
                          //     color: Colors.white,
                          // child: Row(
                          //   children: [
                          //     SizedBox(width: 10.w),
                          //     Expanded(
                          //       flex: 3,
                          //       child: Text(
                          //         '№',
                          //         style: CustomTextStyle.black17w400
                          //             .copyWith(fontSize: 13.sp),
                          //         textAlign: TextAlign.center,
                          //       ),
                          //     ),
                          //     SizedBox(width: 10.w),
                          //     Expanded(
                          //       flex: 4,
                          //       child: Text(
                          //         'Дата выставления',
                          //         style: CustomTextStyle.black17w400
                          //             .copyWith(fontSize: 13.sp),
                          //         textAlign: TextAlign.center,
                          //       ),
                          //     ),
                          //     Expanded(
                          //       flex: 3,
                          //       child: Text(
                          //         'Сумма',
                          //         style: CustomTextStyle.black17w400
                          //             .copyWith(fontSize: 13.sp),
                          //         textAlign: TextAlign.center,
                          //       ),
                          //     ),
                          //     SizedBox(width: 10.w),
                          //   ],
                          // ),
                          // );
                          // }
                          return Container(
                            // color: index % 2 == 0
                            //     ? Colors.white
                            //     : Colors.grey[200],
                            margin: EdgeInsets.only(bottom: 16.h),
                            child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                // SizedBox(height: 15.h),
                                // Row(
                                //   children: [
                                //     SizedBox(width: 10.w),
                                //     Expanded(
                                //       flex: 3,
                                //       child: Text(
                                //         '${depositHistory[index - 1].iD!}-${depositHistory[index - 1].pIN!}',
                                //         style: CustomTextStyle.black17w400
                                //             .copyWith(fontSize: 13.sp),
                                //         textAlign: TextAlign.center,
                                //       ),
                                //     ),
                                //     Expanded(
                                //       flex: 4,
                                //       child: Text(
                                //         DateFormat.yMMMMd('ru').format(
                                //           DateTime.fromMillisecondsSinceEpoch(
                                //             depositHistory[index - 1].date! *
                                //                 1000,
                                //           ),
                                //         ),
                                //         textAlign: TextAlign.center,
                                //         style: CustomTextStyle.black17w400
                                //             .copyWith(fontSize: 13.sp),
                                //       ),
                                //     ),
                                //     Expanded(
                                //       flex: 3,
                                //       child: Text(
                                //         '${depositHistory[index - 1].amount} руб.',
                                //         style: CustomTextStyle.black17w400
                                //             .copyWith(fontSize: 13.sp),
                                //         textAlign: TextAlign.center,
                                //       ),
                                //     ),
                                //     SizedBox(width: 10.w),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     SizedBox(width: 10.w),
                                //     TextButton(
                                //       onPressed: () async {
                                //         MessageDialogs().showLoadDialog(
                                //             'Скачивание и открытие...');
                                //         String? pdf = await Repository()
                                //             .getPDF(
                                //                 depositHistory[index - 1].iD!,
                                //                 depositHistory[index - 1]
                                //                     .pIN!);
                                //         if (pdf != null)
                                //           await OpenFile.open(pdf);
                                //         SmartDialog.dismiss();
                                //       },
                                //       child: Text(
                                //         'Скачать PDF',
                                //         style: TextStyle(
                                //           color: Colors.red,
                                //           fontSize: 13.sp,
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(width: 10.w),
                                //     TextButton(
                                //       onPressed: () async {
                                //         MessageDialogs().showLoadDialog(
                                //             'Скачивание и открытие...');
                                //         String? excel = await Repository()
                                //             .getEXCEL(
                                //                 depositHistory[index - 1].iD!,
                                //                 depositHistory[index - 1]
                                //                     .pIN!);
                                //         if (excel != null)
                                //           await OpenFile.open(excel);
                                //         SmartDialog.dismiss();
                                //       },
                                //       child: Text(
                                //         'Скачать EXCEL',
                                //         style: TextStyle(
                                //           fontSize: 13.sp,
                                //           color: const Color.fromARGB(
                                //               255, 71, 170, 74),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(width: 10.w),
                                //   ],
                                // )
                                SizedBox(
                                  width: 194.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '+${depositHistory[index].amount?.split('.').first}₽',
                                        style: GoogleFonts.manrope(
                                          fontSize: 17.h,
                                          fontWeight: FontWeight.w700,
                                          color: const Color.fromRGBO(
                                              52, 199, 89, 1),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        DateFormat.yMMMMd('ru').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            depositHistory[index].date! * 1000,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.manrope(
                                          fontSize: 17.h,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                              177, 177, 177, 1),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '№${depositHistory[index].iD!}-${depositHistory[index].pIN!}',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.manrope(
                                          fontSize: 17.h,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                            177,
                                            177,
                                            177,
                                            1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      MessageDialogs().showLoadDialog(
                                          'Скачивание и открытие...');
                                      String? pdf = await Repository().getPDF(
                                          depositHistory[index].iD!,
                                          depositHistory[index].pIN!);
                                      if (pdf != null) await OpenFile.open(pdf);
                                      SmartDialog.dismiss();
                                    },
                                    child: Container(
                                      height: 42.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(32.r),
                                        color: Color.fromRGBO(245, 245, 245, 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'PDF',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.h,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromRGBO(
                                                94,
                                                94,
                                                94,
                                                1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          RotatedBox(
                                            quarterTurns: 135,
                                            child: SvgPicture.asset(
                                              'assets/icons/arrow-left.svg',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      MessageDialogs().showLoadDialog(
                                          'Скачивание и открытие...');
                                      String? excel = await Repository()
                                          .getEXCEL(depositHistory[index].iD!,
                                              depositHistory[index].pIN!);
                                      if (excel != null)
                                        await OpenFile.open(excel);
                                      SmartDialog.dismiss();
                                    },
                                    child: Container(
                                      height: 42.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(32.r),
                                        color: Color.fromRGBO(245, 245, 245, 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Excel',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.h,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromRGBO(
                                                94,
                                                94,
                                                94,
                                                1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          RotatedBox(
                                            quarterTurns: 135,
                                            child: SvgPicture.asset(
                                              'assets/icons/arrow-left.svg',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
