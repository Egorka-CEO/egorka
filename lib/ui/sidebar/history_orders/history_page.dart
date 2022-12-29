import 'package:blur/blur.dart';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/info_form.dart';
import 'package:egorka/model/status_order.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/mini_map.dart';
import 'package:flutter/cupertino.dart';
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
  InfoForm? formOrder;
  StatusOrder? statusOrder = StatusOrder.rejected;
  bool resPaid = false;
  DateTime? parseDate;
  DateTime? dateTime;
  String day = '';
  String pickDay = '';
  String pickDate = '';
  Color colorStatus = Colors.red;
  String status = 'Ошибка';

  @override
  void initState() {
    super.initState();
    getForm();
  }

  void getForm() async {
    formOrder = await Repository().infoForm(
        widget.coast.result.RecordNumber.toString(),
        widget.coast.result.RecordPIN.toString());

    parseDate = DateTime.parse(formOrder!.result!.recordDate!);

    day = DateFormat('dd').format(parseDate!);
    pickDay = DateFormat.EEEE('ru').format(parseDate!);
    pickDate =
        '$pickDay, ${parseDate!.day} ${DateFormat.MMMM('ru').format(parseDate!)} с ${parseDate!.hour}:${parseDate!.minute} до ${parseDate!.hour == 23 ? parseDate!.hour : parseDate!.hour + 1}:${parseDate!.minute}';

    if (formOrder!.result!.status == 'Drafted') {
      statusOrder = StatusOrder.drafted;
      colorStatus = Colors.orange;
      status = 'Черновик';
    } else if (formOrder!.result!.status == 'Booked') {
      resPaid = formOrder!.result!.payStatus! == 'Paid' ? true : false;
      colorStatus = resPaid ? Colors.green : Colors.orange;
      statusOrder = StatusOrder.booked;
      status = resPaid ? 'Оплачено' : 'Активно';
    } else if (formOrder!.result!.status == 'Completed') {
      statusOrder = StatusOrder.completed;
      colorStatus = Colors.green;
      resPaid = true;
      status = 'Выполнено';
    } else if (formOrder!.result!.status == 'Cancelled') {
      statusOrder = StatusOrder.cancelled;
      colorStatus = Colors.red;
      resPaid = true;
      status = 'Отменено';
    } else if (formOrder!.result!.status == 'Rejected') {
      statusOrder = StatusOrder.rejected;
      colorStatus = resPaid ? Colors.green : Colors.orange;
      resPaid = true;
      status = 'Отказано';
    } else if (formOrder!.result!.status == 'Error') {
      statusOrder = StatusOrder.error;
      colorStatus = Colors.red;
      resPaid = true;
      status = 'Ошибка';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        bottom: false,
        child: formOrder == null
            ? const Center(child: CupertinoActivityIndicator())
            : Stack(
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
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () async {
                                        MessageDialogs()
                                            .showLoadDialog('Отмена заявки');
                                        bool res = await Repository().cancelForm(
                                            '${formOrder!.result!.recordNumber}',
                                            '${formOrder!.result!.recordPIN}');
                                        SmartDialog.dismiss();
                                        BlocProvider.of<HistoryOrdersBloc>(
                                                context)
                                            .add(GetListOrdersEvent());
                                        res
                                            ? MessageDialogs().completeDialog(
                                                text: 'Заявка отменена')
                                            : MessageDialogs().errorDialog(
                                                text: 'Ошибка отмены');
                                        resPaid = res;
                                        setState(() {});
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
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: colorStatus,
                                  ),
                                  child: Text(
                                    status,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  '${formOrder!.result?.invoices!.first.iD}${formOrder!.result?.invoices!.first.pIN} / $day ${DateFormat.MMMM('ru').format(parseDate!)}',
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
                                        locations:
                                            widget.coast.result.locations),
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
                                  itemCount:
                                      formOrder!.result!.locations!.length,
                                  itemBuilder: ((context, index) {
                                    if (index !=
                                        formOrder!.result!.locations!.length -
                                            1) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 10.h),
                                        child: Container(
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.r),
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
                                                      formOrder!
                                                          .result!
                                                          .locations![index]
                                                          .point!
                                                          .address!,
                                                      style: CustomTextStyle
                                                          .black15w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15.h),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_downward_rounded,
                                                    color: Colors.grey[400],
                                                  ),
                                                  SizedBox(width: 15.w),
                                                  GestureDetector(
                                                    onTap: () => Navigator.of(
                                                            context)
                                                        .pushNamed(
                                                            AppRoute
                                                                .historyDetailsOrder,
                                                            arguments: [
                                                          TypeAdd.sender,
                                                          1,
                                                          formOrder!.result!
                                                              .locations![index]
                                                        ]),
                                                    child: const Text(
                                                      'Посмотреть детали',
                                                      style:
                                                          CustomTextStyle.red15,
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
                                          borderRadius:
                                              BorderRadius.circular(20.r),
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
                                                    formOrder!
                                                        .result!
                                                        .locations![index]
                                                        .point!
                                                        .address!,
                                                    style: CustomTextStyle
                                                        .black15w500,
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
                                                  onTap: () => Navigator.of(
                                                          context)
                                                      .pushNamed(
                                                          AppRoute
                                                              .historyDetailsOrder,
                                                          arguments: [
                                                        TypeAdd.receiver,
                                                        1,
                                                        formOrder!.result!
                                                            .locations![index]
                                                      ]),
                                                  child: const Text(
                                                    'Посмотреть детали',
                                                    style:
                                                        CustomTextStyle.red15,
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
                                SizedBox(height: 20.h),
                                Row(
                                  children: const [
                                    Text(
                                      'Кто везёт',
                                      style: CustomTextStyle.grey15bold,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                formOrder!.result!.courier == null
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        child: const Text(
                                          'Курьер еще не назначен на Ваш заказ. '
                                          'Как только логисты закончат планирование, '
                                          'Вам придёт пуш-уведомление и здесь отобразятся '
                                          'данные водителя и его ТС.',
                                          textAlign: TextAlign.justify,
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.r),
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
                                                    style: CustomTextStyle
                                                        .black15w700,
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  const Text(
                                                    'Румянцев',
                                                    style: CustomTextStyle
                                                        .black15w700,
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                SizedBox(height: 10.h),
                                formOrder!.result!.courier == null
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 80.w,
                                                width: 80.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.r),
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
                                                    style: CustomTextStyle
                                                        .black15w700,
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  const Text(
                                                    'Цвет: белый',
                                                    style: CustomTextStyle
                                                        .black15w700,
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
                                SizedBox(height: 140.h)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!resPaid)
                    BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, snapshot) {
                      final auth =
                          BlocProvider.of<ProfileBloc>(context).getUser();
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Blur(blur: 2.5, child: Container(height: 120.h)),
                          Padding(
                            padding: EdgeInsets.all(30.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Оплатить: ${double.tryParse(formOrder!.result!.totalPrice!.total!)!.ceil()} ${formOrder!.result!.totalPrice!.currency}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Row(
                                      children: [
                                        if (auth != null &&
                                            auth.result!.agent != null)
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                            ),
                                            onPressed: () async {
                                              final deposit =
                                                  BlocProvider.of<ProfileBloc>(
                                                          context)
                                                      .deposit;

                                              MessageDialogs().showLoadDialog(
                                                  'Производится оплата с вашего депозита');
                                              String? res = await Repository()
                                                  .paymentDeposit(
                                                      formOrder!.result!
                                                          .invoices!.first.iD!,
                                                      formOrder!.result!
                                                          .invoices!.first.pIN!,
                                                      deposit!.result!.accounts
                                                          .first.iD);
                                              SmartDialog.dismiss();
                                              BlocProvider.of<
                                                          HistoryOrdersBloc>(
                                                      context)
                                                  .add(GetListOrdersEvent());
                                              res == null
                                                  ? MessageDialogs()
                                                      .completeDialog(
                                                          text: 'Оплачено')
                                                  : MessageDialogs()
                                                      .errorDialog(
                                                          text: 'Ошибка оплаты',
                                                          error: res);
                                              resPaid =
                                                  res == null ? true : false;
                                              setState(() {});
                                            },
                                            child: const Text('Депозит'),
                                          )
                                        else
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                            ),
                                            child: const Text('Карта'),
                                          ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    })
                ],
              ),
      ),
    );
  }
}
