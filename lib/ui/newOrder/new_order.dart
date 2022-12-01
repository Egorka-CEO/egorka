import 'package:egorka/core/bloc/new_order/new_order_bloc.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/route_order.dart';
import 'package:egorka/widget/bottom_sheet_add_adress.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum TypeAdd { sender, receiver }

class NewOrderPage extends StatefulWidget {
  CoastResponse order;
  DeliveryChocie deliveryChocie;
  NewOrderPage({
    required this.order,
    required this.deliveryChocie,
    super.key,
  });

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  List<RouteOrder> routeOrderSender = [];
  List<RouteOrder> routeOrderReceiver = [];

  TextEditingController fromController = TextEditingController();
  PanelController panelController = PanelController();
  bool btmSheet = false;
  TypeAdd? typeAdd;

  @override
  void initState() {
    super.initState();
    routeOrderSender.add(
      RouteOrder(
          id: widget.order.result!.locations![0].point!.code!,
          adress: widget.order.result!.locations![0].point!.address!),
    );
    routeOrderReceiver.add(
      RouteOrder(
          id: widget.order.result!.locations![1].point!.code!,
          adress: widget.order.result!.locations![1].point!.address!),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('object ${widget.deliveryChocie.icon}');
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewOrderPageBloc>(
          create: (context) => NewOrderPageBloc(),
        ),
      ],
      child: Scaffold(
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
                                style: CustomTextStyle.red15
                                    .copyWith(fontSize: 17),
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
        body: Column(
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
                  // routeOrderSender.add(RouteOrder(adress: current.value!));
                } else if (typeAdd != null && typeAdd == TypeAdd.receiver) {
                  // routeOrderReceiver.add(RouteOrder(adress: current.value!));
                }
              }
              return true;
            }, builder: (context, snapshot) {
              return Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15.h),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.w, bottom: 8.w),
                                  child: const Text(
                                    'Отправитель',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: routeOrderSender.length,
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return Dismissible(
                                      key: Key('$index'),
                                      confirmDismiss: (direction) {
                                        routeOrderSender.removeAt(index);
                                        return routeOrderSender.length == 1
                                            ? Future.value(false)
                                            : Future.value(true);
                                      },
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                index == 0 ? 15.r : 0),
                                            bottomRight: Radius.circular(
                                              index ==
                                                      routeOrderSender.length -
                                                          1
                                                  ? 15.r
                                                  : 0,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(10.r),
                                          child: const Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'Удалить',
                                              style:
                                                  CustomTextStyle.white15w600,
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
                                                ? const Radius.circular(15)
                                                : routeOrderSender.length - 1 ==
                                                        index
                                                    ? const Radius.circular(15)
                                                    : Radius.zero,
                                            bottomRight: routeOrderSender
                                                        .length ==
                                                    1
                                                ? const Radius.circular(15)
                                                : routeOrderSender.length - 1 ==
                                                        index
                                                    ? const Radius.circular(15)
                                                    : Radius.zero,
                                            topLeft: routeOrderSender.length ==
                                                    1
                                                ? const Radius.circular(15)
                                                : routeOrderSender.length - 1 ==
                                                        index
                                                    ? Radius.zero
                                                    : index == 0
                                                        ? const Radius.circular(
                                                            15)
                                                        : Radius.zero,
                                            topRight: routeOrderSender.length ==
                                                    1
                                                ? const Radius.circular(15)
                                                : routeOrderSender.length - 1 ==
                                                        index
                                                    ? Radius.zero
                                                    : index == 0
                                                        ? const Radius.circular(
                                                            15)
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
                                                    routeOrderSender[index]
                                                        .adress,
                                                    style: CustomTextStyle
                                                        .black15w500
                                                        .copyWith(fontSize: 16),
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
                                                  onTap: () => Navigator.of(
                                                          context)
                                                      .pushNamed(
                                                          AppRoute.detailsOrder,
                                                          arguments: [
                                                        TypeAdd.sender,
                                                        routeOrderSender
                                                                .length +
                                                            1
                                                      ]),
                                                  child: Text(
                                                    'Указать детали',
                                                    style: CustomTextStyle.red15
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        typeAdd = TypeAdd.sender;
                                        BlocProvider.of<NewOrderPageBloc>(
                                                context)
                                            .add(NewOrderOpenBtmSheet());
                                        panelController.animatePanelToPosition(
                                          1,
                                          curve: Curves.easeInOutQuint,
                                          duration: const Duration(
                                              milliseconds: 1000),
                                        );
                                      },
                                      child: Text(
                                        'Добавить отправителя',
                                        style: CustomTextStyle.red15.copyWith(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.w, bottom: 8.w),
                                  child: const Text(
                                    'Получатель',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: routeOrderReceiver.length,
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: ((context, index) {
                                    return Dismissible(
                                      key: Key('$index'),
                                      confirmDismiss: (direction) {
                                        routeOrderReceiver.removeAt(index);
                                        return routeOrderReceiver.length == 1
                                            ? Future.value(false)
                                            : Future.value(true);
                                      },
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                index == 0 ? 15.r : 0),
                                            bottomRight: Radius.circular(
                                                index ==
                                                        routeOrderReceiver
                                                            .length
                                                    ? 15.r
                                                    : 0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(10.w),
                                          child: const Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'Удалить',
                                              style:
                                                  CustomTextStyle.white15w600,
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
                                                ? const Radius.circular(15)
                                                : routeOrderReceiver.length -
                                                            1 ==
                                                        index
                                                    ? const Radius.circular(15)
                                                    : Radius.zero,
                                            bottomRight: routeOrderReceiver
                                                        .length ==
                                                    1
                                                ? const Radius.circular(15)
                                                : routeOrderReceiver.length -
                                                            1 ==
                                                        index
                                                    ? const Radius.circular(15)
                                                    : Radius.zero,
                                            topLeft: routeOrderReceiver
                                                        .length ==
                                                    1
                                                ? const Radius.circular(15)
                                                : routeOrderReceiver.length -
                                                            1 ==
                                                        index
                                                    ? Radius.zero
                                                    : index == 0
                                                        ? const Radius.circular(
                                                            15)
                                                        : Radius.zero,
                                            topRight: routeOrderReceiver
                                                        .length ==
                                                    1
                                                ? const Radius.circular(15)
                                                : routeOrderReceiver.length -
                                                            1 ==
                                                        index
                                                    ? Radius.zero
                                                    : index == 0
                                                        ? const Radius.circular(
                                                            15)
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
                                                    routeOrderReceiver[index]
                                                        .adress,
                                                    style: CustomTextStyle
                                                        .black15w500
                                                        .copyWith(fontSize: 16),
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
                                                  onTap: () => Navigator.of(
                                                          context)
                                                      .pushNamed(
                                                          AppRoute.detailsOrder,
                                                          arguments: [
                                                        TypeAdd.receiver,
                                                        routeOrderReceiver
                                                                .length +
                                                            1
                                                      ]),
                                                  child: Text(
                                                    'Указать детали',
                                                    style: CustomTextStyle.red15
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
                                    BlocProvider.of<NewOrderPageBloc>(context)
                                        .add(NewOrderOpenBtmSheet());
                                    panelController.animatePanelToPosition(
                                      1,
                                      curve: Curves.easeInOutQuint,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Добавить получателя',
                                        style: CustomTextStyle.red15.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      TextEditingController(),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  textEditingController:
                                      TextEditingController(),
                                ),
                              ],
                            ),
                            SizedBox(height: 210.h)
                          ],
                        ),
                      ),
                    ),
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
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.deliveryChocie.title,
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '${widget.order.result!.totalPrice!.total} ₽',
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
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          '0 ₽ доставка',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          '0 ₽ доп. услуги',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          '0 ₽ сбор-плат. сист.',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              GestureDetector(
                                child: Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'ОПЛАТИТЬ ЗАКАЗ',
                                      style: CustomTextStyle.white15w600
                                          .copyWith(
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500),
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
                        // focusFrom.unfocus();
                        // focusTo.unfocus();
                        // _visible = false;
                      },
                      onPanelOpened: () {
                        // _visible = true;
                        // if (!focusFrom.hasFocus && !focusTo.hasFocus) {
                        //   panelController.close();
                        // }
                      },
                      onPanelSlide: (size) {
                        // if (size.toStringAsFixed(1) == (0.5).toString()) {
                        //   focusFrom.unfocus();
                        //   focusTo.unfocus();
                        // }
                      },
                      maxHeight: 700.h,
                      minHeight: 0,
                      defaultPanelState: PanelState.CLOSED,
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
