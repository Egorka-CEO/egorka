import 'dart:async';
import 'package:egorka/core/bloc/deposit/deposit_bloc.dart';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/core/database/secure_storage.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/user.dart';
import 'package:egorka/widget/bottom_sheet_history_orders.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:egorka/widget/map.dart';
import 'package:egorka/ui/sidebar/side_menu.dart';
import 'package:egorka/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PanelController panelController = PanelController();

  @override
  void initState() {
    super.initState();
    funcInit();
    startAnim();
    BlocProvider.of<DepositBloc>(context).add(LoadAllDepositEvent());
    BlocProvider.of<HistoryOrdersBloc>(context).add(GetListOrdersEvent());
    BlocProvider.of<ProfileBloc>(context).add(GetDepositeEvent());
  }

  void startAnim() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      logoMoveBackgroundScale = true;
      setState(() {});
    });
  }

  void funcInit() async {
    final storage = MySecureStorage();
    final type = await storage.getTypeUser();

    print('object ${type}');
    if (type != null) {
      String? login = await storage.getLogin();
      String? password = await storage.getPassword();
      String? company = await storage.getCompany();
      AuthUser? res;

      if (type == '0') {
        // switch (type) {
        // case '0':
        res = await Repository().loginUsernameUser(login!, password!);
        // break;
        // case '1':
        // res = await Repository().loginEmailUser(login!, password!);
        // break;
        // case '2':
        //   res = await Repository().loginPhoneUser(login!, password!);
        //   break;
        // default:
        //   res = null;
        // }
      } else {
        // switch (type) {
        //   case '0':
        res =
            await Repository().loginUsernameAgent(login!, password!, company!);
        //     break;
        //   case '1':
        //     res =
        //         await Repository().loginEmailAgent(login!, password!, company!);
        //     break;
        //   case '2':
        //     res =
        //         await Repository().loginPhoneAgent(login!, password!, company!);
        //     break;
        //   default:
        //     res = null;
        // }
      }

      if (res != null) {
        BlocProvider.of<ProfileBloc>(context).add(ProfileEventUpdate(res));
      }
    } else {
      Repository().UUIDCreate();
    }
  }

  int duration = 350;
  double hight = 0;

  bool initHeight = true;
  bool logoVisibleMove = false;
  bool logoMoveBackgroundScale = false;

  @override
  Widget build(BuildContext context) {
    if (initHeight) {
      initHeight = false;
      hight = MediaQuery.of(context).size.height;
    }
    return BlocBuilder<SearchAddressBloc, SearchAddressState>(
      builder: (context, snapshot) {
        var bloc = BlocProvider.of<SearchAddressBloc>(context);
        return Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              drawer: NavBar(),
              drawerScrimColor: Colors.transparent,
              body: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOutQuint,
                    margin: EdgeInsets.only(
                      bottom:
                          snapshot is SearchAddressRoutePolilyne ? 100.h : 0,
                    ),
                    child: const MapView(),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 60.w, left: 20.w, right: 20.w),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.w),
                          child: SizedBox(
                            height: 35.h,
                            child: Builder(
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () =>
                                      Scaffold.of(context).openDrawer(),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: AnimatedOpacity(
                            duration: const Duration(seconds: 0),
                            opacity: logoVisibleMove ? 1 : 0,
                            child: SizedBox(
                              height: 50.h,
                              child: SvgPicture.asset(
                                'assets/icons/logo_egorka.svg',
                                width: 100.w,
                                height: 30.w,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => markerPlace(context),
                          child: Container(
                            margin: EdgeInsets.only(top: 10.h),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(255, 0, 96, 1),
                                  Color.fromRGBO(216, 0, 255, 1)
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 5.h),
                              child: const Text(
                                'Маркетплейсы',
                                style: CustomTextStyle.white15w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (!bloc.isPolilyne)
                    Padding(
                      padding: EdgeInsets.only(bottom: (35 / 2).h),
                      child: CustomWidget.iconGPS(),
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
                        panelController: panelController),
                    onPanelClosed: () {},
                    onPanelOpened: () {},
                    onPanelSlide: (size) {},
                    maxHeight: 700.h,
                    minHeight: 0,
                    defaultPanelState: PanelState.CLOSED,
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Stack(
                children: [
                  AnimatedPadding(
                    onEnd: () {
                      logoVisibleMove = true;
                      setState(() {});
                    },
                    curve: Curves.linear,
                    duration: Duration(milliseconds: duration),
                    padding: EdgeInsets.only(
                      top: logoMoveBackgroundScale ? 65.w : 0,
                      left: logoMoveBackgroundScale ? 65.w : 0,
                    ),
                    child: AnimatedAlign(
                      curve: Curves.linear,
                      alignment: logoMoveBackgroundScale
                          ? Alignment.topLeft
                          : Alignment.center,
                      duration: Duration(milliseconds: duration),
                      child: AnimatedOpacity(
                        duration: const Duration(seconds: 0),
                        opacity: logoVisibleMove ? 0 : 1,
                        child: AnimatedScale(
                          scale: logoMoveBackgroundScale ? 1 : 3.6,
                          duration: Duration(milliseconds: duration),
                          child: Padding(
                            padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
                            child: SizedBox(
                              height: 50.h,
                              child: SvgPicture.asset(
                                'assets/icons/logo_egorka.svg',
                                width: 100.w,
                                height: 30.w,
                              ),
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
        );
      },
    );
  }

  void markerPlace(BuildContext context) =>
      Navigator.of(context).pushNamed(AppRoute.marketplaces);
}
