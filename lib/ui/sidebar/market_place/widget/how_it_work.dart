import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/tip_dialog.dart';
import 'package:flutter/material.dart';

Widget howItWork(
  BuildContext context,
  GlobalKey howItWorkKey,
) {
  return GestureDetector(
    onTap: () => showTipWork(
      context,
      getWidgetPosition(howItWorkKey),
      (index) {
        Navigator.pop(context);
      },
    ),
    child: Text(
      'Как это работает?',
      key: howItWorkKey,
      style: CustomTextStyle.red15,
    ),
  );
}
