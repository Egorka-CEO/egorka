import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/model/create_form_model.dart';
import 'package:egorka/model/history.dart';
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
    final bloc = BlocProvider.of<HistoryOrdersBloc>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: BlocBuilder<HistoryOrdersBloc, HistoryOrdersState>(
          bloc: bloc,
          buildWhen: (previous, current) {
            if (current is HistoryUpdateList) {
              coast = bloc.coast;
              return true;
            }
            return false;
          },
          builder: (context, snapshot) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: coast.length,
              itemBuilder: (context, index) {
                return _pointCard(coast[index], index, context);
              },
            );
          }),
    );
  }

  Container _pointCard(CreateFormModel state, int index, BuildContext context) {
    final hour =
        DateTime.fromMillisecondsSinceEpoch(state.result.Date * 1000).hour;
    String period = 'вечером';
    if (hour >= 0 && hour < 6) {
      period = 'ночью';
    } else if (hour >= 6 && hour < 12) {
      period = 'утром';
    } else if (hour >= 12 && hour < 18) {
      period = 'днём';
    }
    return Container(
      margin: EdgeInsets.only(top: 5.h, bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd.MM.yyy').format(
                DateTime.fromMillisecondsSinceEpoch(state.result.Date * 1000)),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
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
                                  'Поездка $period в, ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(state.result.Date * 1000))}',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  state.result.locations[index].point.Address,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  state.result.Status,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(AppRoute.marketplaces, arguments: [
                              HistoryModel(
                                fromAdress: 'Москва Ленина 7',
                                toAdress: 'Москва метро Белорусская',
                                item1: '1',
                                item2: '2',
                                item3: '3',
                                startOrder: '12 сентября 2022',
                                name: 'Ахрип',
                                phone: '+7 (999) 833-12-78',
                                countBucket: 1,
                                countPallet: 10,
                              )
                            ]),
                            child: const Icon(Icons.refresh),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   flex: 2,
                //   child: GestureDetector(
                //     onTap: () {
                //       widget.panelController.close();
                //       Navigator.of(context).pushNamed(AppRoute.historyOrder);
                //     },
                //     child: Image.asset(state.icon!),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
