import 'package:egorka/model/traffic_deposit.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ItemTraffic extends StatelessWidget {
  final depositTraffic = [
    DepositTraffic(
      number: 1022,
      rubles: '100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '1002',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '4100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '6100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '1002',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '4100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '6100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '1002',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '4100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
    DepositTraffic(
      number: 1022,
      rubles: '6100',
      comment: 'Доставка: 110793',
      datePayment: DateTime(2022, 8, 12),
      dateCreation: DateTime(2022, 8, 12),
      status: 'Paid',
    ),
  ];

  final FocusNode date1Focus = FocusNode();
  final FocusNode date2Focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            children: [
              SizedBox(
                width: 70.w,
                child: const Text('Дата с...'),
              ),
              CustomTextField(
                hintText: 'ДД.ММ.ГГГГ',
                focusNode: date1Focus,
                textEditingController: TextEditingController(),
                textInputType: TextInputType.number,
                width: 120.w,
                fillColor: Colors.white,
                height: 45.h,
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
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
              CustomTextField(
                hintText: 'ДД.ММ.ГГГГ',
                focusNode: date1Focus,
                textEditingController: TextEditingController(),
                textInputType: TextInputType.number,
                width: 120.w,
                fillColor: Colors.white,
                height: 45.h,
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
              ),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {},
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
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: depositTraffic.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  height: 50.h,
                  color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                  child: Row(
                    children: [
                      SizedBox(width: 10.w),
                      const Expanded(child: Text('№')),
                      const Expanded(
                        child: Text(
                          'Создано',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Оплачено',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Комментарий',
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
                color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                child: Row(
                  children: [
                    SizedBox(width: 10.w),
                    Expanded(
                        child: Text(
                      '${depositTraffic[index - 1].number}',
                      style: const TextStyle(color: Colors.red),
                    )),
                    Expanded(
                        child: Text(
                      DateFormat.yMd('ru')
                          .format(depositTraffic[index - 1].dateCreation),
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      DateFormat.yMd('ru')
                          .format(depositTraffic[index - 1].datePayment),
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      depositTraffic[index - 1].comment,
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      '${depositTraffic[index - 1].rubles} руб.',
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      depositTraffic[index - 1].status,
                      style: const TextStyle(color: Colors.orange),
                      textAlign: TextAlign.center,
                    )),
                    SizedBox(width: 10.w),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
