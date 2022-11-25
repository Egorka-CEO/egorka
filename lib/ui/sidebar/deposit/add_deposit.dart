import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/deposit_history.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddDeposit extends StatelessWidget {
  final depositHistory = [
    DepositHistory(
      number: 1022,
      date: DateTime(2022, 8, 12),
      rubles: '100',
    ),
    DepositHistory(
      number: 3232,
      date: DateTime(2022, 8, 17),
      rubles: '4777',
    ),
    DepositHistory(
      number: 3444,
      date: DateTime(2022, 8, 20),
      rubles: '10000',
    ),
    DepositHistory(
      number: 1111,
      date: DateTime(2022, 8, 21),
      rubles: '3999999',
    ),
    DepositHistory(
      number: 3222,
      date: DateTime(2022, 8, 01),
      rubles: '500',
    ),
    DepositHistory(
      number: 0033,
      date: DateTime(2022, 8, 05),
      rubles: '9012',
    ),
    DepositHistory(
      number: 4333,
      date: DateTime(2022, 9, 10),
      rubles: '1111',
    ),
    DepositHistory(
      number: 1022,
      date: DateTime(2022, 9, 14),
      rubles: '100',
    ),
    DepositHistory(
      number: 3232,
      date: DateTime(2022, 9, 15),
      rubles: '4777',
    ),
    DepositHistory(
      number: 3444,
      date: DateTime(2022, 9, 18),
      rubles: '10000',
    ),
    DepositHistory(
      number: 1111,
      date: DateTime(2022, 9, 25),
      rubles: '3999999',
    ),
    DepositHistory(
      number: 3222,
      date: DateTime(2022, 9, 28),
      rubles: '500',
    ),
    DepositHistory(
      number: 0033,
      date: DateTime(2022, 9, 29),
      rubles: '9012',
    ),
    DepositHistory(
      number: 4333,
      date: DateTime(2022, 10, 01),
      rubles: '1111',
    ),
    DepositHistory(
      number: 1022,
      date: DateTime(2022, 10, 04),
      rubles: '100',
    ),
    DepositHistory(
      number: 3232,
      date: DateTime(2022, 10, 05),
      rubles: '4777',
    ),
    DepositHistory(
      number: 3444,
      date: DateTime(2022, 10, 07),
      rubles: '10000',
    ),
    DepositHistory(
      number: 1111,
      date: DateTime(2022, 10, 09),
      rubles: '3999999',
    ),
    DepositHistory(
      number: 3222,
      date: DateTime(2022, 10, 10),
      rubles: '500',
    ),
    DepositHistory(
      number: 0033,
      date: DateTime(2022, 10, 11),
      rubles: '9012',
    ),
    DepositHistory(
      number: 4333,
      date: DateTime(2022, 10, 11),
      rubles: '1111',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          'Пополнение депозита',
          style: CustomTextStyle.black15w500,
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
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            const Text(
              'Укажите сумму пополнения:',
              style: CustomTextStyle.black15w500,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                CustomTextField(
                  hintText: '15 000',
                  textEditingController: TextEditingController(),
                  textInputType: TextInputType.number,
                  width: 150.w,
                  fillColor: Colors.white,
                  height: 45.h,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  formatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                  ],
                ),
                SizedBox(width: 15.w),
                const Text('руб'),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 45.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Center(
                      child: Text(
                        'ПОПОЛНИТЬ',
                        style:
                            CustomTextStyle.white15w600.copyWith(fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              'Ранее выставленные счета',
              style: CustomTextStyle.black15w700.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: depositHistory.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: 50.h,
                      color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                      child: Row(
                        children: [
                          SizedBox(width: 10.w),
                          const Expanded(flex: 2, child: Text('№')),
                          SizedBox(width: 10.w),
                          const Expanded(
                              flex: 4, child: Text('Дата выставления')),
                          const Expanded(flex: 3, child: Text('Сумма')),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    );
                  }
                  return Container(
                    height: 45.h,
                    color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                    child: Row(
                      children: [
                        SizedBox(width: 10.w),
                        Expanded(
                            flex: 2,
                            child: Text('${depositHistory[index - 1].number}')),
                        Expanded(
                            flex: 4,
                            child: Text(DateFormat.yMMMMd('ru')
                                .format(depositHistory[index - 1].date))),
                        Expanded(
                            flex: 3,
                            child: Text(
                                '${depositHistory[index - 1].rubles} руб.')),
                        SizedBox(width: 10.w),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
