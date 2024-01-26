import 'dart:async';
import 'package:egorka/core/bloc/new_order/new_order_bloc.dart';
import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/model/address.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/model/type_add.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddAddressBottomSheetDraggable extends StatefulWidget {
  TextEditingController fromController;
  PanelController panelController;
  TypeAdd? typeAdd;
  void Function(Suggestions) onSearch;
  AddAddressBottomSheetDraggable({
    Key? key,
    required this.typeAdd,
    required this.fromController,
    required this.panelController,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<AddAddressBottomSheetDraggable> createState() =>
      _BottomSheetDraggableState();
}

class _BottomSheetDraggableState extends State<AddAddressBottomSheetDraggable> {
  FocusNode focusFrom = FocusNode();

  Address? address;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: AppConsts.textScalerStd,),
      child: BlocBuilder<NewOrderPageBloc, NewOrderState>(
          buildWhen: (previous, current) {
        if (current is NewOrderStatedOpenBtmSheet) {
          Future.delayed(const Duration(milliseconds: 600), () {
            focusFrom.requestFocus();
          });
        }
        return true;
      }, builder: (context, snapshot) {
        return _floatingPanel(context);
      }),
    );
  }

  Widget _floatingPanel(BuildContext context) {
    var bloc = BlocProvider.of<NewOrderPageBloc>(context);
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
        color: AppConsts.backgroundColor.withOpacity(1),
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
          if (widget.typeAdd != null)
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
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
                              fillColor: Colors.white.withOpacity(0),
                              hintText: widget.typeAdd == TypeAdd.sender
                                  ? 'Откуда забрать?'
                                  : 'Куда отвезти?',
                              onFieldSubmitted: (text) {
                                focusFrom.unfocus();
                              },
                              textEditingController: widget.fromController,
                              onChanged: (value) {
                                bloc.add(NewOrder(value));
                              },
                            ),
                          ),
                          SizedBox(width: 15.w),
                          TextButton(
                            onPressed: () async {
                              focusFrom.unfocus();
                              final res = await Navigator.of(context)
                                  .pushNamed(AppRoute.selectPoint);
                              if (res != null && res is Suggestions) {
                                widget.onSearch(res);
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10.r),
                                    topRight: Radius.circular(10.r),
                                  ),
                                ),
                              ),
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.transparent),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                              overlayColor: MaterialStatePropertyAll(
                                Colors.grey[400],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Карта',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.w),
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
          child: BlocBuilder<NewOrderPageBloc, NewOrderState>(
            buildWhen: (previous, current) {
              if (current is NewOrderSuccess) {
                address = current.address;
              }
              return true;
            },
            builder: ((context, state) {
              if (state is NewOrderStated) {
                return const SizedBox();
              } else if (state is NewOrderLoading) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CupertinoActivityIndicator()],
                );
              } else if (state is NewOrderSuccess) {
                return address != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
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

  Widget _pointCard(NewOrderSuccess state, int index, BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
          height: 50.h,
          child: InkWell(
            onTap: () {
              BlocProvider.of<NewOrderPageBloc>(context).add(
                  NewOrderStatedCloseBtmSheet(
                      state.address!.result.suggestions![index]));
              widget.fromController.text =
                  state.address!.result.suggestions![index].name;
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
