import 'dart:async';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/model/point.dart' as pointModel;
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/model/type_add.dart';
import 'package:egorka/model/user.dart';
import 'package:egorka/widget/allert_dialog.dart';
import 'package:egorka/widget/buttons.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as yandex_mapkit;

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

  String? errorAddress1;
  String? errorAddress2;

  TypeAdd? typeAdd;

  Suggestions? suggestionsStart;
  Suggestions? suggestionsEnd;

  CoastResponse? coastResponse;
  List<CoastResponse> coasts = [];

  bool iconState = true;

  yandex_mapkit.DrivingSessionResult? directions;
  yandex_mapkit.BicycleSessionResult? directionsBicycle;
  List<yandex_mapkit.PlacemarkMapObject> markers = [];

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
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    stream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<SearchAddressBloc, SearchAddressState>(
          buildWhen: (previous, current) {
        if (current is GetAddressSuccess) {
          errorAddress1 = current.errorAddress != null ? 'ошибка' : null;
          suggestionsStart = Suggestions(
            iD: null,
            name: current.address,
            point: pointModel.Point(
              address: current.address,
              code: '${current.latitude},${current.longitude}',
              latitude: current.latitude,
              longitude: current.longitude,
            ),
          );
          fromController.text = current.address;

          calc();

          if (suggestionsStart != null &&
              suggestionsEnd != null &&
              errorAddress1 == null) {
            iconState = false;
          }
        }
        return true;
      }, builder: (context, snapshot) {
        var bloc = BlocProvider.of<SearchAddressBloc>(context);
        return SlidingUpPanel(
          controller: panelController,
          renderPanelSheet: false,
          isDraggable: false,
          panelSnapping: false,
          backdropEnabled: true,
          parallaxEnabled: true,
          panel: _floatingPanel(context),
          onPanelClosed: () {
            focusFrom.unfocus();
            focusTo.unfocus();
            _visible = false;
          },
          onPanelOpened: () {
            _visible = true;
            if (!focusFrom.hasFocus && !focusTo.hasFocus) {
              // panelController.close();
            }
          },
          onPanelSlide: (size) {
            if (size.toStringAsFixed(1) == (0.5).toString()) {
              focusFrom.unfocus();
              focusTo.unfocus();
            }
          },
          maxHeight: 735.h,
          minHeight: snapshot is SearchAddressRoutePolilyne || bloc.isPolilyne
              ? 400.h
              : 250.h,
          defaultPanelState: PanelState.CLOSED,
        );
      }),
    );
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: iconState ? 25.w : 16.w,
                  child: Image.asset(
                    'assets/images/city.png',
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: iconState ? 10.w : 6.w,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    'ОБЫЧНАЯ ДОСТАВКА',
                    style: TextStyle(
                      fontSize: iconState ? 14.sp : 10.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
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
                                onTap: () async {
                                  typeAdd = TypeAdd.sender;
                                  await panelController.animatePanelToPosition(
                                    1,
                                    duration: Duration(milliseconds: 200),
                                  );
                                  bloc.add(SearchAddressClear());
                                  if (!focusFrom.hasFocus) {
                                    focusFrom.requestFocus();
                                  }
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
                            fromController.text.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(right: 15.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        bloc.add(DeletePolilyneEvent());
                                        fromController.text = '';
                                        stream.add('event');
                                        coasts.clear();
                                        setState(() {
                                          iconState = true;
                                        });
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
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(right: 5.w),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.h),
                                          child: Container(
                                            color: Colors.grey[300],
                                            width: 1,
                                            height: 40.h,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final res =
                                                await Navigator.of(context)
                                                    .pushNamed(
                                                        AppRoute.selectPoint);
                                            if (res != null &&
                                                res is Suggestions) {
                                              suggestionsStart = res;
                                              fromController.text =
                                                  suggestionsStart!.name;

                                              errorAddress1 =
                                                  res.houseNumber == null
                                                      ? 'Укажите номер дома'
                                                      : null;
                                              calc();
                                            }
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10.r),
                                                  topRight:
                                                      Radius.circular(10.r),
                                                ),
                                              ),
                                            ),
                                            backgroundColor:
                                                const MaterialStatePropertyAll(
                                                    Colors.transparent),
                                            foregroundColor:
                                                const MaterialStatePropertyAll(
                                                    Colors.white),
                                            overlayColor:
                                                MaterialStatePropertyAll(
                                              Colors.grey[400],
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Карта',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.sp),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                              onChanged: (value) {},
                            ),
                            Expanded(
                              child: CustomTextField(
                                height: 45.h,
                                onTap: () async {
                                  typeAdd = TypeAdd.receiver;
                                  await panelController.animatePanelToPosition(
                                    1,
                                    duration: Duration(milliseconds: 200),
                                  );
                                  bloc.add(SearchAddressClear());
                                  if (!focusTo.hasFocus) {
                                    focusTo.requestFocus();
                                  }
                                },
                                onFieldSubmitted: (text) {
                                  panelController.close();
                                  focusTo.unfocus();
                                },
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
                            SizedBox(width: 10.w),
                            toController.text.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(right: 15.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        bloc.add(DeletePolilyneEvent());
                                        toController.text = '';
                                        stream.add('event');
                                        coasts.clear();
                                        setState(() {
                                          iconState = true;
                                        });
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
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(right: 5.w),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.h),
                                          child: Container(
                                            color: Colors.grey[300],
                                            width: 1,
                                            height: 40.h,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            focusFrom.unfocus();
                                            final res =
                                                await Navigator.of(context)
                                                    .pushNamed(
                                                        AppRoute.selectPoint);
                                            if (res != null &&
                                                res is Suggestions) {
                                              suggestionsEnd = res;
                                              toController.text =
                                                  suggestionsEnd!.name;

                                              errorAddress2 =
                                                  res.houseNumber == null
                                                      ? 'Укажите номер дома'
                                                      : null;
                                              calc();
                                            }
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10.r),
                                                  topRight:
                                                      Radius.circular(10.r),
                                                ),
                                              ),
                                            ),
                                            backgroundColor:
                                                const MaterialStatePropertyAll(
                                                    Colors.transparent),
                                            foregroundColor:
                                                const MaterialStatePropertyAll(
                                                    Colors.white),
                                            overlayColor:
                                                MaterialStatePropertyAll(
                                              Colors.grey[400],
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Карта',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.sp),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                    errorAddress1 = current.errorAddress;
                    if (fromController.text != current.address) {
                      suggestionsStart = Suggestions(
                        iD: null,
                        name: current.address,
                        point: pointModel.Point(
                          address: current.address,
                          code: '${current.latitude},${current.longitude}',
                          latitude: current.latitude,
                          longitude: current.longitude,
                        ),
                      );
                      fromController.text = current.address;
                    }
                  }
                  if (current is SearchLoading) {
                    setState(() {
                      iconState = false;
                    });
                  }
                  if (current is SearchAddressRoutePolilyne) {
                    if (current.coasts.isNotEmpty) {
                      coasts.addAll(current.coasts);
                      coastResponse = current.coasts.first;
                      streamDelivery.add(0);
                    }
                    setState(() {
                      iconState = false;
                    });
                  }
                  if (current is FindMeState) return false;
                  if (current is EditPolilynesState) return false;

                  return true;
                },
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text('Егорка рассчитывает стоимость'),
                        CupertinoActivityIndicator(),
                      ],
                    );
                  }
                  if (state is SearchAddressLoading) {
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
                  } else if (state is SearchAddressRoutePolilyne ||
                      state is EditPolilynesState ||
                      state is SearchAddressStated) {
                    if (state is SearchAddressStated && coasts.isEmpty) {
                      return const SizedBox();
                    }
                    if (state is SearchAddressRoutePolilyne) {
                      directions = state.directions;
                      directionsBicycle = state.directionsBicycle;
                      markers = state.markers;
                    }
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
                            onTap: () => calc(),
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

                    return SizedBox(
                      height: 100.h,
                      child: ListView.builder(
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
                                if (index != snapshot.data) {
                                  BlocProvider.of<SearchAddressBloc>(context)
                                      .add(EditPolilynesEvent(
                                    directions: index == 1 ? directions : null,
                                    directionsBicycle:
                                        index == 0 ? directionsBicycle : null,
                                    markers: markers,
                                  ));
                                }
                              },
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
                                    Opacity(
                                      opacity:
                                          snapshot.data! == index ? 1 : 0.3,
                                      child: SizedBox(
                                        height: 45.h,
                                        child: Image.asset(
                                          listChoice[index].icon,
                                          color: snapshot.data! == index
                                              ? Colors.black
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity:
                                          snapshot.data! == index ? 1 : 0.3,
                                      child: Text(
                                        listChoice[index].title,
                                        style: TextStyle(
                                            color: snapshot.data! == index
                                                ? Colors.black
                                                : Colors.black,
                                            fontWeight: snapshot.data! == index
                                                ? FontWeight.w600
                                                : FontWeight.w400),
                                      ),
                                    ),
                                    Text(
                                      '${double.tryParse(coasts[index].result!.totalPrice!.total!)!.ceil()} ₽',
                                      style: TextStyle(
                                          color: snapshot.data! == index
                                              ? Colors.black
                                              : Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
                              if (errorAddress1 != null ||
                                  errorAddress2 != null) {
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
                          child: Text(
                            'Перейти к оформлению',
                            style: CustomTextStyle.white15w600,
                          ),
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
    var bloc = BlocProvider.of<SearchAddressBloc>(context);

    if (user != null) {
      final res = await Navigator.of(context).pushNamed(
        AppRoute.newOrder,
        arguments: [
          coastResponse,
          listChoice[index],
          suggestionsStart ??
              Suggestions(
                iD: null,
                name: coastResponse!.result!.locations!.first.point!.address!,
                point: pointModel.Point(
                  latitude:
                      coastResponse!.result!.locations!.first.point!.latitude!,
                  longitude:
                      coastResponse!.result!.locations!.first.point!.longitude!,
                ),
              ),
          suggestionsEnd,
        ],
      );
      if (res is bool) {
        bloc.add(DeletePolilyneEvent());
        fromController.text = '';
        toController.text = '';

        suggestionsStart = null;
        suggestionsEnd = null;

        coasts.clear();
        setState(() {
          iconState = true;
        });
        stream.add('event');
      }
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
                  onTap: () async {
                    Navigator.of(context).pop();
                    final res = await Navigator.of(context).pushNamed(
                      AppRoute.newOrder,
                      arguments: [
                        coastResponse,
                        listChoice[index],
                        suggestionsStart,
                        suggestionsEnd,
                      ],
                    );
                    if (res is bool) {
                      bloc.add(DeletePolilyneEvent());
                      fromController.text = '';
                      toController.text = '';

                      suggestionsStart = null;
                      suggestionsEnd = null;

                      coasts.clear();
                      setState(() {
                        iconState = true;
                      });
                      stream.add('event');
                    }
                  }),
              StandartButton(
                label: 'Да',
                color: Colors.green,
                onTap: () async {
                  final result =
                      await Navigator.pushNamed(context, AppRoute.auth);
                  if (result != null) {
                    BlocProvider.of<ProfileBloc>(context)
                        .add(ProfileEventUpdate(result as AuthUser));
                    Navigator.of(context).pop();
                    final res = await Navigator.of(context).pushNamed(
                      AppRoute.newOrder,
                      arguments: [
                        coastResponse,
                        listChoice[index],
                        suggestionsStart,
                        suggestionsEnd,
                      ],
                    );
                    if (res is bool) {
                      bloc.add(DeletePolilyneEvent());
                      fromController.text = '';
                      toController.text = '';

                      suggestionsStart = null;
                      suggestionsEnd = null;

                      coasts.clear();
                      setState(() {
                        iconState = true;
                      });
                      stream.add('event');
                    }
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
              if (focusFrom.hasFocus) {
                errorAddress1 = null;
                suggestionsStart = state.address!.result.suggestions![index];
                fromController.text =
                    state.address!.result.suggestions![index].name;
              } else if (focusTo.hasFocus) {
                errorAddress2 = null;
                suggestionsEnd = state.address!.result.suggestions![index];
                toController.text =
                    state.address!.result.suggestions![index].name;
              }

              if (fromController.text.isNotEmpty &&
                  toController.text.isNotEmpty) {
                calc();
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

  void calc() {
    if (fromController.text.isNotEmpty && toController.text.isNotEmpty) {
      coasts.clear();
      BlocProvider.of<SearchAddressBloc>(context)
          .add(SearchAddressPolilyne([suggestionsStart!], [suggestionsEnd!]));
    }
  }
}
