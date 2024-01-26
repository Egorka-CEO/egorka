import 'dart:async';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/app_colors.dart';
import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/model/choice_delivery.dart';
import 'package:egorka/model/coast_marketplace.dart';
import 'package:egorka/model/locations.dart';
import 'package:egorka/model/marketplaces.dart';
import 'package:egorka/model/point.dart' as point_model;
import 'package:egorka/model/point.dart';
import 'package:egorka/model/point_marketplace.dart';
import 'package:egorka/model/response_coast_base.dart';
import 'package:egorka/model/suggestions.dart';
import 'package:egorka/model/type_add.dart';
import 'package:egorka/model/type_group.dart';
import 'package:egorka/model/user.dart';
import 'package:egorka/widget/allert_dialog.dart';
import 'package:egorka/widget/buttons.dart';
import 'package:egorka/widget/custom_button.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as yandex_mapkit;

class BottomSheetDraggable extends StatefulWidget {
  const BottomSheetDraggable({Key? key}) : super(key: key);

  @override
  State<BottomSheetDraggable> createState() => _BottomSheetDraggableState();
}

class _BottomSheetDraggableState extends State<BottomSheetDraggable>
    with TickerProviderStateMixin {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  FocusNode focusFrom = FocusNode();
  FocusNode focusTo = FocusNode();

  PanelController panelController = PanelController();

  final streamDelivery = StreamController<int>();

  TypeAdd? typeAdd;

  Suggestions? suggestionsStart;
  Suggestions? suggestionsEnd;

  CoastResponse? coastResponse;
  List<CoastResponse> coasts = [];

  yandex_mapkit.DrivingSessionResult? directionsCar;
  yandex_mapkit.BicycleSessionResult? directionsBicycle;
  List<yandex_mapkit.PlacemarkMapObject> markers = [];

  double maxHeightPanel = 840.h;

  late TabController controller;

  TypeGroup typeGroup = TypeGroup.express;

  List<DeliveryChocie> listChoice = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: AppConsts.textScalerStd,),
      child: BlocBuilder<SearchAddressBloc, SearchAddressState>(
        buildWhen: (previous, current) {
          if (current is GetAddressSuccess) {
            suggestionsStart = Suggestions(
              iD: null,
              name: current.address,
              point: point_model.Point(
                address: current.address,
                code: '${current.latitude},${current.longitude}',
                latitude: current.latitude,
                longitude: current.longitude,
              ),
            );
            fromController.text = current.address;

            calc();
          } else if (current is DeletePolilyneState) {
            panelController.animatePanelToPosition(
              0,
              duration: const Duration(milliseconds: 400),
            );
          }
          return true;
        },
        builder: (context, snapshot) {
          var bloc = BlocProvider.of<SearchAddressBloc>(context);
          return SlidingUpPanel(
            controller: panelController,
            renderPanelSheet: false,
            isDraggable: false,
            panelSnapping: false,
            // backdropEnabled: true,
            parallaxEnabled: true,
            panel: _floatingPanel(context),
            onPanelClosed: () {
              focusFrom.unfocus();
              focusTo.unfocus();
            },
            onPanelOpened: () {
              if (!focusFrom.hasFocus && !focusTo.hasFocus) {}
            },
            onPanelSlide: (size) {
              if (size.toStringAsFixed(1) == (0.5).toString()) {
                focusFrom.unfocus();
                focusTo.unfocus();
              }
            },
            maxHeight: maxHeightPanel,
            // minHeight: snapshot is SearchAddressRoutePolilyne || bloc.isPolilyne
            minHeight: !bloc.isPolilyne ? 350.h : 420.h,
            // : 310.h,
            defaultPanelState: PanelState.CLOSED,
          );
        },
      ),
    );
  }

  Widget _floatingPanel(BuildContext context) {
    var bloc = BlocProvider.of<SearchAddressBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        suggestionsStart == null ||
                (suggestionsEnd != null && suggestionsStart == null)
            ? ScaleButton(
                onTap: () {
                  BlocProvider.of<SearchAddressBloc>(context)
                      .add(GetAddressPosition());
                },
                bound: 0.05,
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  height: 50.h,
                  width: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1000),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 1.r,
                        offset: const Offset(1, 1),
                      )
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/cursor.svg',
                      height: 25.h,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            : SizedBox(height: 50.h),
        Container(
          height: maxHeightPanel - 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.r),
              topRight: Radius.circular(32.r),
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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        typeGroup = TypeGroup.express;
                        suggestionsStart = null;
                        suggestionsEnd = null;
                        coasts.clear();
                        focusFrom.unfocus();
                        focusTo.unfocus();
                        panelController.animatePanelToPosition(
                          0,
                          duration: const Duration(milliseconds: 400),
                        );
                        fromController.text = '';
                        toController.clear();
                        bloc.add(DeletePolilyneEvent());
                        setState(() {});
                      },
                      child: Container(
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: typeGroup == TypeGroup.express
                              ? const Color.fromRGBO(255, 102, 102, 1)
                              : AppColors.grey,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Text(
                            'Город',
                            style: GoogleFonts.manrope(
                              color: typeGroup == TypeGroup.express
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.5),
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        typeGroup = TypeGroup.fbo;
                        suggestionsStart = null;
                        suggestionsEnd = null;
                        coasts.clear();
                        focusFrom.unfocus();
                        focusTo.unfocus();
                        panelController.animatePanelToPosition(
                          0,
                          duration: const Duration(milliseconds: 400),
                        );
                        fromController.text = '';
                        toController.clear();
                        bloc.add(DeletePolilyneEvent());
                        setState(() {});
                      },
                      child: Container(
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: typeGroup == TypeGroup.fbo
                              ? const Color.fromRGBO(255, 102, 102, 1)
                              : AppColors.grey,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 19.w, vertical: 10.h),
                          child: Text(
                            'FBO',
                            style: GoogleFonts.manrope(
                              color: typeGroup == TypeGroup.fbo
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.5),
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        typeGroup = TypeGroup.fbs;
                        suggestionsStart = null;
                        suggestionsEnd = null;
                        coasts.clear();
                        focusFrom.unfocus();
                        focusTo.unfocus();
                        panelController.animatePanelToPosition(
                          0,
                          duration: const Duration(milliseconds: 400),
                        );
                        fromController.text = '';
                        toController.clear();
                        bloc.add(DeletePolilyneEvent());
                        setState(() {});
                      },
                      child: Container(
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: typeGroup == TypeGroup.fbs
                              ? const Color.fromRGBO(255, 102, 102, 1)
                              : AppColors.grey,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 19.w, vertical: 10.h),
                          child: Text(
                            'FBS',
                            style: GoogleFonts.manrope(
                              color: typeGroup == TypeGroup.fbs
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.5),
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        final marketplaces =
                            BlocProvider.of<SearchAddressBloc>(context)
                                .marketPlaces;
                        typeGroup = TypeGroup.mixfbs;
                        suggestionsStart = Suggestions(
                          iD: null,
                          name:
                              marketplaces?.result.points[1].name?.first.name ??
                                  'Egorka: СЦ Чертановский',
                          point: point_model.Point(
                            latitude: marketplaces?.result.points[1].latitude,
                            longitude: marketplaces?.result.points[1].longitude,
                          ),
                        );
                        suggestionsEnd = Suggestions(
                          iD: null,
                          name:
                              marketplaces?.result.points[0].name?.first.name ??
                                  'Egorka: Сборный груз FBS',
                          point: point_model.Point(
                            latitude: marketplaces?.result.points[0].latitude,
                            longitude: marketplaces?.result.points[0].longitude,
                          ),
                        );
                        coasts.clear();
                        focusFrom.unfocus();
                        focusTo.unfocus();
                        panelController.animatePanelToPosition(
                          0.3,
                          duration: const Duration(milliseconds: 400),
                        );
                        fromController.text = suggestionsStart?.name ?? '';
                        toController.text = suggestionsEnd?.name ?? '';
                        // bloc.add(DeletePolilyneEvent());
                        calc();
                        setState(() {});
                      },
                      child: Container(
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: typeGroup == TypeGroup.mixfbs
                              ? const Color.fromRGBO(255, 102, 102, 1)
                              : AppColors.grey,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          child: Text(
                            'Сборный FBS',
                            style: GoogleFonts.manrope(
                              color: typeGroup == TypeGroup.mixfbs
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.5),
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w).add(
                  EdgeInsets.only(top: 24.h),
                ),
                height: 168.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    width: 1.w,
                    color: const Color.fromRGBO(220, 220, 220, 1),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 60.w, top: 16.h),
                          child: Text(
                            'Откуда',
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(177, 177, 177, 1),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            height: 23.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.white,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  SizedBox(width: 40.w),
                                  // Checkbox(
                                  //   value: false,
                                  //   fillColor:
                                  //       MaterialStateProperty.all(Colors.red),
                                  //   shape: const CircleBorder(),
                                  //   onChanged: ((value) {}),
                                  // ),
                                  Expanded(
                                    child: CustomTextField(
                                      height: 45.h,
                                      focusNode: focusFrom,
                                      fillColor: Colors.white.withOpacity(0),
                                      hintText: 'Введите адрес',
                                      enabled: typeGroup != TypeGroup.mixfbs,
                                      onTap: () async {
                                        if (bloc.isPolilyne) {
                                          bloc.add(DeletePolilyneEvent());
                                          fromController.text = '';
                                          suggestionsStart = null;
                                          coasts.clear();
                                          setState(() {});
                                        }
                                        typeAdd = TypeAdd.sender;
                                        focusFrom.unfocus();

                                        await panelController
                                            .animatePanelToPosition(
                                          1,
                                          duration:
                                              const Duration(milliseconds: 250),
                                        );
                                        bloc.add(SearchAddressClear());
                                        Future.delayed(
                                            const Duration(milliseconds: 50),
                                            () {
                                          if (!focusFrom.hasFocus) {
                                            focusFrom.requestFocus();
                                          }
                                        });
                                      },
                                      onFieldSubmitted: (text) {
                                        panelController.animatePanelToPosition(
                                          0,
                                          duration:
                                              const Duration(milliseconds: 400),
                                        );
                                        focusFrom.unfocus();
                                      },
                                      contentPadding:
                                          EdgeInsets.only(right: 10.w),
                                      textEditingController: fromController,
                                      onChanged: (value) {
                                        bloc.add(SearchAddress(value));
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 55.w),
                                  // if (typeGroup != TypeGroup.mixfbs)
                                  //   fromController.text.isNotEmpty
                                  //       ? Padding(
                                  //           padding:
                                  //               EdgeInsets.only(right: 88.w),
                                  //           child: GestureDetector(
                                  //             onTap: () {
                                  //               bloc.add(DeletePolilyneEvent());
                                  //               fromController.text = '';
                                  //               suggestionsStart = null;
                                  //               coasts.clear();
                                  //               setState(() {});
                                  //             },
                                  //             child: Container(
                                  //               height: 20.h,
                                  //               width: 20.h,
                                  //               decoration: BoxDecoration(
                                  //                 shape: BoxShape.circle,
                                  //                 color: Colors.grey[300],
                                  //               ),
                                  //               child: const Icon(
                                  //                 Icons.clear,
                                  //                 color: Colors.white,
                                  //                 size: 15,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         )
                                  //       : Padding(
                                  //           padding:
                                  //               EdgeInsets.only(right: 5.w),
                                  //           child: Row(
                                  //             children: [
                                  //               Padding(
                                  //                 padding: EdgeInsets.symmetric(
                                  //                     vertical: 0.h),
                                  //                 child: Container(
                                  //                   color: Colors.grey[300],
                                  //                   width: 1,
                                  //                   height: 40.h,
                                  //                 ),
                                  //               ),
                                  //               TextButton(
                                  //                 onPressed: () async {
                                  //                   final res =
                                  //                       await Navigator.of(
                                  //                               context)
                                  //                           .pushNamed(AppRoute
                                  //                               .selectPoint);
                                  //                   if (res != null &&
                                  //                       res is Suggestions) {
                                  //                     suggestionsStart = res;
                                  //                     fromController.text =
                                  //                         suggestionsStart!
                                  //                             .name;

                                  //                     setState(() {});
                                  //                     calc();
                                  //                   }
                                  //                 },
                                  //                 style: ButtonStyle(
                                  //                   shape: MaterialStateProperty
                                  //                       .all<
                                  //                           RoundedRectangleBorder>(
                                  //                     RoundedRectangleBorder(
                                  //                       borderRadius:
                                  //                           BorderRadius.only(
                                  //                         bottomRight:
                                  //                             Radius.circular(
                                  //                                 10.r),
                                  //                         topRight:
                                  //                             Radius.circular(
                                  //                                 10.r),
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   backgroundColor:
                                  //                       const MaterialStatePropertyAll(
                                  //                           Colors.transparent),
                                  //                   foregroundColor:
                                  //                       const MaterialStatePropertyAll(
                                  //                           Colors.white),
                                  //                   overlayColor:
                                  //                       MaterialStatePropertyAll(
                                  //                     Colors.grey[400],
                                  //                   ),
                                  //                 ),
                                  //                 child: Center(
                                  //                   child: Text(
                                  //                     'Карта',
                                  //                     style: TextStyle(
                                  //                         color: Colors.black,
                                  //                         fontSize: 13.sp),
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          height: 1.h,
                          margin: EdgeInsets.only(left: 60.w, right: 88.w),
                          width: double.infinity,
                          color: const Color.fromRGBO(220, 220, 220, 1),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 60.w, top: 12.h),
                          child: Text(
                            'Куда',
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(177, 177, 177, 1),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Builder(
                            builder: (context) {
                              if (typeGroup == TypeGroup.express) {
                                return toFieldExpress();
                              }
                              return toFieldMarketPage();
                            },
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 48.h,
                        width: 48.w,
                        margin: EdgeInsets.only(right: 20.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Image.asset(
                          'assets/images/from_a_to_b.png',
                          width: 20.w,
                          height: 82.h,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _searchList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget toFieldMarketPage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Checkbox(
            value: false,
            fillColor: MaterialStateProperty.all(Colors.blue),
            shape: const CircleBorder(),
            onChanged: (value) {},
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (typeGroup != TypeGroup.mixfbs) {
                  final marketplaces =
                      BlocProvider.of<SearchAddressBloc>(context).marketPlaces;
                  if (marketplaces != null) {
                    toController.text =
                        marketplaces.result.points.first.name!.first.name!;
                    showMarketPlaces(marketplaces);
                  }
                }
              },
              child: CustomTextField(
                contentPadding: const EdgeInsets.all(0),
                height: 45.h,
                fillColor: Colors.white,
                enabled: false,
                hintText: 'Куда отвезти?',
                textEditingController: toController,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          if (typeGroup != TypeGroup.mixfbs)
            GestureDetector(
              onTap: () async {
                final marketplaces =
                    BlocProvider.of<SearchAddressBloc>(context).marketPlaces;
                if (marketplaces != null) {
                  final result = await Navigator.of(context).pushNamed(
                      AppRoute.marketplacesMap,
                      arguments: marketplaces);
                  if (result != null) {
                    final pointsRes = result as PointMarketPlace;
                    toController.text = pointsRes.name?.first.name ?? '';
                    suggestionsEnd = Suggestions(
                      iD: null,
                      name: pointsRes.name?.first.name ?? '',
                      point: Point(
                        latitude: pointsRes.latitude,
                        longitude: pointsRes.longitude,
                      ),
                    );
                    calc();
                  }
                }
              },
              child: const Icon(
                Icons.map_outlined,
                color: Colors.red,
              ),
            ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }

  Widget toFieldExpress() {
    var bloc = BlocProvider.of<SearchAddressBloc>(context);
    return Container(
      height: 23.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.white,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 40.w),
            // Checkbox(
            //   value: false,
            //   fillColor: MaterialStateProperty.all(Colors.blue),
            //   shape: const CircleBorder(),
            //   onChanged: (value) {},
            // ),
            Expanded(
              child: SizedBox(
                height: 23.h,
                child: CustomTextField(
                  height: 23.h,
                  onTap: () async {
                    if (bloc.isPolilyne) {
                      bloc.add(DeletePolilyneEvent());
                      // fromController.text = '';
                      // suggestionsStart = null;
                      // Future.delayed(const Duration(milliseconds: 500), () {
                      //   focusTo.requestFocus();
                      // });
                      coasts.clear();

                      // typeAdd = TypeAdd.receiver;
                      // bloc.add(SearchAddressClear());
                      Future.delayed(const Duration(milliseconds: 100),
                          () async {
                        await panelController.animatePanelToPosition(
                          1,
                          duration: const Duration(milliseconds: 250),
                        );
                        if (!focusTo.hasFocus) {
                          focusTo.requestFocus();
                        }
                      });
                      setState(() {});
                    } else {
                      await panelController.animatePanelToPosition(
                        1,
                        duration: const Duration(milliseconds: 250),
                      );
                      bloc.add(SearchAddressClear());
                      Future.delayed(const Duration(milliseconds: 50), () {
                        if (!focusTo.hasFocus) {
                          focusTo.requestFocus();
                        }
                      });
                    }
                  },
                  onFieldSubmitted: (text) {
                    panelController.animatePanelToPosition(
                      0,
                      duration: const Duration(milliseconds: 400),
                    );
                    focusTo.unfocus();
                  },
                  contentPadding: EdgeInsets.only(right: 10.w),
                  focusNode: focusTo,
                  fillColor: Colors.white.withOpacity(0),
                  hintText: 'Введите адрес',
                  textEditingController: toController,
                  onChanged: (value) {
                    bloc.add(SearchAddress(value));
                  },
                ),
              ),
            ),
            // SizedBox(width: 10.w),
            // if (typeGroup != TypeGroup.mixfbs)
            //   toController.text.isNotEmpty
            //       ? Padding(
            //           padding: EdgeInsets.only(right: 15.w),
            //           child: GestureDetector(
            //             onTap: () {
            //               bloc.add(DeletePolilyneEvent());
            //               toController.text = '';
            //               suggestionsEnd = null;
            //               coasts.clear();
            //               setState(() {});
            //             },
            //             child: Container(
            //               height: 20.h,
            //               width: 20.h,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 color: Colors.grey[500],
            //               ),
            //               child: const Icon(
            //                 Icons.clear,
            //                 color: Colors.white,
            //                 size: 15,
            //               ),
            //             ),
            //           ),
            //         )
            //       : Padding(
            //           padding: EdgeInsets.only(right: 5.w),
            //           child: Row(
            //             children: [
            //               Padding(
            //                 padding: EdgeInsets.symmetric(vertical: 0.h),
            //                 child: Container(
            //                   color: Colors.grey[300],
            //                   width: 1,
            //                   height: 23.h,
            //                 ),
            //               ),
            //               TextButton(
            //                 onPressed: () async {
            //                   focusFrom.unfocus();
            //                   final res = await Navigator.of(context)
            //                       .pushNamed(AppRoute.selectPoint);
            //                   if (res != null && res is Suggestions) {
            //                     suggestionsEnd = res;
            //                     toController.text = suggestionsEnd!.name;
            //                     setState(() {});
            //                     calc();
            //                   }
            //                 },
            //                 style: ButtonStyle(
            //                   shape: MaterialStateProperty.all<
            //                       RoundedRectangleBorder>(
            //                     RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.only(
            //                         bottomRight: Radius.circular(10.r),
            //                         topRight: Radius.circular(10.r),
            //                       ),
            //                     ),
            //                   ),
            //                   backgroundColor: const MaterialStatePropertyAll(
            //                       Colors.transparent),
            //                   foregroundColor:
            //                       const MaterialStatePropertyAll(Colors.white),
            //                   overlayColor: MaterialStatePropertyAll(
            //                     Colors.grey[400],
            //                   ),
            //                 ),
            //                 child: Center(
            //                   child: Text(
            //                     'Карта',
            //                     style: TextStyle(
            //                         color: Colors.black, fontSize: 13.sp),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
          ],
        ),
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
                      ? 128.h
                      : null,
              child: BlocBuilder<SearchAddressBloc, SearchAddressState>(
                buildWhen: (previous, current) {
                  if (current is ChangeAddressSuccess) {
                    if (fromController.text != current.address) {
                      suggestionsStart = Suggestions(
                        iD: null,
                        name: current.address,
                        point: point_model.Point(
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
                    setState(() {});
                  }
                  if (current is SearchAddressRoutePolilyne) {
                    if (current.coasts.isNotEmpty) {
                      coasts.clear();
                      coasts.addAll(current.coasts);
                      coastResponse = coasts.first;
                      streamDelivery.add(0);
                    }
                    setState(() {});
                  }
                  if (current is FindMeState) return false;
                  if (current is EditPolilynesState) return false;

                  return true;
                },
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Егорка рассчитывает стоимость'),
                        CupertinoActivityIndicator(),
                      ],
                    );
                  }
                  if (state is SearchAddressLoading) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CupertinoActivityIndicator()],
                    );
                  } else if (state is SearchAddressSuccess) {
                    return Container(
                      margin: EdgeInsets.only(top: 20.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36.r),
                            topRight: Radius.circular(36.r),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 24.r,
                              color: const Color.fromRGBO(0, 0, 0, 0.12),
                            ),
                          ]),
                      // height: 300.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: state.address!.result.suggestions!.length,
                        itemBuilder: (context, index) {
                          return _pointCard(state, index, context);
                        },
                      ),
                    );
                  } else if (state is SearchAddressRoutePolilyne ||
                      state is EditPolilynesState ||
                      state is SearchAddressStated) {
                    if (state is SearchAddressStated && coasts.isEmpty) {
                      return const SizedBox();
                    }
                    if (state is SearchAddressRoutePolilyne) {
                      directionsCar = state.directions;
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

                    listChoice = typeGroup == TypeGroup.express
                        ? [
                            DeliveryChocie(
                              title: 'Пешком',
                              icon: 'assets/images/egorka_man.png',
                              type: 'Walk',
                            ),
                            DeliveryChocie(
                              title: 'Легковая',
                              icon: 'assets/images/car.png',
                              type: 'Car',
                            )
                          ]
                        : [
                            DeliveryChocie(
                              title: 'Грузовая',
                              icon: 'assets/images/scooter.png',
                              type: 'Track',
                            )
                          ];

                    return SizedBox(
                      height: 128.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: coasts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 20.w : 0,
                              right: index == coasts.length - 1 ? 5.w : 8.w,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                coastResponse = coasts[index];
                                streamDelivery.add(index);
                                if (index != snapshot.data) {
                                  BlocProvider.of<SearchAddressBloc>(context)
                                      .add(EditPolilynesEvent(
                                    directions:
                                        index == 1 ? directionsCar : null,
                                    directionsBicycle:
                                        index == 0 ? directionsBicycle : null,
                                    markers: markers,
                                  ));
                                }
                              },
                              child: Container(
                                width: 123.w,
                                height: 128.h,
                                decoration: BoxDecoration(
                                  color: snapshot.data! == index
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: const Color.fromRGBO(221, 221, 221, 1),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Opacity(
                                      opacity:
                                          snapshot.data! == index ? 1 : 0.3,
                                      child: SizedBox(
                                        height: 70.h,
                                        child: Image.asset(
                                          listChoice[index].icon,
                                          // color: snapshot.data! == index
                                          //     ? Colors.black
                                          //     : Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 12.w, top: 4.h),
                                      child: Opacity(
                                        opacity:
                                            snapshot.data! == index ? 1 : 0.3,
                                        child: Text(
                                          listChoice[index].title,
                                          style: GoogleFonts.manrope(
                                              // color: snapshot.data! == index
                                              //     ? Colors.black
                                              //     : Colors.black,
                                              fontSize: 17.sp,
                                              fontWeight:
                                                  snapshot.data! == index
                                                      ? FontWeight.w600
                                                      : FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12.w),
                                      child: Text(
                                        '${double.tryParse(coasts[index].result!.totalPrice!.total!)!.ceil()}₽',
                                        style: GoogleFonts.manrope(
                                          color: snapshot.data! == index
                                              ? Colors.black
                                              : Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17.sp,
                                        ),
                                      ),
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
            SizedBox(height: 24.h),
            if (blocs.isPolilyne && !focusFrom.hasFocus && !focusTo.hasFocus)
              BlocBuilder<SearchAddressBloc, SearchAddressState>(
                builder: (context, state) {
                  var bloc = BlocProvider.of<SearchAddressBloc>(context);
                  if (state is SearchAddressRoutePolilyne) {
                    coasts.clear();
                    coasts.addAll(state.coasts);
                    coastResponse = coasts.first;
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomButton(
                      title: 'К оформлению',
                      onTap: coasts.isNotEmpty
                          ? () {
                              // MessageDialogs()
                              //     .showAlert('Ошибка', 'Укажите номер дома');
                              authShowDialog(snapshot.data!);
                            }
                          : () {},
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  void authShowDialog(int index) async {
    final user = BlocProvider.of<ProfileBloc>(context).getUser();
    var bloc = BlocProvider.of<SearchAddressBloc>(context);

    if (user != null) {
      final res;
      if (typeGroup != TypeGroup.express) {
        res = await Navigator.of(context).pushNamed(
          AppRoute.marketplaces,
          arguments: [
            null,
            null,
            coastResponse,
            listChoice[index],
            suggestionsStart,
            suggestionsEnd,
            typeGroup,
          ],
        );
      } else {
        res = await Navigator.of(context).pushNamed(
          AppRoute.newOrder,
          arguments: [
            coastResponse,
            listChoice[index],
            suggestionsStart,
            suggestionsEnd,
          ],
        );
      }
      if (res is bool) {
        bloc.add(DeletePolilyneEvent());
        fromController.text = '';
        toController.text = '';

        suggestionsStart = null;
        suggestionsEnd = null;

        coasts.clear();
        setState(() {});
      }
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return StandardAlertDialog(
            message: 'Хотите авторизоваться?',
            buttons: [
              StandartButton(
                  label: 'Нет',
                  color: Colors.red.withOpacity(0.9),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final res;
                    if (typeGroup != TypeGroup.express) {
                      res = await Navigator.of(context).pushNamed(
                        AppRoute.marketplaces,
                        arguments: [
                          null,
                          null,
                          coastResponse,
                          listChoice[index],
                          suggestionsStart,
                          suggestionsEnd,
                          typeGroup,
                        ],
                      );
                    } else {
                      res = await Navigator.of(context).pushNamed(
                        AppRoute.newOrder,
                        arguments: [
                          coastResponse,
                          listChoice[index],
                          suggestionsStart,
                          suggestionsEnd,
                        ],
                      );
                    }

                    if (res is bool) {
                      bloc.add(DeletePolilyneEvent());
                      fromController.text = '';
                      toController.text = '';

                      suggestionsStart = null;
                      suggestionsEnd = null;

                      coasts.clear();
                      setState(() {});
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
                    final res;
                    if (typeGroup != TypeGroup.express) {
                      res = await Navigator.of(context).pushNamed(
                        AppRoute.marketplaces,
                        arguments: [
                          null,
                          null,
                          coastResponse,
                          listChoice[index],
                          suggestionsStart,
                          suggestionsEnd,
                          typeGroup,
                        ],
                      );
                    } else {
                      res = await Navigator.of(context).pushNamed(
                        AppRoute.newOrder,
                        arguments: [
                          coastResponse,
                          listChoice[index],
                          suggestionsStart,
                          suggestionsEnd,
                        ],
                      );
                    }
                    if (res is bool) {
                      bloc.add(DeletePolilyneEvent());
                      fromController.text = '';
                      toController.text = '';

                      suggestionsStart = null;
                      suggestionsEnd = null;

                      coasts.clear();
                      setState(() {});
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
                suggestionsStart = state.address!.result.suggestions![index];
                fromController.text =
                    state.address!.result.suggestions![index].name;
              } else if (focusTo.hasFocus) {
                suggestionsEnd = state.address!.result.suggestions![index];
                toController.text =
                    state.address!.result.suggestions![index].name;
              }

              if (suggestionsStart != null && suggestionsEnd != null) {
                calc();
              } else {
                panelController.animatePanelToPosition(
                  0,
                  duration: const Duration(milliseconds: 400),
                );
                BlocProvider.of<SearchAddressBloc>(context).add(
                  JumpToPointEvent(
                    state.address!.result.suggestions![index].point!,
                  ),
                );
              }

              focusFrom.unfocus();
              focusTo.unfocus();
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

  void showMarketPlaces(MarketPlaces marketplaces) {
    showCupertinoModalPopup<String>(
      barrierColor: Colors.black.withOpacity(0.4),
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: AppConsts.textScalerStd,),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        const Spacer(),
                        CupertinoButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            calc();
                          },
                          child: const Text(
                            'Готово',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200.h,
                    child: CupertinoPicker(
                      backgroundColor: Colors.grey[200],
                      onSelectedItemChanged: (value) {
                        suggestionsEnd = Suggestions(
                          iD: marketplaces.result.points[value].iD,
                          name: marketplaces
                                  .result.points[value].name?.first.name ??
                              '',
                          point: Point(
                            latitude:
                                marketplaces.result.points[value].latitude,
                            longitude:
                                marketplaces.result.points[value].longitude,
                          ),
                        );
                        toController.text = marketplaces
                                .result.points[value].name?.first.name ??
                            '';
                      },
                      itemExtent: 32.0,
                      children: marketplaces.result.points
                          .map((e) => Text(e.name!.first.name!))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void calc() {
    coasts.clear();
    if (suggestionsStart != null && suggestionsEnd != null) {
      panelController.animatePanelToPosition(
        0.3,
        duration: const Duration(milliseconds: 400),
      );
      switch (typeGroup) {
        case TypeGroup.express:
          BlocProvider.of<SearchAddressBloc>(context).add(
            SearchAddressPolilyne(
              [suggestionsStart],
              [suggestionsEnd],
            ),
          );
          break;
        case TypeGroup.mixfbs:
          final marketplaces =
              BlocProvider.of<SearchAddressBloc>(context).marketPlaces;
          BlocProvider.of<SearchAddressBloc>(context).add(
            MarketPlaceCalcEvent(
              false,
              CoastMarketPlace(
                type: "Truck",
                group: 'MixFBS',
                locations: [
                  Location(
                    id: '',
                    point: Point(
                      id: 'EGORKA_SC',
                      code:
                          '${marketplaces?.result.points[1].latitude},${marketplaces?.result.points[1].longitude}',
                    ),
                  ),
                  Location(
                    point: Point(
                      id: 'Egorka_SBOR_FBS',
                      code:
                          '${marketplaces?.result.points[0].latitude},${marketplaces?.result.points[0].longitude}',
                    ),
                  )
                ],
              ),
              [suggestionsStart],
              [suggestionsEnd],
            ),
          );
          break;
        default:
          BlocProvider.of<SearchAddressBloc>(context).add(
            MarketPlaceCalcEvent(
              false,
              CoastMarketPlace(
                type: "Truck",
                group: typeGroup == TypeGroup.fbo ? 'Marketplace' : 'FBS',
                locations: [
                  Location(
                    point: Point(
                      code:
                          '${suggestionsStart!.point!.latitude},${suggestionsStart!.point!.longitude}',
                    ),
                  ),
                  Location(
                    point: Point(
                        code:
                            '${suggestionsEnd!.point!.latitude},${suggestionsEnd!.point!.longitude}'),
                  )
                ],
              ),
              [suggestionsStart],
              [suggestionsEnd],
            ),
          );
      }
    }
  }
}
