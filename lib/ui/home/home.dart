import 'dart:async';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:egorka/core/bloc/book/book_bloc.dart';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/app_consts.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/model/user.dart';
import 'package:egorka/widget/disconnect_page.dart';
import 'package:egorka/widget/bottom_sheet_history_orders.dart';
import 'package:egorka/widget/map.dart';
import 'package:egorka/ui/sidebar/side_menu.dart';
import 'package:egorka/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PanelController panelController = PanelController();
  final streamController = StreamController<int>();
  bool visible = true;
  int duration = 350;
  double hight = 0;
  bool initHeight = true;
  bool logoVisibleMove = false;
  bool logoMoveBackgroundScale = false;
  double panelSize = 0;

  late StreamSubscription<DataConnectionStatus> listener;

  checkConnection(BuildContext context) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          break;
        case DataConnectionStatus.disconnected:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) {
                return Disconnected();
              }),
              fullscreenDialog: true,
            ),
          );
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  @override
  void initState() {
    super.initState();
    funcInit();
    checkConnection(context);
    BlocProvider.of<SearchAddressBloc>(context).add(GetMarketPlaces());
  }

  void funcInit() async {
    final storage = MySecureStorage();
    final type = await storage.getTypeUser();
    final id = await storage.getID();

    if (type != null) {
      String? login = await storage.getLogin();
      String? password = await storage.getPassword();
      String? company = await storage.getCompany();
      AuthUser? res;

      if (type == '0') {
        res = await Repository().loginUsernameUser(login!, password!);
      } else if (type == '1') {
        res =
            await Repository().loginUsernameAgent(login!, password!, company!);
      }

      if (res != null) {
        storage.setKey(res.result!.key);
        BlocProvider.of<ProfileBloc>(context).add(ProfileEventUpdate(res));
        BlocProvider.of<ProfileBloc>(context).add(GetDepositEvent());
        BlocProvider.of<BookBloc>(context).add(LoadBooksEvent());
      }
    } else if (id != null) {
    } else {
      await Repository().uuidCreate();
    }
    BlocProvider.of<HistoryOrdersBloc>(context).add(GetListOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    if (initHeight) {
      initHeight = false;
      hight = MediaQuery.of(context).size.height;
    }
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: AppConsts.textScalerStd,
      ),
      child: BlocBuilder<SearchAddressBloc, SearchAddressState>(
        builder: (context, snapshot) {
          var bloc = BlocProvider.of<SearchAddressBloc>(context);

          return Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
                drawer: NavBar(),
                backgroundColor: Colors.transparent,
                drawerScrimColor: Colors.transparent,
                body: Stack(
                  children: [
                    Container(color: Colors.white),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: (snapshot is SearchAddressRoutePolilyne) ||
                                (snapshot is EditPolilynesState)
                            ? 100.h
                            : 0,
                      ),
                      child: MapView(
                        callBack: () {
                          Future.delayed(const Duration(milliseconds: 1200),
                              () {
                            setState(() {
                              visible = false;
                            });
                            streamController.add(2);
                          });
                          logoMoveBackgroundScale = true;
                          streamController.add(2);
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      height: 42.h,
                      margin:
                          EdgeInsets.only(top: 75.h, left: 20.w, right: 20.w),
                      child: Row(
                        children: [
                          // Padding(
                          //   padding: EdgeInsets.only(top: 5.w),
                          //   child: SizedBox(
                          //     height: 35.h,
                          //     child: Builder(
                          //       builder: (context) {
                          //         return GestureDetector(
                          //           onTap: () =>
                          //               Scaffold.of(context).openDrawer(),
                          //           child: Image.asset(
                          //             'assets/images/logo.png',
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),
                          Builder(builder: (context) {
                            return GestureDetector(
                              onTap: () => Scaffold.of(context).openDrawer(),
                              child: Container(
                                height: 42.h,
                                width: 42.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 4),
                                      blurRadius: 16.r,
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 0.12),
                                    )
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/icons/more.svg',
                                  width: 21.w,
                                  height: 21.h,
                                ),
                              ),
                            );
                          }),
                          // const SizedBox(width: 10),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 10),
                          //   child: AnimatedOpacity(
                          //     duration: const Duration(seconds: 0),
                          //     opacity: logoVisibleMove ? 1 : 0,
                          //     child: SizedBox(
                          //       height: 50.h,
                          //       child: SvgPicture.asset(
                          //         'assets/icons/logo_egorka.svg',
                          //         width: 100.w,
                          //         height: 30.w,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => markerPlace(context),
                            child: Container(
                              width: 163.w,
                              height: 42.h,
                              // margin: EdgeInsets.only(top: 10.h),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.r)),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(255, 102, 102, 1),
                                    Color.fromRGBO(255, 102, 102, 1)
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                child: Text(
                                  'Маркетплейсы',
                                  style: GoogleFonts.manrope(
                                    fontSize: 17.h,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (!bloc.isPolilyne)
                      Padding(
                        padding: EdgeInsets.only(bottom: 200.h),
                        child: Center(
                          child: SizedBox(
                            width: 32.w,
                            height: 57.h,
                            child: IgnorePointer(
                              child: SvgPicture.asset('assets/icons/pin.svg'),
                            ),
                          ),
                        ),
                      ),
                    const BottomSheetDraggable(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: BlocBuilder<HistoryOrdersBloc, HistoryOrdersState>(
                  buildWhen: (previous, current) {
                    if (current is HistoryOpenBtmSheetState) {
                      panelController.animatePanelToPosition(
                        1,
                        curve: Curves.easeInOutQuint,
                        duration: const Duration(milliseconds: 1000),
                      );
                    }
                    if (current is HistoryCloseBtmSheetState) {
                      panelController.animatePanelToPosition(
                        0,
                        curve: Curves.easeInOutQuint,
                        duration: const Duration(milliseconds: 1000),
                      );
                    }
                    return false;
                  },
                  builder: (context, snapshot) {
                    return SlidingUpPanel(
                      controller: panelController,
                      renderPanelSheet: false,
                      isDraggable: true,
                      collapsed: Container(),
                      panel: HistoryOrdersBottomSheetDraggable(
                        panelController: panelController,
                        panelSize: panelSize,
                      ),
                      onPanelClosed: () {},
                      onPanelOpened: () {},
                      onPanelSlide: (size) {
                        panelSize = size;
                        setState(() {});
                      },
                      maxHeight: 700.h,
                      minHeight: 0,
                      defaultPanelState: PanelState.CLOSED,
                    );
                  },
                ),
              ),
              // StreamBuilder<int>(
              //     stream: streamController.stream,
              //     initialData: 1,
              //     builder: (context, snapshot) {
              // if (visible)
              IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: visible ? 1 : 0,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: SizedBox(
                        child: Image.asset(
                          'assets/images/egorka_man.png',
                          // width: 100.w,
                          height: 150.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //   }
              //   return const SizedBox();
              // }),
              // Positioned.fill(
              //   child: Stack(
              //     children: [
              //       // AnimatedPadding(
              //       //   onEnd: () {
              //       //     logoVisibleMove = true;
              //       //     setState(() {});
              //       //   },
              //       //   curve: Curves.linear,
              //       //   duration: Duration(milliseconds: duration),
              //       // padding: EdgeInsets.only(
              //       //   top: logoMoveBackgroundScale ? 65.w : 0,
              //       //   left: logoMoveBackgroundScale ? 65.w : 0,
              //       // ),
              //       // child: AnimatedAlign(
              //       //   curve: Curves.linear,
              //       //   alignment: logoMoveBackgroundScale
              //       //       ? Alignment.topLeft
              //       //       : Alignment.center,
              //       //   duration: Duration(milliseconds: duration),
              //       //   child:
              //       AnimatedOpacity(
              //         duration: const Duration(seconds: 0),
              //         opacity: logoVisibleMove ? 0 : 1,
              //         //     child: AnimatedScale(
              //         //       scale: logoMoveBackgroundScale ? 1 : 3.6,
              //         //       duration: Duration(milliseconds: duration),
              //         //       child: Padding(
              //         //         padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
              //         child: SizedBox(
              //           height: 50.h,
              //           child: Image.asset(
              //             'assets/images/egorka_man.png',
              //             width: 100.w,
              //             height: 30.w,
              //           ),
              //         ),
              //       ),
              //       //       ),
              //       //     ),
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }

  void markerPlace(BuildContext context) =>
      Navigator.of(context).pushNamed(AppRoute.marketplaces);
}
