import 'package:blur/blur.dart';
import 'package:egorka/core/bloc/deposit/deposit_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/mini_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';

class HistoryOrdersPage extends StatefulWidget {
  HistoryOrdersPage({super.key, required this.coast});

  CreateFormModel coast;

  @override
  State<HistoryOrdersPage> createState() => _HistoryOrdersPageState();
}

class _HistoryOrdersPageState extends State<HistoryOrdersPage> {
  bool resPayed = false;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(widget.coast.result.Date * 1000);

    String day = DateFormat('dd').format(dateTime);
    String pickDay = DateFormat.EEEE('ru').format(dateTime);
    String pickDate =
        '$pickDay, ${dateTime.day} ${DateFormat.MMMM('ru').format(dateTime)} с ${dateTime.hour}:${dateTime.minute} до ${dateTime.hour == 23 ? dateTime.hour : dateTime.hour + 1}:${dateTime.minute}';

    return Material(
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back_outlined,
                                size: 30.h,
                                color: Colors.red,
                              ),
                            ),
                            const Align(
                              child: Text(
                                'История',
                                style: CustomTextStyle.black15w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.coast.result.ID} / $day ${DateFormat.MMMM('ru').format(dateTime)}',
                            style: CustomTextStyle.black15w500,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            height: 250.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.r),
                              ),
                              child: MiniMapView(
                                  locations: widget.coast.result.locations),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: const [
                              Text(
                                'Дата и время забора',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            children: [
                              SizedBox(width: 10.h),
                              Text(
                                pickDate,
                                style: CustomTextStyle.black15w500,
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            children: const [
                              Text(
                                'Маршрут',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.coast.result.locations.length,
                            itemBuilder: ((context, index) {
                              if (index !=
                                  widget.coast.result.locations.length - 1) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/from.png',
                                              height: 25.h,
                                            ),
                                            SizedBox(width: 15.w),
                                            Flexible(
                                              child: Text(
                                                widget
                                                    .coast
                                                    .result
                                                    .locations[index]
                                                    .point
                                                    .Address,
                                                style:
                                                    CustomTextStyle.black15w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_downward_rounded,
                                              color: Colors.grey[400],
                                            ),
                                            SizedBox(width: 15.w),
                                            GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .pushNamed(
                                                      AppRoute
                                                          .historyDetailsOrder,
                                                      arguments: [
                                                    TypeAdd.sender,
                                                    1,
                                                    widget.coast.result
                                                        .locations[index]
                                                  ]),
                                              child: const Text(
                                                'Посмотреть детали',
                                                style: CustomTextStyle.red15,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/to.png',
                                            height: 25.h,
                                          ),
                                          SizedBox(width: 15.w),
                                          Flexible(
                                            child: Text(
                                              widget
                                                  .coast
                                                  .result
                                                  .locations[index]
                                                  .point
                                                  .Address,
                                              style:
                                                  CustomTextStyle.black15w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.flag,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(width: 15.w),
                                          GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed(
                                                    AppRoute
                                                        .historyDetailsOrder,
                                                    arguments: [
                                                  TypeAdd.receiver,
                                                  1,
                                                  widget.coast.result
                                                      .locations[index]
                                                ]),
                                            child: const Text(
                                              'Посмотреть детали',
                                              style: CustomTextStyle.red15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            children: const [
                              Text(
                                'Кто везёт',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100.r),
                                    child: Image.asset(
                                      'assets/images/deliver.jpeg',
                                      height: 80.h,
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Евгений',
                                        style: CustomTextStyle.black15w700,
                                      ),
                                      SizedBox(height: 10.h),
                                      const Text(
                                        'Румянцев',
                                        style: CustomTextStyle.black15w700,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 80.w,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/ic_leg.png',
                                          color: Colors.red,
                                          height: 50.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Lada Largus / У081МО799',
                                        style: CustomTextStyle.black15w700,
                                      ),
                                      SizedBox(height: 10.h),
                                      const Text(
                                        'Цвет: белый',
                                        style: CustomTextStyle.black15w700,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            children: const [
                              Text(
                                'Сводная информация',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              SizedBox(width: 10.w),
                              const Text(
                                'Объявленная ценность',
                                style: CustomTextStyle.grey15bold,
                              ),
                              const Spacer(),
                              const Text(
                                '1000 ₽',
                                style: CustomTextStyle.black15w700,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              SizedBox(width: 10.w),
                              const Text(
                                'Что везем',
                                style: CustomTextStyle.grey15bold,
                              ),
                              const Spacer(),
                              const Text(
                                'Зарядка',
                                style: CustomTextStyle.black15w700,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              SizedBox(width: 10.w),
                              const Text(
                                'Стоимость заказа',
                                style: CustomTextStyle.grey15bold,
                              ),
                              const Spacer(),
                              const Text(
                                '562 ₽',
                                style: CustomTextStyle.black15w700,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              SizedBox(width: 10.w),
                              const Text(
                                'Способ оплаты',
                                style: CustomTextStyle.grey15bold,
                              ),
                              const Spacer(),
                              const Text(
                                'Депозит',
                                style: CustomTextStyle.black15w700,
                              ),
                            ],
                          ),
                          SizedBox(height: 200.h)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (!resPayed)
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Blur(blur: 2.5, child: Container(height: 120.h)),
                  Padding(
                    padding: EdgeInsets.all(30.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Оплатить:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: () async {
                            final invoice =
                                BlocProvider.of<DepositBloc>(context)
                                    .invoiceModel;
                            if (invoice != null) {
                              MessageDialogs().showLoadDialog(
                                  'Производится оплата с вашего депозита');
                              resPayed = await Repository().paymentDeposit(
                                  invoice.result!.invoice!.iD!,
                                  invoice.result!.invoice!.pIN!);
                              SmartDialog.dismiss();
                              setState(() {});
                            }
                          },
                          child: const Text('Депозит'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: const Text('Карта'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
