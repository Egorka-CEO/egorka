import 'dart:async';
import 'package:egorka/core/bloc/market_place/market_place_bloc.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MarketPlaceBottomSheetDraggable extends StatefulWidget {
  TextEditingController fromController;
  PanelController panelController;
  TypeAdd? typeAdd;
  MarketPlaceBottomSheetDraggable({
    Key? key,
    required this.typeAdd,
    required this.fromController,
    required this.panelController,
  });

  @override
  State<MarketPlaceBottomSheetDraggable> createState() =>
      _BottomSheetDraggableState();
}

class _BottomSheetDraggableState
    extends State<MarketPlaceBottomSheetDraggable> {
  FocusNode focusFrom = FocusNode();

  // List<DeliveryChocie> listChoice = [
  //   DeliveryChocie(title: 'Байк', icon: 'assets/images/ic_bike.png'),
  //   DeliveryChocie(title: 'Легковая', icon: 'assets/images/ic_car.png'),
  //   DeliveryChocie(title: 'Грузовая', icon: 'assets/images/ic_track.png'),
  //   DeliveryChocie(title: 'Ножками ;)', icon: 'assets/images/ic_leg.png'),
  // ];

  Address? address;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketPlacePageBloc, MarketPlaceState>(
        buildWhen: (previous, current) {
      if (current is MarketPlaceStatedOpenBtmSheet) {
        Future.delayed(const Duration(milliseconds: 600), () {
          focusFrom.requestFocus();
        });
      }
      return true;
    }, builder: (context, snapshot) {
      return _floatingPanel(context);
    });
  }

  Widget _floatingPanel(BuildContext context) {
    var bloc = BlocProvider.of<MarketPlacePageBloc>(context);
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
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 10.w,
                left: ((MediaQuery.of(context).size.width * 45) / 100).w,
                right: ((MediaQuery.of(context).size.width * 45) / 100).w,
                bottom: 10.w),
            child: Container(
              height: 5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: Colors.grey,
              ),
            ),
          ),
          if (widget.typeAdd != null)
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.grey[200],
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Checkbox(
                            value: false,
                            fillColor: MaterialStateProperty.all(
                                widget.typeAdd == TypeAdd.sender
                                    ? Colors.red
                                    : Colors.blue),
                            shape: const CircleBorder(),
                            onChanged: ((value) {}),
                          ),
                          Expanded(
                            child: CustomTextField(
                              height: 45.h,
                              onTap: () {
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  focusFrom.requestFocus();
                                });
                              },
                              focusNode: focusFrom,
                              fillColor: Colors.grey[200],
                              hintText: 'Откуда забрать?',
                              onFieldSubmitted: (text) {
                                focusFrom.unfocus();
                              },
                              textEditingController: widget.fromController,
                              onChanged: (value) {
                                bloc.add(MarketPlace(value));
                              },
                            ),
                          ),
                          SizedBox(width: 15.w),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                _searchList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _searchList() {
    return Column(
      children: [
        SizedBox(height: 10.h),
        SizedBox(
          height: 215.h,
          child: BlocBuilder<MarketPlacePageBloc, MarketPlaceState>(
            buildWhen: (previous, current) {
              if (current is MarketPlaceSuccess) {
                address = current.address;
              }
              return true;
            },
            builder: ((context, state) {
              if (state is MarketPlaceStated) {
                return const SizedBox();
              } else if (state is MarketPlaceLoading) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CupertinoActivityIndicator()],
                );
              } else if (state is MarketPlaceSuccess) {
                return address != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 300.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount:
                                state.address!.result.suggestions!.length,
                            itemBuilder: (context, index) {
                              return _pointCard(state, index, context);
                            },
                          ),
                        ),
                      )
                    : Container();
              } else {
                return const Text('');
              }
            }),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _pointCard(MarketPlaceSuccess state, int index, BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
          height: 50.h,
          child: InkWell(
            onTap: () {
              widget.fromController.text =
                  state.address!.result.suggestions![index].name;
              BlocProvider.of<MarketPlacePageBloc>(context).add(
                  MarketPlaceStatedCloseBtmSheet(
                      state.address!.result.suggestions![index]));

              focusFrom.unfocus();
              widget.panelController.close();
            },
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomWidget.iconGPSSmall(
                        color: widget.typeAdd == TypeAdd.sender
                            ? Colors.red
                            : Colors.blue),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 10,
                  child: Text(
                    state.address!.result.suggestions![index].name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 0.5.h,
          color: Colors.grey[400],
          width: double.infinity,
        ),
      ],
    );
  }
}
