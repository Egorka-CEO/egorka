import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
    return Material(
      color: Colors.transparent,
      child: _floatingPanel(context),
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
      print('object ${coast[index].result.RecordDate!}');
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

      // print(
      //     'objectQQQQ  ${da}');
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
      colorStatus = Colors.red;
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
          Container(
            padding: EdgeInsets.all(20.w),
            margin: EdgeInsets.only(top: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.panelController.close();
                                Navigator.of(context).pushNamed(
                                    AppRoute.historyOrder,
                                    arguments: coast[index]);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          state.result.locations.first.point!
                                              .address!,
                                          // state.result.locations.first.point!.address!,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
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
                                          state.result.locations.last.point!
                                              .address!,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5.h),
                      ClipOval(
                        child: Material(
                          color: Colors.grey[200],
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(
                                AppRoute.marketplaces,
                                arguments: [state]),
                            child: SizedBox(
                              width: 40.h,
                              height: 40.h,
                              child: const Icon(Icons.refresh),
                            ),
                          ),
                        ),
                      )
                    ],
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
