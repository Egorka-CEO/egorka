import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HistoryOrdersBottomSheetDraggable extends StatefulWidget {
  PanelController panelController;
  HistoryOrdersBottomSheetDraggable({
    Key? key,
    required this.panelController,
  });

  @override
  State<HistoryOrdersBottomSheetDraggable> createState() =>
      _BottomSheetDraggableState();
}

class _BottomSheetDraggableState
    extends State<HistoryOrdersBottomSheetDraggable> {
  List<CreateFormModel> coast = [];

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
              child: _searchList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: BlocBuilder<HistoryOrdersBloc, HistoryOrdersState>(
          buildWhen: (previous, current) {
        if (current is HistoryUpdateList) {
          coast = current.coast;
          return true;
        }
        return false;
      }, builder: (context, snapshot) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: coast.length,
          itemBuilder: (context, index) {
            if (coast[index].result.locations.isEmpty) {
              return const SizedBox();
            }
            return _pointCard(coast[index], index, context);
          },
        );
      }),
    );
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
    String typeOrder = 'FBO';

    if (state.result.Group == 'FBS') {
      typeOrder = 'FBS';
    } else if (state.result.Group == 'FBO') {
      typeOrder = 'FBO';
    } else if (state.result.Group == 'Express') {
      typeOrder = 'Г';
    } else if (state.result.Group == 'Marketplace') {
      typeOrder = 'FBO';
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
                                            onTap: state.result.Group! ==
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
                        child: Text(
                          typeOrder,
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
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
