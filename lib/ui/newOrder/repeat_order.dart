import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/new_order/new_order_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/model/info_form.dart';
import 'package:egorka/model/poinDetails.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/widget/bottom_sheet_add_adress.dart';
import 'package:egorka/widget/calculate_circular.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:egorka/widget/load_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RepeatOrderPage extends StatelessWidget {
  int RecordNumber;
  int RecordPIN;

  RepeatOrderPage({
    required this.RecordNumber,
    required this.RecordPIN,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewOrderPageBloc>(
          create: (context) => NewOrderPageBloc(),
        ),
      ],
      child: RepeatOrderPageState(
        RecordNumber: RecordNumber,
        RecordPIN: RecordPIN,
      ),
    );
  }
}

class RepeatOrderPageState extends StatefulWidget {
  int RecordNumber;
  int RecordPIN;

  DeliveryChocie deliveryChocie = DeliveryChocie(
    title: 'Легковая',
    icon: 'assets/images/ic_car.png',
    type: 'Car',
  );

  RepeatOrderPageState({
    required this.RecordNumber,
    required this.RecordPIN,
    super.key,
  });

  @override
  State<RepeatOrderPageState> createState() => _RepeatOrderPageState();
}

class _RepeatOrderPageState extends State<RepeatOrderPageState> {
  List<PointDetails> routeOrderSender = [];
  List<PointDetails> routeOrderReceiver = [];

  TextEditingController fromController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController coastController = TextEditingController();

  PanelController panelController = PanelController();
  bool btmSheet = false;
  TypeAdd? typeAdd;
  InfoForm? formOrder;
  CoastResponse? coasts;

  @override
  void initState() {
    super.initState();
    getForm();
  }

  void getForm() async {
    formOrder = await Repository()
        .infoForm(widget.RecordNumber.toString(), widget.RecordPIN.toString());

    for (var element in formOrder!.result!.locations!) {
      if (element.type == 'Pickup') {
        routeOrderSender.add(
          PointDetails(
            suggestions: Suggestions(
                iD: '', name: element.point!.address!, point: element.point),
            details: Details(
              suggestions: Suggestions(
                  iD: '', name: element.point!.address!, point: element.point),
              entrance: element.point!.entrance,
              floor: element.point!.floor,
              room: element.point!.room,
              name: element.contact!.name,
              phone: element.contact!.phoneMobile,
              comment: element.message,
            ),
          ),
        );
      } else {
        routeOrderReceiver.add(
          PointDetails(
            suggestions: Suggestions(
                iD: '', name: element.point!.address!, point: element.point),
            details: Details(
              suggestions: Suggestions(
                  iD: '', name: element.point!.address!, point: element.point),
              entrance: element.point!.entrance,
              floor: element.point!.floor,
              room: element.point!.room,
              name: element.contact!.name,
              phone: element.contact!.phoneMobile,
              comment: element.message,
            ),
          ),
        );
      }
    }

    BlocProvider.of<NewOrderPageBloc>(context).add(CalculateCoastEvent(
      routeOrderSender,
      routeOrderReceiver,
      widget.deliveryChocie.type,
    ));

    setState(() {});
  }

  ScrollController scrollController = ScrollController();

  final FocusNode whatDrive = FocusNode();
  final FocusNode whatCoast = FocusNode();

  @override
  Widget build(BuildContext context) {
    bool keyBoardVisible = MediaQuery.of(context).viewInsets.bottom == 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.5),
        leading: const SizedBox(),
        elevation: 0.5,
        flexibleSpace: Column(
          children: [
            const Spacer(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Отмена',
                              style:
                                  CustomTextStyle.red15.copyWith(fontSize: 17),
                            ),
                          ),
                          Align(
                            child: Text(
                              'Оформление заказа',
                              style: CustomTextStyle.black15w500.copyWith(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: formOrder == null
          ? const Center(child: CupertinoActivityIndicator())
          : Column(
              children: [
                BlocBuilder<NewOrderPageBloc, NewOrderState>(
                  buildWhen: (previous, current) {
                    if (current is NewOrderCloseBtmSheet) {
                      btmSheet = false;
                    } else if (current is NewOrderStatedOpenBtmSheet) {
                      btmSheet = true;
                    } else if (current is NewOrderStateCloseBtmSheet) {
                      btmSheet = false;
                      if (typeAdd != null && typeAdd == TypeAdd.sender) {
                        routeOrderSender.add(PointDetails(
                            suggestions: current.value!, details: Details()));
                        BlocProvider.of<NewOrderPageBloc>(context)
                            .add(CalculateCoastEvent(
                          routeOrderSender,
                          routeOrderReceiver,
                          widget.deliveryChocie.type,
                        ));
                      } else if (typeAdd != null &&
                          typeAdd == TypeAdd.receiver) {
                        routeOrderReceiver.add(PointDetails(
                            suggestions: current.value!, details: Details()));
                        BlocProvider.of<NewOrderPageBloc>(context)
                            .add(CalculateCoastEvent(
                          routeOrderSender,
                          routeOrderReceiver,
                          widget.deliveryChocie.type,
                        ));
                      }
                    } else if (current is CalcSuccess) {
                      coasts = current.coasts ?? coasts;
                    } else if (current is CreateFormSuccess) {
                      BlocProvider.of<HistoryOrdersBloc>(context)
                          .add(GetListOrdersEvent());
                      MessageDialogs()
                          .completeDialog(text: 'Заявка создана')
                          .then((value) {
                        BlocProvider.of<HistoryOrdersBloc>(context).add(
                            HistoryUpdateListEvent(current.createFormModel));
                        Navigator.of(context).pop();
                      });
                    } else if (current is CreateFormFail) {
                      String errors = '';
                      MessageDialogs()
                          .errorDialog(text: 'Отклонено', error: errors);
                    }
                    return true;
                  },
                  builder: (context, snapshot) {
                    return Expanded(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            controller: scrollController,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15.h),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w, bottom: 8.w),
                                        child: const Text(
                                          'Отправитель',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: routeOrderSender.length,
                                        padding: const EdgeInsets.all(0),
                                        itemBuilder: (context, index) {
                                          return Dismissible(
                                            key: UniqueKey(),
                                            confirmDismiss: routeOrderSender
                                                        .length ==
                                                    1
                                                ? (direction) {
                                                    return Future.value(false);
                                                  }
                                                : (direction) {
                                                    routeOrderSender
                                                        .removeAt(index);
                                                    BlocProvider.of<
                                                                NewOrderPageBloc>(
                                                            context)
                                                        .add(
                                                            CalculateCoastEvent(
                                                      routeOrderSender,
                                                      routeOrderReceiver,
                                                      widget
                                                          .deliveryChocie.type,
                                                    ));

                                                    return routeOrderSender
                                                                .length ==
                                                            1
                                                        ? Future.value(false)
                                                        : Future.value(true);
                                                  },
                                            direction:
                                                DismissDirection.endToStart,
                                            background: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      index == 0 ? 15.r : 0),
                                                  bottomRight: Radius.circular(
                                                    index ==
                                                            routeOrderSender
                                                                    .length -
                                                                1
                                                        ? 15.r
                                                        : 0,
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(10.r),
                                                child: const Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'Удалить',
                                                    style: CustomTextStyle
                                                        .white15w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(10.w),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: routeOrderSender
                                                              .length ==
                                                          1
                                                      ? const Radius.circular(
                                                          15)
                                                      : routeOrderSender
                                                                      .length -
                                                                  1 ==
                                                              index
                                                          ? const Radius
                                                              .circular(15)
                                                          : Radius.zero,
                                                  bottomRight: routeOrderSender
                                                              .length ==
                                                          1
                                                      ? const Radius.circular(
                                                          15)
                                                      : routeOrderSender
                                                                      .length -
                                                                  1 ==
                                                              index
                                                          ? const Radius
                                                              .circular(15)
                                                          : Radius.zero,
                                                  topLeft: routeOrderSender
                                                              .length ==
                                                          1
                                                      ? const Radius.circular(
                                                          15)
                                                      : routeOrderSender
                                                                      .length -
                                                                  1 ==
                                                              index
                                                          ? Radius.zero
                                                          : index == 0
                                                              ? const Radius
                                                                  .circular(15)
                                                              : Radius.zero,
                                                  topRight: routeOrderSender
                                                              .length ==
                                                          1
                                                      ? const Radius.circular(
                                                          15)
                                                      : routeOrderSender
                                                                      .length -
                                                                  1 ==
                                                              index
                                                          ? Radius.zero
                                                          : index == 0
                                                              ? const Radius
                                                                  .circular(15)
                                                              : Radius.zero,
                                                ),
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
                                                          routeOrderSender[
                                                                  index]
                                                              .suggestions
                                                              .name,
                                                          style: CustomTextStyle
                                                              .black15w500
                                                              .copyWith(
                                                                  fontSize: 16),
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
                                                        onTap: () async {
                                                          dynamic details =
                                                              await Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                      AppRoute
                                                                          .detailsOrder,
                                                                      arguments: [
                                                                TypeAdd.sender,
                                                                routeOrderSender
                                                                    .length,
                                                                routeOrderSender[
                                                                    index],
                                                              ]);

                                                          routeOrderSender[
                                                              index] = details!;

                                                          BlocProvider.of<
                                                                      NewOrderPageBloc>(
                                                                  context)
                                                              .add(
                                                                  CalculateCoastEvent(
                                                            routeOrderSender,
                                                            routeOrderReceiver,
                                                            widget
                                                                .deliveryChocie
                                                                .type,
                                                          ));
                                                        },
                                                        child: Text(
                                                          'Указать детали',
                                                          style: CustomTextStyle
                                                              .red15
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              typeAdd = TypeAdd.sender;
                                              BlocProvider.of<NewOrderPageBloc>(
                                                      context)
                                                  .add(NewOrderOpenBtmSheet());
                                              panelController
                                                  .animatePanelToPosition(
                                                1,
                                                curve: Curves.easeInOutQuint,
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                              );
                                            },
                                            child: Text(
                                              'Добавить отправителя',
                                              style: CustomTextStyle.red15
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w, bottom: 8.w),
                                        child: const Text(
                                          'Получатель',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: routeOrderReceiver.length,
                                        padding: const EdgeInsets.all(0),
                                        itemBuilder: ((context, index) {
                                          return Dismissible(
                                            key: UniqueKey(),
                                            confirmDismiss: routeOrderReceiver
                                                        .length ==
                                                    1
                                                ? (direction) {
                                                    return Future.value(false);
                                                  }
                                                : (direction) {
                                                    routeOrderReceiver
                                                        .removeAt(index);

                                                    BlocProvider.of<
                                                                NewOrderPageBloc>(
                                                            context)
                                                        .add(
                                                            CalculateCoastEvent(
                                                      routeOrderSender,
                                                      routeOrderReceiver,
                                                      widget
                                                          .deliveryChocie.type,
                                                    ));
                                                    setState(() {});
                                                    return Future.value(true);
                                                  },
                                            direction:
                                                DismissDirection.endToStart,
                                            background: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      index == 0 ? 15.r : 0),
                                                  bottomRight: Radius.circular(
                                                    index ==
                                                            routeOrderReceiver
                                                                    .length -
                                                                1
                                                        ? 15.r
                                                        : 0,
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(10.w),
                                                child: const Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'Удалить',
                                                    style: CustomTextStyle
                                                        .white15w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(10.w),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: routeOrderReceiver
                                                              .length ==
                                                          1
                                                      ? const Radius.circular(
                                                          15)
                                                      : routeOrderReceiver
                                                                      .length -
                                                                  1 ==
                                                              index
                                                          ? const Radius
                                                              .circular(15)
                                                          : Radius.zero,
                                                  bottomRight: routeOrderReceiver
                                                              .length ==
                                                          1
                                                      ? const Radius.circular(
                                                          15)
                                                      : routeOrderReceiver
                                                                      .length -
                                                                  1 ==
                                                              index
                                                          ? const Radius
                                                              .circular(15)
                                                          : Radius.zero,
                                                  topLeft: routeOrderReceiver
                                                              .length ==
                                                          1
                                                      ? const Radius.circular(
                                                          15)
                                                      : routeOrderReceiver
                                                                      .length -
                                                                  1 ==
                                                              index
                                                          ? Radius.zero
                                                          : index == 0
                                                              ? const Radius
                                                                  .circular(15)
                                                              : Radius.zero,
                                                  topRight: routeOrderReceiver
                                                              .length ==
                                                          1
                                                      ? const Radius.circular(
                                                          15)
                                                      : routeOrderReceiver
                                                                      .length -
                                                                  1 ==
                                                              index
                                                          ? Radius.zero
                                                          : index == 0
                                                              ? const Radius
                                                                  .circular(15)
                                                              : Radius.zero,
                                                ),
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
                                                          routeOrderReceiver[
                                                                  index]
                                                              .suggestions
                                                              .name,
                                                          style: CustomTextStyle
                                                              .black15w500
                                                              .copyWith(
                                                                  fontSize: 16),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 15.h),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        index ==
                                                                routeOrderReceiver
                                                                        .length -
                                                                    1
                                                            ? Icons.flag
                                                            : Icons
                                                                .arrow_downward_rounded,
                                                        color: Colors.grey[400],
                                                      ),
                                                      SizedBox(width: 15.w),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          dynamic details =
                                                              await Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                      AppRoute
                                                                          .detailsOrder,
                                                                      arguments: [
                                                                TypeAdd
                                                                    .receiver,
                                                                routeOrderReceiver
                                                                    .length,
                                                                routeOrderReceiver[
                                                                    index],
                                                              ]);

                                                          routeOrderReceiver[
                                                              index] = details;

                                                          BlocProvider.of<
                                                                      NewOrderPageBloc>(
                                                                  context)
                                                              .add(
                                                                  CalculateCoastEvent(
                                                            routeOrderSender,
                                                            routeOrderReceiver,
                                                            widget
                                                                .deliveryChocie
                                                                .type,
                                                          ));
                                                        },
                                                        child: Text(
                                                          'Указать детали',
                                                          style: CustomTextStyle
                                                              .red15
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                      SizedBox(height: 10.h),
                                      GestureDetector(
                                        onTap: () {
                                          typeAdd = TypeAdd.receiver;
                                          BlocProvider.of<NewOrderPageBloc>(
                                                  context)
                                              .add(NewOrderOpenBtmSheet());
                                          panelController
                                              .animatePanelToPosition(
                                            1,
                                            curve: Curves.easeInOutQuint,
                                            duration: const Duration(
                                                milliseconds: 1000),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Добавить получателя',
                                              style: CustomTextStyle.red15
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w, top: 10.w, bottom: 8.w),
                                        child: const Text(
                                          'Что везем?',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      CustomTextField(
                                        height: 45.h,
                                        focusNode: whatDrive,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 10.w),
                                        hintStyle: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        hintText:
                                            'Документы / Цветы / Техника / Личная вещь',
                                        textEditingController:
                                            documentController,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w, top: 10.w, bottom: 8.w),
                                        child: const Text(
                                          'Ценность вашего груза?',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      CustomTextField(
                                        focusNode: whatCoast,
                                        onTap: () {
                                          scrollController.animateTo(
                                            scrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.bounceIn,
                                          );
                                        },
                                        height: 45.h,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 10.w),
                                        hintStyle: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        hintText: 'До 100000 ₽',
                                        textEditingController: coastController,
                                      ),
                                    ],
                                  ),
                                  keyBoardVisible
                                      ? formOrder != null
                                          ? SizedBox(height: 250.h)
                                          : SizedBox(height: 0.h)
                                      : SizedBox(height: 400.h)
                                ],
                              ),
                            ),
                          ),
                          if (coasts != null)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 200.h,
                                padding: EdgeInsets.only(bottom: 10.h),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.r),
                                    topLeft: Radius.circular(15.r),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 20.w,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Image.asset(
                                              widget.deliveryChocie.icon,
                                              color: Colors.red,
                                              height: 80.h,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.deliveryChocie.title,
                                                  style: const TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  '${double.tryParse(coasts!.result!.totalPrice!.total!)!.ceil()}! ₽',
                                                  style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Center(
                                              child: Text(
                                                '}',
                                                style: TextStyle(
                                                  height: 1,
                                                  fontSize: 60,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  '0 ₽ доставка',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  '0 ₽ доп. услуги',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  '0 ₽ сбор-плат. сист.',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<NewOrderPageBloc>(
                                                  context)
                                              .add(CreateForm(
                                                  coasts!.result!.id!));
                                        },
                                        child: Container(
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'ОФОРМИТЬ ЗАКАЗ',
                                              style: CustomTextStyle.white15w600
                                                  .copyWith(
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          SlidingUpPanel(
                            controller: panelController,
                            renderPanelSheet: false,
                            isDraggable: true,
                            collapsed: Container(),
                            panel: AddAdressBottomSheetDraggable(
                              typeAdd: typeAdd,
                              fromController: fromController,
                              panelController: panelController,
                            ),
                            onPanelClosed: () {
                              fromController.text = '';
                            },
                            onPanelOpened: () {},
                            onPanelSlide: (size) {},
                            maxHeight: 700.h,
                            minHeight: 0,
                            defaultPanelState: PanelState.CLOSED,
                          ),
                          if (snapshot is CalcLoading)
                            Positioned.fill(
                              child: Container(
                                color: Colors.transparent,
                                child: CalculateLoadingDialog(),
                              ),
                            ),
                          if (snapshot is CreateFormState)
                            Positioned.fill(
                              child: Container(
                                color: Colors.transparent,
                                child: LoadForm(),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
    );
  }
}