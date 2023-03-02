import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/delivery_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HistoryOrdersBottomSheetDraggable extends StatefulWidget {
  PanelController panelController;
  double panelSize;
  HistoryOrdersBottomSheetDraggable({
    Key? key,
    required this.panelController,
    required this.panelSize,
  });

  @override
  State<HistoryOrdersBottomSheetDraggable> createState() =>
      _BottomSheetDraggableState();
}

class _BottomSheetDraggableState
    extends State<HistoryOrdersBottomSheetDraggable>
    with TickerProviderStateMixin {
  List<CreateFormModel> coast = [];
  late final AnimationController controller;
  bool printText = false;

  @override
  void initState() {
    super.initState();
    animationEmpty();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Material(
        color: Colors.transparent,
        child: _floatingPanel(context),
      ),
    );
  }

  Widget _floatingPanel(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).viewInsets + EdgeInsets.only(top: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.black12,
          ),
        ],
        color: backgroundColor,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 10.w,
              left: ((MediaQuery.of(context).size.width * 45) / 100).w,
              right: ((MediaQuery.of(context).size.width * 45) / 100).w,
              bottom: 10.w,
            ),
            child: Container(
              height: 5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: _searchList(),
            ),
          ),
        ],
      ),
    );
  }

  void animationEmpty() async {
    controller = AnimationController(vsync: this);
    controller.addListener(() {
      print('object 123');
      if (controller.status == AnimationStatus.completed) {
        setState(() {
          printText = false;
        });
        controller.reset();
        controller
          ..duration = const Duration(seconds: 6)
          ..forward();
      } else if (controller.value >= 0.44 && controller.value <= 0.45) {
        setState(() {
          printText = true;
        });
        controller.animateBack(0.47);
        controller.animateBack(0.46);
        controller.animateTo(0.47);
        controller.forward();
      }
    });
    controller
      ..duration = const Duration(seconds: 6)
      ..forward();
  }

  Widget _searchList() {
    return BlocBuilder<HistoryOrdersBloc, HistoryOrdersState>(
        buildWhen: (previous, current) {
      if (current is HistoryOpenBtmSheetState && coast.isEmpty) {}
      if (current is HistoryCloseBtmSheetState && coast.isEmpty) {}
      if (current is HistoryUpdateList) {
        coast = current.coast;
        return true;
      }
      return false;
    }, builder: (context, snapshot) {
      if (coast.isEmpty) {
        if (widget.panelSize > 0 && widget.panelSize < 0.1) {
          controller
            ..duration = const Duration(seconds: 6)
            ..forward();
        } else if (widget.panelSize == 0) {
          printText = false;
          controller.reset();
        }
      }
      if (coast.isEmpty) {
        return Column(
          children: [
            LottieBuilder.asset(
              'assets/anim/empty_orders.json',
              controller: controller,
            ),
            printText
                ? Container(
                    height: 100.h,
                    padding: EdgeInsets.all(20.h),
                    margin: EdgeInsets.all(20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'У вас еще не было\nзаказов!',
                          cursor: '',
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          speed: const Duration(milliseconds: 40),
                        ),
                      ],
                      pause: const Duration(milliseconds: 8000),
                      repeatForever: true,
                    ),
                  )
                : const SizedBox(),
          ],
        );
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: coast.length,
        itemBuilder: (context, index) {
          if (coast[index].result.locations.isEmpty) {
            return const SizedBox();
          }
          return _pointCard(coast[index], index, context);
        },
      );
    });
  }

  Container _pointCard(CreateFormModel state, int index, BuildContext context) {
    var parsedDate = DateTime.parse(state.result.RecordDate!);
    bool date = false;

    if (index == 0) {
    } else {
      final date1 = DateTime.parse(coast[index - 1].result.RecordDate!);
      final date2 = DateTime.parse(coast[index].result.RecordDate!);

      if (date2.year == date1.year) {
        if (date2.month == date1.month) {
          if (date2.day == date1.day) {
            date = true;
          }
        } else {
          date = false;
        }
      } else {
        date = false;
      }
    }

    final hour = parsedDate.hour;
    String period = 'вечером';
    if (hour >= 0 && hour < 6) {
      period = 'ночью';
    } else if (hour >= 6 && hour < 12) {
      period = 'утром';
    } else if (hour >= 12 && hour < 18) {
      period = 'днём';
    }

    String status = 'Ошибка';

    Color colorStatus = Colors.red;
    bool resPaid = state.result.StatusPay! == 'Paid' ? true : false;
    Widget typeOrder = Text(
      'FBO',
      style: TextStyle(
        color: Colors.grey[200],
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
      ),
    );

    if (state.result.Group == 'FBS') {
      typeOrder = Text(
        'FBS',
        style: TextStyle(
          color: Colors.grey[200],
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
        ),
      );
    } else if (state.result.Group == 'FBO') {
      typeOrder = Text(
        'FBO',
        style: TextStyle(
          color: Colors.grey[200],
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
        ),
      );
    } else if (state.result.Group == 'Express') {
      if (state.result.Type! == 'Car') {
        typeOrder = Image.asset(
          listChoice[0].icon,
          color: Colors.grey[200],
        );
      } else {
        typeOrder = Image.asset(
          listChoice[1].icon,
          color: Colors.grey[200],
        );
      }
    } else if (state.result.Group == 'Marketplace') {
      typeOrder = Text(
        'FBO',
        style: TextStyle(
          color: Colors.grey[200],
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    if (state.result.Status == 'Drafted') {
      colorStatus = Colors.orange;
      status = 'Черновик';
    } else if (state.result.Status == 'Booked') {
      colorStatus = resPaid ? Colors.green : Colors.orange;
      status = resPaid ? 'Оплачено' : 'Активно';
    } else if (state.result.Status == 'Completed') {
      colorStatus = Colors.green;
      status = 'Выполнено';
    } else if (state.result.Status == 'Cancelled') {
      colorStatus = Colors.red;
      status = 'Отменено';
    } else if (state.result.Status == 'Rejected') {
      colorStatus = Colors.orange;
      status = 'Отказано';
    } else if (state.result.Status == 'Error') {
      colorStatus = Colors.red;
      status = 'Ошибка';
    }

    return Container(
      margin: EdgeInsets.only(top: 5.h, bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!date)
            Text(
              DateFormat('dd.MM.yyy').format(parsedDate),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.grey[400],
                height: 1,
              ),
            ),
          ScaleButton(
            reverse: true,
            bound: 0.03,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.panelController.close();
                    Navigator.of(context).pushNamed(AppRoute.historyOrder,
                        arguments: coast[index]);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    margin: EdgeInsets.only(top: 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Доставка $period в ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(state.result.Date! * 1000))}',
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/from.png',
                                              height: 25.h,
                                            ),
                                            SizedBox(width: 10.h),
                                            Flexible(
                                              child: Text(
                                                state.result.locations.first
                                                    .point!.address!,
                                                // state.result.locations.first.point!.address!,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/to.png',
                                              height: 25.h,
                                            ),
                                            SizedBox(width: 10.h),
                                            Flexible(
                                              child: Text(
                                                state.result.locations.last
                                                    .point!.address!,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          status,
                                          style: TextStyle(
                                              color: colorStatus,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Center(
                                      child: ClipOval(
                                        child: Material(
                                          color: Colors.grey[200],
                                          child: InkWell(
                                            onTap: state.result.Group ==
                                                    'Marketplace'
                                                ? () =>
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            AppRoute
                                                                .marketplaces,
                                                            arguments: [
                                                          state.result
                                                              .RecordNumber,
                                                          state.result.RecordPIN
                                                        ])
                                                : () =>
                                                    Navigator.of(
                                                            context)
                                                        .pushNamed(
                                                            AppRoute
                                                                .repeatOrder,
                                                            arguments: [
                                                          state.result
                                                              .RecordNumber,
                                                          state.result.RecordPIN
                                                        ]),
                                            child: SizedBox(
                                              width: 43.h,
                                              height: 43.h,
                                              child: const Icon(Icons.refresh),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: SizedBox(
                      width: 55.w,
                      child: Center(
                        child: typeOrder,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
