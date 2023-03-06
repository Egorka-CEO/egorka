import 'dart:developer';

import 'package:blur/blur.dart';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/month.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/model/delivery_type.dart';
import 'package:egorka/model/info_form.dart';
import 'package:egorka/model/payment_card.dart';
import 'package:egorka/model/status_order.dart';
import 'package:egorka/model/type_add.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/mini_map.dart';
import 'package:egorka/widget/payment_webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentOrderPage extends StatefulWidget {
  int? recordPIN;
  int? recorNumber;
  CurrentOrderPage({super.key, this.recordPIN, this.recorNumber});

  @override
  State<CurrentOrderPage> createState() => _CurrentOrderPageState();
}

class _CurrentOrderPageState extends State<CurrentOrderPage> {
  InfoForm? formOrder;
  StatusOrder? statusOrder = StatusOrder.rejected;
  bool resPaid = false;
  bool paidBtmSheet = false;
  DateTime? parseDate;
  DateTime? dateTime;
  String day = '';
  String pickDay = '';
  String pickDate = '';
  Color colorStatus = Colors.red;
  String status = 'Ошибка';
  bool loadOrder = false;
  String? declaredCost;
  bool cardTap = true;
  String? gatePay;

  int pointSentCount = 0;
  int pointReceiveCount = 0;

  List<Widget> additionalInfo = [];

  DeliveryChocie? deliveryChocie;

  @override
  void initState() {
    super.initState();
    getForm();
    BlocProvider.of<HistoryOrdersBloc>(context).add(GetListOrdersEvent());
  }

  Widget additional(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10.w),
          SizedBox(
            width: 300.w,
            child: Text(
              title,
              style: CustomTextStyle.grey15bold,
              maxLines: 2,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 24.h,
            height: 24.h,
            child: Checkbox(
              value: true,
              splashRadius: 0,
              fillColor: MaterialStateProperty.all(Colors.red),
              shape: const CircleBorder(),
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  void getForm() async {
    if (widget.recorNumber != null && widget.recordPIN != null) {
      loadOrder = true;
      formOrder = await Repository().infoForm(
        widget.recorNumber.toString(),
        widget.recordPIN.toString(),
      );
      for (var element in formOrder!.result!.ancillaries!) {
        if (element.type == 'Insurance') {
          declaredCost = (element.params?.first.value / 100).ceil().toString();
        }
      }
      if (formOrder!.result!.locations!.first.date != null) {
        parseDate = DateTime.fromMillisecondsSinceEpoch(
            formOrder!.result!.locations!.first.date! * 1000);

        pickDay = DateFormat.EEEE('ru').format(parseDate!);
        String? timePick;
        if (formOrder?.result?.group == 'Express') {
          timePick = '';
          timePick =
              '${parseDate!.hour < 10 ? '0${parseDate!.hour}' : parseDate!.hour}:${parseDate!.minute < 10 ? '0${parseDate!.minute}' : parseDate!.minute}';
        }
        pickDate =
            '$pickDay, ${parseDate!.day} ${DateMonth().monthDate(parseDate!)} ${parseDate!.year} ${timePick ?? ''}';
      }
      day = DateFormat('dd').format(
          DateTime.fromMillisecondsSinceEpoch(formOrder!.result!.date! * 1000));
      checkOrder();
    }
  }

  void checkOrder() {
    if (formOrder!.result!.status == 'Drafted') {
      resPaid = formOrder!.result!.payStatus! == 'Paid' ? true : false;
      colorStatus = resPaid ? Colors.green : Colors.orange;
      status = 'Черновик';
      paidBtmSheet = resPaid;
    } else if (formOrder!.result!.status == 'Booked') {
      resPaid = formOrder!.result!.payStatus! == 'Paid' ? true : false;
      colorStatus = resPaid ? Colors.green : Colors.orange;
      status = resPaid ? 'Оплачено' : 'Активно';
      paidBtmSheet = !resPaid;
    } else if (formOrder!.result!.status == 'Completed') {
      paidBtmSheet = false;
      resPaid = formOrder!.result!.payStatus! == 'Paid' ? true : false;
      colorStatus = Colors.green;
      status = 'Выполнено';
    } else if (formOrder!.result!.status == 'Cancelled') {
      paidBtmSheet = false;
      resPaid = formOrder!.result!.payStatus! == 'Paid' ? true : false;
      colorStatus = Colors.red;
      status = 'Отменено';
    } else if (formOrder!.result!.status == 'Rejected') {
      paidBtmSheet = false;
      resPaid = formOrder!.result!.payStatus! == 'Paid' ? true : false;
      colorStatus = Colors.orange;
      status = 'Отказано';
    } else if (formOrder!.result!.status == 'Error') {
      paidBtmSheet = false;
      resPaid = formOrder!.result!.payStatus! == 'Paid' ? true : false;
      colorStatus = Colors.red;
      status = 'Ошибка';
    }

    additionalInfo.clear();

    for (var element in formOrder!.result!.ancillaries!) {
      if (element.type == 'LoadMarketplace' && element.price! != 0) {
        additionalInfo.add(additional('Услуга помощи погрузки / разгрузки'));
      }
      if (element.type == 'Pallet' && element.price! != 0) {
        additionalInfo.add(additional('Паллетирование'));
      }
      if (element.type == 'Load') {
        additionalInfo.add(additional('Услуга помощи погрузки / разгрузки'));
      }
      if (element.type == 'Post') {
        additionalInfo.add(additional('Отправка почтой'));
      }
      if (element.type == 'DoorToDoor') {
        additionalInfo.add(additional('Доставка до двери'));
      }
      if (element.type == 'Proxy') {
        additionalInfo.add(additional('Оформление доверенности'));
      }
      if (element.type == 'Industrial') {
        additionalInfo.add(additional('Промзона'));
      }
      if (element.type == 'TrainSend') {
        additionalInfo.add(
            additional('Отправить посылку поездом, автобусом или самолетом'));
      }
      if (element.type == 'TrainReceive') {
        additionalInfo.add(
            additional('Встретить посылку поездом, автобусом или самолетом'));
      }
      if (element.type == 'Insurance') {
        additionalInfo.add(additional('Страховка'));
      }
    }

    if (formOrder!.result!.type! == 'Car') {
      deliveryChocie = listChoice[0];
    } else if (formOrder!.result!.type! == 'Walk') {
      deliveryChocie = listChoice[1];
    } else if (formOrder!.result!.type! == 'Truck') {
      deliveryChocie = listChoice[2];
    }

    if (formOrder != null &&
        formOrder!.result != null &&
        formOrder!.result!.invoices != null &&
        formOrder!.result!.invoices!.first.payments.isNotEmpty) {
      gatePay = formOrder?.result?.invoices?.first.payments.first.gate ?? '';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    pointSentCount = 0;
    pointReceiveCount = 0;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Material(
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
                                      onTap: () => Navigator.of(context).pop(),
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const Align(
                                      child: Text(
                                        'Текущий заказ',
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
                                                    title: const Text(
                                                        'Подтвердить?'),
                                                    content: const Text(
                                                        'Текущая заявка будет отменена'),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                          isDefaultAction: true,
                                                          child: const Text(
                                                              "Отменить")),
                                                      CupertinoDialogAction(
                                                          onPressed: () async {
                                                            MessageDialogs()
                                                                .showLoadDialog(
                                                                    'Отмена заявки');
                                                            bool res = await Repository()
                                                                .cancelForm(
                                                                    '${formOrder!.result!.recordNumber}',
                                                                    '${formOrder!.result!.recordPIN}');
                                                            SmartDialog
                                                                .dismiss();
                                                            BlocProvider.of<
                                                                        HistoryOrdersBloc>(
                                                                    context)
                                                                .add(
                                                                    GetListOrdersEvent());
                                                            res
                                                                ? MessageDialogs()
                                                                    .completeDialog(
                                                                        text:
                                                                            'Заявка отменена')
                                                                : MessageDialogs()
                                                                    .errorDialog(
                                                                        text:
                                                                            'Ошибка отмены');
                                                            resPaid = res;
                                                            Navigator.pop(
                                                                context);
                                                            getForm();
                                                            setState(() {});
                                                          },
                                                          isDefaultAction: true,
                                                          child: const Text(
                                                              "Подтвердить"))
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
                        ),
                        Container(
                          height: 1,
                          color: Colors.black.withOpacity(0.2),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 10.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h, horizontal: 10.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            color: colorStatus,
                                          ),
                                          child: Text(
                                            status,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Text(
                                          '${formOrder!.result?.recordNumber}${formOrder!.result?.recordPIN} / ${formOrder!.result!.date != null ? '$day ' + DateMonth().monthDate(DateTime.fromMillisecondsSinceEpoch(formOrder!.result!.date! * 1000)) : '-'}',
                                          style: CustomTextStyle.black17w400,
                                        ),
                                        SizedBox(height: 10.h),
                                        SizedBox(
                                          height: 250.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            child: MiniMapView(
                                                pointSentCount: pointSentCount,
                                                type: formOrder!.result!.type!,
                                                locations: formOrder!
                                                    .result!.locations!),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            formOrder?.result?.group ==
                                                    'Express'
                                                ? const Text(
                                                    'Дата и время забора',
                                                    style: CustomTextStyle
                                                        .grey15bold,
                                                  )
                                                : const Text(
                                                    'Дата забора',
                                                    style: CustomTextStyle
                                                        .grey15bold,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(height: 15.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: Colors.grey[500],
                                            ),
                                            SizedBox(width: 10.w),
                                            parseDate != null
                                                ? Text(
                                                    pickDate,
                                                    style: CustomTextStyle
                                                        .black15w700
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  )
                                                : const Text(
                                                    '-',
                                                    style: CustomTextStyle
                                                        .black17w400,
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
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: formOrder!
                                              .result!.locations!.length,
                                          itemBuilder: ((context, index) {
                                            if (formOrder!.result!
                                                    .locations![index].type ==
                                                'Pickup') {
                                              ++pointSentCount;
                                              int count = pointSentCount;
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10.h),
                                                child: Container(
                                                  padding: EdgeInsets.all(10.w),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
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
                                                                  .locations![
                                                                      index]
                                                                  .point!
                                                                  .address!,
                                                              style: CustomTextStyle
                                                                  .black17w400,
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
                                                            color: Colors
                                                                .grey[400],
                                                          ),
                                                          SizedBox(width: 15.w),
                                                          GestureDetector(
                                                            onTap: () => Navigator
                                                                    .of(context)
                                                                .pushNamed(
                                                                    AppRoute
                                                                        .historyDetailsOrder,
                                                                    arguments: [
                                                                  TypeAdd
                                                                      .sender,
                                                                  count,
                                                                  formOrder!
                                                                      .result!
                                                                      .locations![index]
                                                                ]),
                                                            child: const Text(
                                                              'Посмотреть детали',
                                                              style:
                                                                  CustomTextStyle
                                                                      .red15,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ++pointReceiveCount;
                                              int count = pointReceiveCount;
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10.h),
                                                child: Container(
                                                  padding: EdgeInsets.all(10.w),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
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
                                                                  .locations![
                                                                      index]
                                                                  .point!
                                                                  .address!,
                                                              style: CustomTextStyle
                                                                  .black17w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 15.h),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.flag,
                                                            color: Colors
                                                                .grey[400],
                                                          ),
                                                          SizedBox(width: 15.w),
                                                          GestureDetector(
                                                            onTap: () => Navigator
                                                                    .of(context)
                                                                .pushNamed(
                                                                    AppRoute
                                                                        .historyDetailsOrder,
                                                                    arguments: [
                                                                  TypeAdd
                                                                      .receiver,
                                                                  count,
                                                                  formOrder!
                                                                      .result!
                                                                      .locations![index]
                                                                ]),
                                                            child: const Text(
                                                              'Посмотреть детали',
                                                              style:
                                                                  CustomTextStyle
                                                                      .red15,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                        ),
                                        if (status != 'Отказано' &&
                                            status != 'Ошибка' &&
                                            status != 'Отменено')
                                          SizedBox(height: 30.h),
                                        if (status != 'Отказано' &&
                                            status != 'Ошибка' &&
                                            status != 'Отменено')
                                          Row(
                                            children: const [
                                              Text(
                                                'Кто везёт',
                                                style:
                                                    CustomTextStyle.grey15bold,
                                              ),
                                            ],
                                          ),
                                        if (status != 'Отказано' &&
                                            status != 'Ошибка' &&
                                            status != 'Отменено')
                                          SizedBox(height: 20.h),
                                        formOrder!.result!.courier == null
                                            ? (status == 'Отказано' ||
                                                    status == 'Ошибка' ||
                                                    status == 'Отменено')
                                                ? const SizedBox()
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w),
                                                    child: const Text(
                                                      'Курьер еще не назначен на Ваш заказ. '
                                                      'Как только логисты закончат планирование, '
                                                      'Вам придёт пуш-уведомление и здесь отобразятся '
                                                      'данные водителя и его ТС.',
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  )
                                            : Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 80.w,
                                                        width: 80.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.r),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.r),
                                                          child: formOrder!
                                                                  .result!
                                                                  .courier!
                                                                  .photo!
                                                                  .isEmpty
                                                              ? Icon(
                                                                  Icons.person,
                                                                  size: 40.h,
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                )
                                                              : Image.asset(
                                                                  'assets/images/deliver.jpeg',
                                                                  height: 80.h,
                                                                ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20.w),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            formOrder!.result!
                                                                .courier!.name!,
                                                            style:
                                                                CustomTextStyle
                                                                    .black15w700,
                                                          ),
                                                          SizedBox(
                                                              height: 10.h),
                                                          Text(
                                                            formOrder!
                                                                .result!
                                                                .courier!
                                                                .surname!,
                                                            style:
                                                                CustomTextStyle
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.r),
                                                        ),
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            if (deliveryChocie !=
                                                                null)
                                                              Image.asset(
                                                                deliveryChocie!
                                                                    .icon,
                                                                color:
                                                                    Colors.red,
                                                                height: 50.h,
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 20.w),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${formOrder!.result!.courier!.carVendor} ${formOrder!.result!.courier!.carModel} / ${formOrder!.result!.courier!.carNumber}',
                                                            style:
                                                                CustomTextStyle
                                                                    .black15w700,
                                                          ),
                                                          SizedBox(
                                                              height: 10.h),
                                                          Text(
                                                            'Цвет: ${formOrder!.result!.courier!.carColorName}',
                                                            style:
                                                                CustomTextStyle
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
                                        Column(children: additionalInfo),
                                        if (declaredCost != null)
                                          SizedBox(height: 20.h),
                                        if (declaredCost != null)
                                          Row(
                                            children: [
                                              SizedBox(width: 10.w),
                                              const Text(
                                                'Объявленная ценность',
                                                style:
                                                    CustomTextStyle.grey15bold,
                                              ),
                                              const Spacer(),
                                              Text(
                                                '$declaredCost ₽',
                                                style: CustomTextStyle
                                                    .black15w700
                                                    .copyWith(
                                                        color:
                                                            Colors.grey[500]),
                                              ),
                                            ],
                                          ),
                                        if (formOrder!
                                            .result!.description!.isNotEmpty)
                                          SizedBox(height: 20.h),
                                        if (formOrder!
                                            .result!.description!.isNotEmpty)
                                          Row(
                                            children: [
                                              SizedBox(width: 10.w),
                                              const Text(
                                                'Что везем',
                                                style:
                                                    CustomTextStyle.grey15bold,
                                              ),
                                              const Spacer(),
                                              Text(
                                                formOrder!.result!.description!,
                                                style: CustomTextStyle
                                                    .black15w700
                                                    .copyWith(
                                                        color:
                                                            Colors.grey[500]),
                                              ),
                                            ],
                                          ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.w),
                                            const Text(
                                              'Стоимость доставки',
                                              style: CustomTextStyle.grey15bold,
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${(formOrder!.result!.totalPrice!.base! / 100).ceil()} ₽',
                                              style: CustomTextStyle.black15w700
                                                  .copyWith(
                                                      color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.w),
                                            const Text(
                                              'Дополнительные услуги',
                                              style: CustomTextStyle.grey15bold,
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${(formOrder!.result!.totalPrice!.ancillary! / 100).ceil()} ₽',
                                              style: CustomTextStyle.black15w700
                                                  .copyWith(
                                                      color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
                                        if (gatePay != null)
                                          SizedBox(height: 20.h),
                                        if (gatePay != null)
                                          Row(
                                            children: [
                                              SizedBox(width: 10.w),
                                              const Text(
                                                'Способ оплаты',
                                                style:
                                                    CustomTextStyle.grey15bold,
                                              ),
                                              const Spacer(),
                                              BlocBuilder<ProfileBloc,
                                                      ProfileState>(
                                                  builder: (context, snapshot) {
                                                return Text(
                                                  gatePay == 'Account'
                                                      ? 'Депозит'
                                                      : 'Карта',
                                                  style: CustomTextStyle
                                                      .black15w700
                                                      .copyWith(
                                                          color:
                                                              Colors.grey[500]),
                                                );
                                              }),
                                            ],
                                          ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.w),
                                            const Text(
                                              'Номер заказа',
                                              style: CustomTextStyle.grey15bold,
                                            ),
                                            const Spacer(),
                                            Text(
                                              '№ ${formOrder!.result?.recordNumber}-${formOrder!.result?.recordPIN}',
                                              style: CustomTextStyle.black15w700
                                                  .copyWith(
                                                      color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.w),
                                            const Text(
                                              'Статус оплаты',
                                              style: CustomTextStyle.grey15bold,
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.h,
                                                  horizontal: 10.h),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                color: resPaid
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                              child: Text(
                                                resPaid
                                                    ? "Оплачено"
                                                    : "Не оплачено",
                                                style:
                                                    CustomTextStyle.white15w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.w),
                                            const Text(
                                              'Итого',
                                              style: CustomTextStyle.grey15bold,
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${double.tryParse(formOrder!.result!.totalPrice!.total!)!.ceil()} ₽',
                                              style:
                                                  CustomTextStyle.black15w700,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 70.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            if (formOrder!.result!.courier !=
                                                null)
                                              GestureDetector(
                                                onTap: () => launchUrl(Uri(
                                                    scheme: 'tel',
                                                    path:
                                                        '+${formOrder!.result!.courier!.phones.first!.value}')),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.call,
                                                      color: Colors.red,
                                                      size: 50.h,
                                                    ),
                                                    const Text(
                                                      'Позвонить\nводителю',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: CustomTextStyle
                                                          .black15w700,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            Column(
                                              children: [
                                                Icon(
                                                  Icons.send,
                                                  color: Colors.red,
                                                  size: 50.h,
                                                ),
                                                const Text(
                                                  'Написать в\nподдержку',
                                                  textAlign: TextAlign.center,
                                                  style: CustomTextStyle
                                                      .black15w700,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 140.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (paidBtmSheet)
                      BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, snapshot) {
                        final auth =
                            BlocProvider.of<ProfileBloc>(context).getUser();

                        String coast = '0';

                        for (var element
                            in formOrder!.result!.invoices!.first.options) {
                          if (element.logic == 'Account') {
                            coast = '${((element.amount)! / 100).ceil()}';
                            break;
                          }
                        }

                        String cardTotal = '0';
                        for (var element
                            in formOrder!.result!.invoices!.first.options) {
                          if (element.logic == 'Card') {
                            cardTotal =
                                '${((element.amount)! / 100).toStringAsFixed(2)}';
                            break;
                          }
                        }

                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Blur(
                              blur: 2.5,
                              blurColor: Colors.grey[300]!.withOpacity(0.1),
                              child: Container(height: 120.h),
                            ),
                            Padding(
                              padding: EdgeInsets.all(30.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Оплатить: $coast ₽',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          if (auth != null &&
                                              auth.result!.agent != null)
                                            SizedBox(
                                              height: 50.h,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final deposit = BlocProvider
                                                          .of<ProfileBloc>(
                                                              context)
                                                      .deposit;
                                                  MessageDialogs().showLoadDialog(
                                                      'Производится оплата с вашего депозита');
                                                  String? res =
                                                      await Repository()
                                                          .paymentDeposit(
                                                              formOrder!
                                                                  .result!
                                                                  .invoices!
                                                                  .first
                                                                  .iD!,
                                                              formOrder!
                                                                  .result!
                                                                  .invoices!
                                                                  .first
                                                                  .pIN!,
                                                              deposit!
                                                                  .result!
                                                                  .accounts
                                                                  .first
                                                                  .iD);
                                                  SmartDialog.dismiss();
                                                  BlocProvider.of<
                                                              HistoryOrdersBloc>(
                                                          context)
                                                      .add(
                                                          GetListOrdersEvent());
                                                  res == null
                                                      ? MessageDialogs()
                                                          .completeDialog(
                                                              text: 'Оплачено')
                                                      : MessageDialogs()
                                                          .errorDialog(
                                                              text:
                                                                  'Ошибка оплаты',
                                                              error: res);
                                                  resPaid = res == null
                                                      ? true
                                                      : false;
                                                  getForm();
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'Депозит',
                                                      style: CustomTextStyle
                                                          .black17w400,
                                                    ),
                                                    SizedBox(width: 5.w),
                                                    SvgPicture.asset(
                                                      'assets/icons/deposit.svg',
                                                      height: 25.h,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          SizedBox(width: 10.h),
                                          SizedBox(
                                            height: 50.h,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (cardTap) {
                                                  cardTap = false;
                                                  PaymentCard? res =
                                                      await Repository()
                                                          .paymentCard(
                                                    formOrder!.result!.invoices!
                                                        .first.iD!,
                                                    formOrder!.result!.invoices!
                                                        .first.pIN!,
                                                  );
                                                  if (res != null &&
                                                      res.url != null) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return PaymentWebView(
                                                            res.url!,
                                                            formOrder!
                                                                .result!
                                                                .invoices!
                                                                .first
                                                                .iD!,
                                                            formOrder!
                                                                .result!
                                                                .invoices!
                                                                .first
                                                                .pIN!,
                                                          );
                                                        },
                                                      ),
                                                    ).then((value) {
                                                      if (value != null) {
                                                        if (value) {
                                                          MessageDialogs()
                                                              .completeDialog(
                                                                  text:
                                                                      'Оплачено');
                                                          getForm();
                                                        } else {
                                                          MessageDialogs()
                                                              .errorDialog(
                                                                  text:
                                                                      'Ошибка оплаты');
                                                        }
                                                      }
                                                    });
                                                  }
                                                  cardTap = true;
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Карта',
                                                        style: CustomTextStyle
                                                            .black17w400,
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      SvgPicture.asset(
                                                        'assets/icons/credit-card.svg',
                                                        height: 25.h,
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    '+${(double.parse(cardTotal) - double.parse(coast)).toStringAsFixed(2)} ₽',
                                                    style: CustomTextStyle
                                                        .black15w700
                                                        .copyWith(
                                                      color: Colors.grey[500],
                                                      fontSize: 13.sp,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            ),
                          ],
                        );
                      })
                  ],
                ),
        ),
      ),
    );
  }
}
