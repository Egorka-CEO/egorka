import 'dart:async';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/model/point.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/model/type_add.dart';
import 'package:egorka/model/user.dart';
import 'package:egorka/widget/allert_dialog.dart';
import 'package:egorka/widget/buttons.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
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

  String? errorAddress;

  TypeAdd? typeAdd;

  Suggestions? suggestionsStart;
  Suggestions? suggestionsEnd;

  CoastResponse? coastResponse;
  List<CoastResponse> coasts = [];

  List<DeliveryChocie> listChoice = [
    DeliveryChocie(
      title: 'Пешком',
      icon: 'assets/images/ic_leg.png',
      type: 'Walk',
    ),
    DeliveryChocie(
      title: 'Легковая',
      icon: 'assets/images/ic_car.png',
      type: 'Car',
    ),
    // DeliveryChocie(title: 'Байк', icon: 'assets/images/ic_bike.png'),
    // DeliveryChocie(title: 'Грузовая', icon: 'assets/images/ic_track.png'),
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
        buildWhen: (previous, current) {
      if (current is GetAddressSuccess) {
        errorAddress = current.errorAddress;
        suggestionsStart = Suggestions(
          iD: null,
          name: current.address,
          point: Point(
            address: current.address,
            code: '${current.latitude},${current.longitude}',
            latitude: current.latitude,
            longitude: current.longitude,
          ),
        );
        fromController.text = current.address;

        if (fromController.text.isNotEmpty && toController.text.isNotEmpty) {
          coasts.clear();
          BlocProvider.of<SearchAddressBloc>(context)
              .add(SearchAddressPolilyne([suggestionsStart], [suggestionsEnd]));
        }
      }
      return true;
    }, builder: (context, snapshot) {
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
        minHeight: snapshot is SearchAddressRoutePolilyne || bloc.isPolilyne
            ? 370.h
            : 215.h,
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
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
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
                                  // panelController.close();
                                  bloc.add(GetAddressPosition());
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
    var blocs = BlocProvider.of<SearchAddressBloc>(context);
    return StreamBuilder<int>(
      initialData: 0,
      stream: streamDelivery.stream,
      builder: (context, snapshot) {
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
                    errorAddress = current.errorAddress;
                    if (fromController.text != current.address) {
                      suggestionsStart = Suggestions(
                        iD: null,
                        name: current.address,
                        point: Point(
                          address: current.address,
                          code: '${current.latitude},${current.longitude}',
                          latitude: current.latitude,
                          longitude: current.longitude,
                        ),
                      );
                      fromController.text = current.address;
                    }
                  }
                  if (current is SearchAddressRoutePolilyne) {
                    if (current.coasts.isNotEmpty) {
                      coasts.addAll(current.coasts);
                      coastResponse = current.coasts.first;
                      streamDelivery.add(0);
                    }
                  }
                  if (current is FindMeState) return false;

                  return true;
                },
                builder: (context, state) {
                  var bloc = BlocProvider.of<SearchAddressBloc>(context);
                  if (state is SearchLoading) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text('Егорка рассчитывает стоимость'),
                        CupertinoActivityIndicator(),
                      ],
                    );
                  }
                  if (state is SearchAddressStated) {
                    return const SizedBox();
                  } else if (state is SearchAddressLoading) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [CupertinoActivityIndicator()],
                    );
                  } else if (state is SearchAddressSuccess) {
                    if (_visible) {
                      return Padding(
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
                      );
                    } else {
                      return Container();
                    }
                  } else if (state is SearchAddressRoutePolilyne) {
                    if (coasts.isEmpty) {
                      return Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                          const Text(
                            'У Егорки не получилось рассчитать стоимость',
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (toController.text.isNotEmpty &&
                                  toController.text.isNotEmpty) {
                                BlocProvider.of<SearchAddressBloc>(context).add(
                                    SearchAddressPolilyne([suggestionsStart!],
                                        [suggestionsEnd!]));
                              }
                            },
                            child: const Text(
                              'Повторите еще раз',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listChoice.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 20.w : 0,
                            right: index == coasts.length - 1 ? 5.w : 0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              coastResponse = coasts[index];
                              streamDelivery.add(index);
                            },
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
                                      '${double.tryParse(coasts[index].result!.totalPrice!.total!)!.ceil()} ₽',
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
                      },
                    );
                  } else {
                    return const Text('');
                  }
                },
              ),
            ),
            SizedBox(height: 10.h),
            if (blocs.isPolilyne && !focusFrom.hasFocus && !focusTo.hasFocus)
              BlocBuilder<SearchAddressBloc, SearchAddressState>(
                builder: (context, state) {
                  var bloc = BlocProvider.of<SearchAddressBloc>(context);
                  if (state is SearchAddressRoutePolilyne) {
                    coasts.addAll(state.coasts);
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GestureDetector(
                      onTap: coasts.isNotEmpty
                          ? () {
                              if (errorAddress != null) {
                                MessageDialogs()
                                    .showAlert('Ошибка', 'Укажите номер дома');
                              } else {
                                authShowDialog(snapshot.data!);
                              }
                            }
                          : null,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          color: coasts.isNotEmpty
                              ? Colors.red
                              : Colors.red.shade300,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: const Center(
                          child: Text('Перейти к оформлению',
                              style: CustomTextStyle.white15w600),
                        ),
                      ),
                    ),
                  );
                },
              )
          ],
        );
      },
    );
  }

  void authShowDialog(int index) async {
    final user = BlocProvider.of<ProfileBloc>(context).getUser();

    if (user != null) {
      Navigator.of(context).pushNamed(AppRoute.newOrder, arguments: [
        coastResponse,
        listChoice[index],
        suggestionsStart ??
            Suggestions(
                iD: null,
                name: coastResponse!.result!.locations!.first.point!.address!,
                point: Point(
                    latitude: coastResponse!
                        .result!.locations!.first.point!.latitude!,
                    longitude: coastResponse!
                        .result!.locations!.first.point!.longitude!)),
        suggestionsEnd,
      ]);
    } else {
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
                  ..pushNamed(AppRoute.newOrder, arguments: [
                    coastResponse,
                    listChoice[index],
                    suggestionsStart,
                    suggestionsEnd,
                  ]),
              ),
              StandartButton(
                label: 'Да',
                color: Colors.green,
                onTap: () async {
                  final result =
                      await Navigator.pushNamed(context, AppRoute.auth);
                  if (result != null) {
                    BlocProvider.of<ProfileBloc>(context)
                        .add(ProfileEventUpdate(result as AuthUser));
                    Navigator.of(context)
                      ..pop()
                      ..pushNamed(AppRoute.newOrder, arguments: [
                        coastResponse,
                        listChoice[index],
                        suggestionsStart,
                        suggestionsEnd,
                      ]);
                  }
                },
              )
            ],
          );
        },
      );
    }
  }

  Widget _pointCard(
      SearchAddressSuccess state, int index, BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5.w, bottom: 5.w),
          height: 50.h,
          child: GestureDetector(
            onTap: () {
              if (!_flipController!.state!.isFront) {
                _flipController!.toggleCard();
              }
              if (focusFrom.hasFocus) {
                errorAddress = null;
                suggestionsStart = state.address!.result.suggestions![index];
                fromController.text =
                    state.address!.result.suggestions![index].name;
                // BlocProvider.of<SearchAddressBloc>(context)
                //     .add(DeleteGeoDateEvent());
              } else if (focusTo.hasFocus) {
                suggestionsEnd = state.address!.result.suggestions![index];
                toController.text =
                    state.address!.result.suggestions![index].name;
              }

              if (fromController.text.isNotEmpty &&
                  toController.text.isNotEmpty) {
                coasts.clear();
                BlocProvider.of<SearchAddressBloc>(context).add(
                    SearchAddressPolilyne(
                        [suggestionsStart], [suggestionsEnd]));
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
