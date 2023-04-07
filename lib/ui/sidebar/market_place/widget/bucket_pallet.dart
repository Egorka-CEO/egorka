import 'dart:async';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/formatter_slider.dart';
import 'package:egorka/widget/tip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget bucket(
  BuildContext context,
  Function scrolling,
  Function calcOrder,
  double minSliderBucket,
  double maxSliderBucket,
  StreamController<int> countBucket,
  StreamController<int> bucketCountLess15kg,
  StreamController<int> bucketCountMore15kg,
  TextEditingController countPalletControllerLess15kg,
  TextEditingController countPalletControllerMore15kg,
  TextEditingController countBucketController,
  FocusNode bucketFocus,
  Function setState,
  TabController tabController,
  GlobalKey countBucketKey,
  double valueBucket,
) {
  return Row(
    children: [
      Expanded(
        child: CustomTextField(
          onTap: () => scrolling(),
          onFieldSubmitted: (value) => calcOrder(),
          onChanged: (value) {
            int? res = int.tryParse(value);
            if (res != null) {
              countBucket.add(res);
            } else {
              countBucket.add(0);
            }
            countPalletControllerLess15kg.text = '';
            countPalletControllerMore15kg.text = '';
            bucketCountLess15kg.add(0);
            bucketCountMore15kg.add(0);
            setState();
          },
          focusNode: bucketFocus,
          height: 45.h,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          fillColor: Colors.white,
          hintText: '0',
          textInputType: TextInputType.number,
          formatters: [CustomInputFormatterSlider(maxSliderBucket)],
          textEditingController: countBucketController,
        ),
      ),
      SizedBox(width: 10.w),
      GestureDetector(
        onTap: () => showTipBucket(
          tabController.index == 0
              ? 'Если у вас больше 10 коробок — заказывайте доставку на паллете.\nИз расчета учитывается 1 коробка = 60х40х40. Если у вас несколько поставок россыпью в разные города, как это часто бывает у МП OZON – оформляйте коробочную доставку указав кол-во мест/коробок. Подробная информация и цены представлены на сайте.'
              : 'Если у вас больше 10 коробок — заказывайте доставку на паллете.\nИз расчета учитывается 1 коробка = 60х40х40. В этот размер вы можете уместить, например, 15 маленьких коробок с каждым товаром. Подробная информация и цены представлены на сайте.',
          context,
          getWidgetPosition(countBucketKey),
          (index) {
            Navigator.pop(context);
          },
        ),
        child: Icon(
          Icons.help_outline_outlined,
          key: countBucketKey,
          color: Colors.red,
        ),
      ),
      Expanded(
        flex: 2,
        child: Slider(
          min: minSliderBucket,
          max: maxSliderBucket,
          activeColor: Colors.red,
          inactiveColor: Colors.grey[300],
          thumbColor: Colors.white,
          value: valueBucket,
          onChangeEnd: (value) => calcOrder(loadingAnimation: false),
          onChanged: (value) {
            countBucket.add(value.toInt());
            countBucketController.text = value.toInt().toString();
            countPalletControllerLess15kg.text = '';
            countPalletControllerMore15kg.text = '';
            bucketCountLess15kg.add(0);
            bucketCountMore15kg.add(0);
            setState(() {});
          },
        ),
      )
    ],
  );
}

Widget pallet(
  BuildContext context,
  Function scrolling,
  Function calcOrder,
  double minSliderPallet,
  double maxSliderPallet,
  StreamController<int> countPallet,
  StreamController<int> additionalPalletCount,
  StreamController<int> bucketCountMore15kg,
  TextEditingController countPalletControllerLess15kg,
  TextEditingController countPalletControllerMore,
  TextEditingController countPalletController,
  FocusNode palletFocus,
  Function setState,
  TabController tabController,
  GlobalKey countPalletKey,
  double valuePallet,
) {
  return Row(
    children: [
      Expanded(
        child: CustomTextField(
          onTap: () => scrolling(),
          onFieldSubmitted: (value) => calcOrder(),
          onChanged: (value) {
            int? res = int.tryParse(value);
            if (res != null) {
              countPallet.add(res);
            } else {
              countPallet.add(0);
            }
            countPalletControllerMore.text = '';
            additionalPalletCount.add(0);
            setState();
          },
          maxLines: 1,
          focusNode: palletFocus,
          height: 45.h,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          fillColor: Colors.white,
          hintText: '0',
          textInputType: TextInputType.number,
          formatters: [CustomInputFormatterSlider(maxSliderPallet)],
          textEditingController: countPalletController,
        ),
      ),
      SizedBox(width: 10.w),
      GestureDetector(
        onTap: () => showTipPallet(
          context,
          getWidgetPosition(countPalletKey),
          (index) {
            Navigator.pop(context);
          },
        ),
        child: Icon(
          Icons.help_outline_outlined,
          key: countPalletKey,
          color: Colors.red,
        ),
      ),
      Expanded(
        flex: 2,
        child: Slider(
          min: minSliderPallet,
          max: maxSliderPallet,
          activeColor: Colors.red,
          inactiveColor: Colors.grey[300],
          thumbColor: Colors.white,
          value: valuePallet,
          onChangeEnd: (value) => calcOrder(loadingAnimation: false),
          onChanged: (value) {
            countPallet.add(value.toInt());
            countPalletController.text = value.toInt().toString();
            countPalletControllerMore.text = '';
            additionalPalletCount.add(0);
            setState();
          },
        ),
      )
    ],
  );
}
