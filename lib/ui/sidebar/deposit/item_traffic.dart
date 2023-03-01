import 'dart:developer';
import 'dart:io';
import 'package:egorka/core/bloc/deposit/deposit_bloc.dart';
import 'package:egorka/model/filter_invoice.dart';
import 'package:egorka/model/invoice.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/date_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        style: TextStyle(color: Colors.orange, fontSize: 13.sp),
        textAlign: TextAlign.center,
      );
    } else if (str == 'Paid') {
      return Text(
        'Оплачено',
        style: TextStyle(color: Colors.green, fontSize: 13.sp),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        str,
        style: TextStyle(color: Colors.orange, fontSize: 13.sp),
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                SizedBox(
                  width: 90.w,
                  child: const Text('Дата с...'),
                ),
                GestureDetector(
                  onTap: () => showDateTime(true),
                  child: CustomTextField(
                    hintText: '10.01.2023',
                    focusNode: date1Focus,
                    textEditingController: controllerFrom,
                    textInputType: TextInputType.number,
                    width: 150.w,
                    enabled: false,
                    formatters: [DateCustomInputFormatter()],
                    fillColor: Colors.white,
                    height: 45.h,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                SizedBox(
                  width: 90.w,
                  child: const Text('Дата по...'),
                ),
                GestureDetector(
                  onTap: () => showDateTime(false),
                  child: CustomTextField(
                    hintText: '31.01.2023',
                    focusNode: date2Focus,
                    textEditingController: controllerTo,
                    textInputType: TextInputType.number,
                    width: 150.w,
                    enabled: false,
                    formatters: [DateCustomInputFormatter()],
                    fillColor: Colors.white,
                    height: 45.h,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  ),
                ),
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: () {
                    FilterDate filterDate = FilterDate(
                      from: dateFrom != null
                          ? DateFormat('yyyy-MM-dd').format(dateFrom!)
                          : '',
                      to: dateTo != null
                          ? DateFormat('yyyy-MM-dd').format(dateTo!)
                          : '',
                    );
                    widget.filter.filterDate = filterDate;
                    loadDeposit();
                  },
                  child: Container(
                    height: 45.w,
                    width: 45.w,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
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
                    onRefresh: () async => loadDeposit(),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: list.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            height: 50.h,
                            color: index % 2 == 0
                                ? Colors.white
                                : Colors.grey[200],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(width: 10.w),
                                Expanded(
                                    child: Text(
                                  '№',
                                  style: TextStyle(fontSize: 13.sp),
                                  textAlign: TextAlign.center,
                                )),
                                Expanded(
                                  child: Text(
                                    'Создано',
                                    style: TextStyle(fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Сумма',
                                    style: TextStyle(fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Статус',
                                    style: TextStyle(fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            print(
                                'object ${list[index - 1].iD} ${list[index - 1].pIN}');
                          },
                          child: Container(
                            height: 50.h,
                            color: index % 2 == 0
                                ? Colors.white
                                : Colors.grey[200],
                            child: Row(
                              children: [
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    '${list[index - 1].iD}-${list[index - 1].pIN}',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    DateFormat.yMd('ru').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        list[index - 1].dateStamp! * 1000,
                                      ),
                                    ),
                                    style: TextStyle(fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${list[index - 1].amount} ₽',
                                    style: TextStyle(fontSize: 13.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: statusOrder(list[index - 1].status!),
                                ),
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
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
