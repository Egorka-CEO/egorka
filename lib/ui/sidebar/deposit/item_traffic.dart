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

  ItemTraffic(this.filter, {super.key});

  @override
  State<ItemTraffic> createState() => _ItemTrafficState();
}

class _ItemTrafficState extends State<ItemTraffic> {
  void loadDeposit() => BlocProvider.of<DepositBloc>(context)
      .add(LoadReplenishmentDepositEvent(widget.filter));

  @override
  void initState() {
    super.initState();
    loadDeposit();
  }

  List<Invoice> list = [];

  final FocusNode date1Focus = FocusNode();

  final FocusNode date2Focus = FocusNode();

  TextEditingController controllerFrom = TextEditingController();
  TextEditingController controllerTo = TextEditingController();

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
                  width: 70.w,
                  child: const Text('Дата с...'),
                ),
                GestureDetector(
                  onTap: () => showDateTime(true),
                  child: CustomTextField(
                    hintText: '2023-01-10',
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
                  width: 70.w,
                  child: const Text('Дата по...'),
                ),
                GestureDetector(
                  onTap: () => showDateTime(false),
                  child: CustomTextField(
                    hintText: '2023-01-31',
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
                      from: controllerFrom.text,
                      to: controllerTo.text,
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
                                const Expanded(
                                    child: Text(
                                  '№',
                                  textAlign: TextAlign.center,
                                )),
                                const Expanded(
                                  child: Text(
                                    'Создано',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    'Сумма',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    'Статус',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          );
                        }
                        return Container(
                          height: 50.h,
                          color:
                              index % 2 == 0 ? Colors.white : Colors.grey[200],
                          child: Row(
                            children: [
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  '${list[index - 1].iD}${list[index - 1].pIN}',
                                  style: const TextStyle(color: Colors.red),
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
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${list[index - 1].amount} ₽',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  list[index - 1].status!,
                                  style: const TextStyle(color: Colors.orange),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(width: 10.w),
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
      if (value != null) {
        final TimeOfDay? timePicked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: TimeOfDay.now().hour,
            minute: TimeOfDay.now().minute,
          ),
        );
        final DateTime temp = DateTime(
          value.year,
          value.month,
          value.day,
          timePicked != null ? timePicked.hour : 0,
          timePicked != null ? timePicked.minute : 0,
        );
        if (flag) {
          controllerFrom.text = DateFormat('yyyy-MM-dd').format(temp);
        } else {
          controllerTo.text = DateFormat('yyyy-MM-dd').format(temp);
        }
      }
    } else {
      showDialog(
        barrierDismissible: false,
        useSafeArea: false,
        barrierColor: Colors.transparent,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Готово'),
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
                                DateFormat('yyyy-MM-dd').format(value);
                          } else {
                            controllerTo.text =
                                DateFormat('yyyy-MM-dd').format(value);
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
