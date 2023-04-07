import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget historyAppBar(
  BuildContext context,
  String status,
  Function onCancel,
) {
  return Padding(
    padding: EdgeInsets.all(20.w),
    child: Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.red,
                ),
              ),
              const Align(
                child: Text(
                  'История',
                  style: CustomTextStyle.black17w400,
                ),
              ),
              if (status != 'Выполнено' &&
                  status != 'Отменено' &&
                  status != 'Отказано' &&
                  status != 'Оплачено' &&
                  status != 'Ошибка')
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text('Подтвердить?'),
                              content:
                                  const Text('Текущая заявка будет отменена'),
                              actions: [
                                CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    textStyle:
                                        const TextStyle(color: Colors.red),
                                    isDefaultAction: true,
                                    child: const Text("Отменить")),
                                CupertinoDialogAction(
                                    onPressed: () async => onCancel(),
                                    isDefaultAction: true,
                                    child: const Text("Подтвердить"))
                              ],
                            );
                          });
                    },
                    child: const Text(
                      'Отмена',
                      style: CustomTextStyle.red15,
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    ),
  );
}
