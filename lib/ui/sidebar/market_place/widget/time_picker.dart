import 'dart:io';

import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/tip_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

Widget timePicker(
  BuildContext context,
  GlobalKey whenTakeKey,
  TextEditingController startOrderController,
  DateTime? time,
  Function(DateTime?) onDone,
) {
  return Container(
    height: 64.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(
        width: 1,
        color: const Color.fromRGBO(220, 220, 220, 1),
      ),
    ),
    child: Row(
      children: [
        SizedBox(width: 10.w),
        Expanded(
          child: GestureDetector(
            onTap: () => showDateTime(
              context,
              startOrderController,
              time,
              onDone,
            ),
            child: CustomTextField(
              height: 45.h,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              fillColor: Colors.white,
              hintText: '...',
              enabled: false,
              textEditingController: startOrderController,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
            onTap: () => showTipWhenTake(
                  context,
                  getWidgetPosition(whenTakeKey),
                  (index) {
                    Navigator.pop(context);
                  },
                ),
            child: SvgPicture.asset(
              key: whenTakeKey,
              'assets/icons/calendar.svg',
            )),
        SizedBox(width: 20.w),
      ],
    ),
  );
}

void showDateTime(
  BuildContext context,
  TextEditingController startOrderController,
  DateTime? time,
  Function(DateTime?) onDone,
) async {
  // time = null;
  DateTime initialData;

  if (DateTime.now().hour >= 15) {
    initialData = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 2);
  } else {
    initialData = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  }
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
      startOrderController.text = DateFormat('dd.MM.yyyy').format(temp);
      time = temp;
      onDone(time);
    }
  } else {
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (ctx) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: AppConsts.textScalerStd),
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
                            if (time == null) {
                              time = initialData;
                              startOrderController.text =
                                  DateFormat('dd.MM.yyyy').format(time!);
                            }
                            Navigator.of(ctx).pop();
                            onDone(time);
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
                        startOrderController.text =
                            DateFormat('dd.MM.yyyy').format(value);
                        time = value;
                      },
                      minimumYear: DateTime.now().year,
                      initialDateTime: initialData,
                      minimumDate: initialData,
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
