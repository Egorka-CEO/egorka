import 'dart:async';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:egorka/widget/allert_dialog.dart';
import 'package:egorka/widget/buttons.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomSheetDraggable extends StatefulWidget {
  const BottomSheetDraggable({Key? key});

  @override
  State<BottomSheetDraggable> createState() => _BottomSheetDraggableState();
}

class _BottomSheetDraggableState extends State<BottomSheetDraggable> {
  final TextEditingController fromController = TextEditingController();

  final TextEditingController toController = TextEditingController();

  FocusNode focusFrom = FocusNode();

  FocusNode focusTo = FocusNode();

  PanelController panelController = PanelController();

  final stream = StreamController();

  final streamDelivery = StreamController<int>();

  bool _visible = false;

  TypeAdd? typeAdd;

  List<DeliveryChocie> listChoice = [
    DeliveryChocie(title: 'Байк', icon: 'assets/images/ic_bike.png'),
    DeliveryChocie(title: 'Легковая', icon: 'assets/images/ic_car.png'),
    DeliveryChocie(title: 'Грузовая', icon: 'assets/images/ic_track.png'),
    DeliveryChocie(title: 'Пешком', icon: 'assets/images/ic_leg.png'),
  ];

  bool showFront = true;
  FlipCardController? _flipController;
  @override
  void initState() {
    super.initState();
    _flipController = FlipCardController();
  }

  @override
  void dispose() {
    stream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchAddressBloc, SearchAddressState>(
        builder: (context, snapshot) {
      var bloc = BlocProvider.of<SearchAddressBloc>(context);
      return SlidingUpPanel(
        controller: panelController,
        renderPanelSheet: false,
        panel: _floatingPanel(context),
        onPanelClosed: () {
          focusFrom.unfocus();
          focusTo.unfocus();
          _visible = false;
        },
        onPanelOpened: () {
          _visible = true;
          if (!focusFrom.hasFocus && !focusTo.hasFocus) {
            panelController.close();
          }
        },
        onPanelSlide: (size) {
          if (size.toStringAsFixed(1) == (0.5).toString()) {
            focusFrom.unfocus();
            focusTo.unfocus();
            // if (_flipController!.state!.isFront) {
            if (focusFrom.hasFocus || focusTo.hasFocus) {
              _flipController!.toggleCard();
            }
            // }
          }
        },
        maxHeight: 735.h,
        minHeight: bloc.isPolilyne ? 370.h : 215.h,
        defaultPanelState: PanelState.CLOSED,
      );
    });
  }

  Widget _floatingPanel(BuildContext context) {
    var bloc = BlocProvider.of<SearchAddressBloc>(context);
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
        color: backgroundColor.withOpacity(1),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 10.w,
              left: ((MediaQuery.of(context).size.width * 47) / 100).w,
              right: ((MediaQuery.of(context).size.width * 47) / 100).w,
              bottom: 10.w,
            ),
            child: Container(
              height: 5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: Colors.grey[400],
              ),
            ),
          ),
          StreamBuilder<dynamic>(
            stream: stream.stream,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      height: 55.h,
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
                              fillColor: MaterialStateProperty.all(Colors.red),
                              shape: const CircleBorder(),
                              onChanged: ((value) {}),
                            ),
                            Expanded(
                              child: CustomTextField(
                                height: 45.h,
                                onTap: () {
                                  if (_flipController!.state!.isFront) {
                                    _flipController!.toggleCard();
                                  }
                                  typeAdd = TypeAdd.sender;
                                  panelController.open();
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    focusFrom.requestFocus();
                                  });
                                  bloc.add(SearchAddressClear());
                                },
                                focusNode: focusFrom,
                                fillColor: Colors.white.withOpacity(0),
                                hintText: 'Откуда забрать?',
                                onFieldSubmitted: (text) {
                                  panelController.close();
                                  focusFrom.unfocus();
                                },
                                contentPadding: EdgeInsets.only(right: 10.w),
                                textEditingController: fromController,
                                onChanged: (value) {
                                  bloc.add(SearchAddress(value));
                                },
                              ),
                            ),
                            SizedBox(width: 10.w),
                            FlipCard(
                              controller: _flipController,
                              back: GestureDetector(
                                onTap: () {
                                  bloc.add(DeletePolilyneEvent());
                                  fromController.text = '';
                                  stream.add('event');
                                },
                                child: Container(
                                  height: 20.h,
                                  width: 20.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[500],
                                  ),
                                  child: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                              front: GestureDetector(
                                onTap: () {
                                  focusFrom.unfocus();
                                  focusTo.unfocus();
                                  panelController.close();
                                  bloc.add(SearchMeEvent());
                                },
                                child: const Icon(
                                  Icons.gps_fixed,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      height: 55.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Colors.white,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: false,
                              fillColor: MaterialStateProperty.all(Colors.blue),
                              shape: const CircleBorder(),
                              onChanged: ((value) {}),
                            ),
                            Expanded(
                              child: CustomTextField(
                                height: 45.h,
                                onTap: () {
                                  if (!_flipController!.state!.isFront) {
                                    _flipController!.toggleCard();
                                  }
                                  typeAdd = TypeAdd.receiver;
                                  panelController.open();
                                  bloc.add(SearchAddressClear());
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    focusTo.requestFocus();
                                  });
                                },
                                onFieldSubmitted: (text) {
                                  panelController.close();
                                  focusTo.unfocus();
                                },
                                // enabled: !bloc.isPolilyne,
                                contentPadding: EdgeInsets.only(right: 10.w),
                                focusNode: focusTo,
                                fillColor: Colors.white.withOpacity(0),
                                hintText: 'Куда отвезти?',
                                textEditingController: toController,
                                onChanged: (value) {
                                  stream.add('event');
                                  bloc.add(SearchAddress(value));
                                },
                              ),
                            ),
                            focusTo.hasFocus
                                ? GestureDetector(
                                    onTap: () {
                                      bloc.add(DeletePolilyneEvent());
                                      toController.text = '';
                                      stream.add('event');
                                      if (focusFrom.hasFocus) {
                                        _flipController?.toggleCard();
                                      }
                                    },
                                    child: Container(
                                      height: 20.h,
                                      width: 20.h,
                                      margin: const EdgeInsets.only(
                                          right: 5, left: 10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[500],
                                      ),
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _searchList(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _searchList() {
    return StreamBuilder<int>(
        stream: streamDelivery.stream,
        initialData: 1,
        builder: (context, snapshot) {
          var blocs = BlocProvider.of<SearchAddressBloc>(context);
          return Column(
            children: [
              SizedBox(height: 10.h),
              SizedBox(
                height:
                    blocs.isPolilyne && !focusFrom.hasFocus && !focusTo.hasFocus
                        ? 95.h
                        : null,
                child: BlocBuilder<SearchAddressBloc, SearchAddressState>(
                  buildWhen: (previous, current) {
                    if (current is ChangeAddressSuccess) {
                      if (fromController.text != current.geoData!.address) {
                        fromController.text = current.geoData!.address;
                      }
                    }
                    return true;
                  },
                  builder: (context, state) {
                    var bloc = BlocProvider.of<SearchAddressBloc>(context);
                    if (state is SearchAddressStated) {
                      return const SizedBox();
                    } else if (state is SearchAddressLoading) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      );
                    } else if (state is SearchAddressSuccess) {
                      if (_visible) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount:
                                state.address!.result.suggestions!.length,
                            itemBuilder: (context, index) {
                              return _pointCard(state, index, context);
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else if (blocs.isPolilyne &&
                        !focusFrom.hasFocus &&
                        !focusTo.hasFocus) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listChoice.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 20.w : 0,
                              right: index == listChoice.length - 1 ? 5.w : 0,
                            ),
                            child: GestureDetector(
                              onTap: () => streamDelivery.add(index),
                              child: Opacity(
                                opacity: snapshot.data! == index ? 1 : 0.3,
                                child: Container(
                                  width: 80.w,
                                  decoration: BoxDecoration(
                                    color: snapshot.data! == index
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 45.h,
                                        child: Image.asset(
                                          listChoice[index].icon,
                                          color: snapshot.data! == index
                                              ? Colors.black
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        listChoice[index].title,
                                        style: TextStyle(
                                          color: snapshot.data! == index
                                              ? Colors.black
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '1999₽',
                                        style: TextStyle(
                                          color: snapshot.data! == index
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    } else {
                      return const Text('');
                    }
                  },
                ),
              ),
              SizedBox(height: 10.h),
              if (blocs.isPolilyne && !focusFrom.hasFocus && !focusTo.hasFocus)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GestureDetector(
                    onTap: authShowDialog,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: const Center(
                        child: Text('Перейти к оформлению',
                            style: CustomTextStyle.white15w600),
                      ),
                    ),
                  ),
                )
            ],
          );
        });
  }

  void authShowDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return StandartAlertDialog(
            message: 'Хотите авторизоваться?',
            buttons: [
              StandartButton(
                label: 'Нет',
                color: Colors.red.withOpacity(0.9),
                onTap: () => Navigator.of(context)
                  ..pop()
                  ..pushNamed(AppRoute.newOrder),
              ),
              StandartButton(
                label: 'Да',
                color: Colors.green,
                onTap: () => Navigator.pushNamed(context, AppRoute.auth).then(
                  (value) {
                    Navigator.of(context)
                      ..pop()
                      ..pushNamed(AppRoute.newOrder);
                  },
                ),
              )
            ],
          );
        });
  }

  Column _pointCard(
      SearchAddressSuccess state, int index, BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5.w, bottom: 5.w),
          height: 50.h,
          child: InkWell(
            onTap: () {
              if (!_flipController!.state!.isFront) {
                _flipController!.toggleCard();
              }
              if (focusFrom.hasFocus) {
                fromController.text =
                    state.address!.result.suggestions![index].name;
              } else if (focusTo.hasFocus) {
                toController.text =
                    state.address!.result.suggestions![index].name;
              }

              if (toController.text.isNotEmpty &&
                  toController.text.isNotEmpty) {
                BlocProvider.of<SearchAddressBloc>(context).add(
                    SearchAddressPolilyne(
                        fromController.text, toController.text));
              } else {
                BlocProvider.of<SearchAddressBloc>(context).add(
                  JumpToPointEvent(
                    state.address!.result.suggestions![index].point!,
                  ),
                );
              }

              focusFrom.unfocus();
              focusTo.unfocus();
              panelController.close();

              stream.add('event');
            },
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomWidget.iconGPSSmall(
                        color: typeAdd == TypeAdd.sender
                            ? Colors.red
                            : Colors.blue),
                  ),
                ),
                SizedBox(width: 15.w),
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
