import 'dart:io';
import 'package:egorka/core/bloc/deposit/deposit_bloc.dart';
import 'package:egorka/helpers/app_colors.dart';
import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/model/filter_invoice.dart';
import 'package:egorka/model/invoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ItemTraffic extends StatefulWidget {
  Filter filter;
  int page;

  ItemTraffic(
    this.filter, {
    super.key,
    required this.page,
  });

  @override
  State<ItemTraffic> createState() => _ItemTrafficState();
}

class _ItemTrafficState extends State<ItemTraffic> {
  void loadDeposit() => BlocProvider.of<DepositBloc>(context)
      .add(LoadReplenishmentDepositEvent(widget.filter, widget.page));

  @override
  void initState() {
    super.initState();
    loadDeposit();
  }

  List<Invoice> list = [];

  final FocusNode date1Focus = FocusNode();
  final FocusNode date2Focus = FocusNode();

  DateTime? dateFrom;
  DateTime? dateTo;

  TextEditingController controllerFrom = TextEditingController();
  TextEditingController controllerTo = TextEditingController();

  Widget statusOrder(String str) {
    if (str == 'Active') {
      return Text(
        'Активно',
        style: GoogleFonts.manrope(
          fontSize: 16.h,
          fontWeight: FontWeight.w600,
          color: Colors.orange,
        ),
        textAlign: TextAlign.center,
      );
    } else if (str == 'Paid') {
      return Text(
        'Оплачено',
        style: GoogleFonts.manrope(
          fontSize: 16.h,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        str,
        style: GoogleFonts.manrope(
          fontSize: 16.h,
          fontWeight: FontWeight.w600,
          color: Colors.orange,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: AppConsts.textScalerStd,
      ),
      child: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10.w),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 90.w,
          //         child: const Text('Дата с...'),
          //       ),
          //       GestureDetector(
          //         onTap: () => showDateTime(true),
          //         child: CustomTextField(
          //           hintText: '10.01.2023',
          //           focusNode: date1Focus,
          //           textEditingController: controllerFrom,
          //           textInputType: TextInputType.number,
          //           width: 150.w,
          //           enabled: false,
          //           formatters: [DateCustomInputFormatter()],
          //           fillColor: Colors.white,
          //           height: 45.h,
          //           contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 15.h),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10.w),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 90.w,
          //         child: const Text('Дата по...'),
          //       ),
          //       GestureDetector(
          //         onTap: () => showDateTime(false),
          //         child: CustomTextField(
          //           hintText: '31.01.2023',
          //           focusNode: date2Focus,
          //           textEditingController: controllerTo,
          //           textInputType: TextInputType.number,
          //           width: 150.w,
          //           enabled: false,
          //           formatters: [DateCustomInputFormatter()],
          //           fillColor: Colors.white,
          //           height: 45.h,
          //           contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
          //         ),
          //       ),
          //       SizedBox(width: 20.w),
          //       GestureDetector(
          //         onTap: () {
          //           FilterDate filterDate = FilterDate(
          //             from: dateFrom != null
          //                 ? DateFormat('yyyy-MM-dd').format(dateFrom!)
          //                 : '',
          //             to: dateTo != null
          //                 ? DateFormat('yyyy-MM-dd').format(dateTo!)
          //                 : '',
          //           );
          //           widget.filter.filterDate = filterDate;
          //           loadDeposit();
          //         },
          //         child: Container(
          //           height: 45.w,
          //           width: 45.w,
          //           decoration: BoxDecoration(
          //             color: Colors.red,
          //             borderRadius: BorderRadius.circular(15.r),
          //           ),
          //           child: const Center(
          //             child: Icon(
          //               Icons.search,
          //               color: Colors.white,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 20.h),
          Expanded(
            child: BlocBuilder<DepositBloc, DepositState>(
              builder: (context, snapshot) {
                if (snapshot is DepositLoad) {
                  if (widget.page != snapshot.page) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  list.clear();
                  list.addAll(snapshot.list!);
                  return RefreshIndicator(
                    color: const Color.fromRGBO(255, 102, 102, 1),
                    onRefresh: () async => loadDeposit(),
                    child: ListView.builder(
                      // physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 20.h),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 77.h,
                            margin: EdgeInsets.only(bottom: 10.h),
                            child: Row(
                              children: [
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${list[index].amount?.split('.').first}₽',
                                      style: GoogleFonts.manrope(
                                        fontSize: 17.h,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      DateFormat.yMd('ru').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          list[index].dateStamp! * 1000,
                                        ),
                                      ),
                                      style: GoogleFonts.manrope(
                                        fontSize: 17.h,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(
                                            177, 177, 177, 1),
                                      ),
                                    ),
                                    Text(
                                      '${list[index].iD}-${list[index].pIN}',
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
                                // Expanded(
                                //   child: Text(
                                //     '${list[index].iD}-${list[index].pIN}',
                                //     style: TextStyle(
                                //         color: Colors.red, fontSize: 13.sp),
                                //     textAlign: TextAlign.center,
                                //   ),
                                // ),
                                // Expanded(
                                //   child: Text(
                                //     DateFormat.yMd('ru').format(
                                //       DateTime.fromMillisecondsSinceEpoch(
                                //         list[index].dateStamp! * 1000,
                                //       ),
                                //     ),
                                //     style: TextStyle(fontSize: 13.sp),
                                //     textAlign: TextAlign.center,
                                //   ),
                                // ),
                                // Expanded(
                                //   child: Text(
                                //     '${list[index].amount} ₽',
                                //     style: TextStyle(fontSize: 13.sp),
                                //     textAlign: TextAlign.center,
                                //   ),
                                // ),

                                const Expanded(child: SizedBox()),
                                Container(
                                    width: 200.w,
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: AppColors.grey,
                                    ),
                                    alignment: Alignment.center,
                                    child: statusOrder(list[index].status!)),
                                SizedBox(width: 10.w),
                              ],
                            ),
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
    );
  }

  void showDateTime(bool flag) async {
    if (Platform.isAndroid) {
      final value = await showDialog(
          context: context,
          builder: (context) {
            return DatePickerDialog(
              initialDate: DateTime.now(),
              firstDate: DateTime(2010),
              lastDate: DateTime(2030),
            );
          });
      if (flag) {
        controllerFrom.text = DateFormat('dd.MM.yyyy').format(value);
        dateFrom = value;
      } else {
        controllerTo.text = DateFormat('dd.MM.yyyy').format(value);
        dateTo = value;
      }
    } else {
      showDialog(
        useSafeArea: false,
        barrierColor: Colors.black.withOpacity(0.4),
        context: context,
        builder: (ctx) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: AppConsts.textScalerStd,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[200],
                      child: Row(
                        children: [
                          const Spacer(),
                          CupertinoButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text(
                              'Готово',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200.h,
                      color: Colors.grey[200],
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        onDateTimeChanged: (value) {
                          if (flag) {
                            controllerFrom.text =
                                DateFormat('dd.MM.yyyy').format(value);
                            dateFrom = value;
                          } else {
                            controllerTo.text =
                                DateFormat('dd.MM.yyyy').format(value);
                            dateTo = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
