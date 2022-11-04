import 'dart:async';
import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/widget/bottom_sheet_history_orders.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:egorka/widget/map.dart';
import 'package:egorka/ui/sidebar/side_menu.dart';
import 'package:egorka/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    startAnim();
  }

  void startAnim() async {
    Future.delayed(const Duration(seconds: 4), () {
      background = true;
      logoMove = true;
      logoScale = true;
      setState(() {});
    });
  }

  int duration = 1;
  double hight = 0;

  bool initHeight = true;
  bool logoMove = false;
  bool background = false;
  bool logoVisibleMove = false;
  bool logoScale = false;

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
              drawerEnableOpenDragGesture: false,
              drawer: const NavBar(),
              body: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOutQuint,
                    margin: EdgeInsets.only(
                      bottom: snapshot is SearchAddressRoutePolilyne ? 100 : 0,
                    ),
                    child: const MapView(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 60, left: 20, right: 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SizedBox(
                            height: 35,
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
                              height: 50,
                              child: SvgPicture.asset(
                                'assets/icons/logo_egorka.svg',
                                width: 100,
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => markerPlace(context),
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(255, 0, 96, 1),
                                  Color.fromRGBO(216, 0, 255, 1)
                                ])),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: Text(
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
                      padding: const EdgeInsets.only(bottom: 35 / 2),
                      child: CustomWidget.iconGPS(),
                    ),
                  const BottomSheetDraggable(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: BlocBuilder<HistoryOrdersBloc, HistoryOrdersState>(
                buildWhen: (previous, current) {
                  if (current is HistoryOpenBtmSheetState) {
                    panelController.animatePanelToPosition(1,
                        curve: Curves.easeInOutQuint,
                        duration: const Duration(milliseconds: 1000));
                  }
                  if (current is HistoryCloseBtmSheetState) {
                    panelController.animatePanelToPosition(0,
                        curve: Curves.easeInOutQuint,
                        duration: const Duration(milliseconds: 1000));
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
                    maxHeight: 700,
                    minHeight: 0,
                    defaultPanelState: PanelState.CLOSED,
                  );
                },
              ),
            ),
            Stack(
              children: [
                AnimatedOpacity(
                  onEnd: () {
                    hight = 0;
                    setState(() {});
                  },
                  duration: Duration(seconds: duration),
                  opacity: background ? 0 : 1,
                  child: Container(
                    height: hight,
                    color: Colors.white,
                  ),
                ),
              ],
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
                    duration: Duration(seconds: duration),
                    padding: EdgeInsets.only(
                      top: logoMove ? 65 : 0,
                      left: logoMove ? 65 : 0,
                    ),
                    child: AnimatedAlign(
                      curve: Curves.linear,
                      alignment:
                          logoMove ? Alignment.topLeft : Alignment.center,
                      duration: Duration(seconds: duration),
                      child: AnimatedOpacity(
                        duration: const Duration(seconds: 0),
                        opacity: logoVisibleMove ? 0 : 1,
                        child: AnimatedScale(
                          scale: logoScale ? 1 : 2,
                          duration: Duration(seconds: duration),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: SizedBox(
                              height: 50,
                              child: SvgPicture.asset(
                                'assets/icons/logo_egorka.svg',
                                width: 100,
                                height: 30,
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
