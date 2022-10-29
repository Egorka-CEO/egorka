import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/widget/bottom_sheet_history_orders.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:egorka/widget/map.dart';
import 'package:egorka/ui/sidebar/side_menu.dart';
import 'package:egorka/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
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
                  CustomWidget.appBar((() => markerPlace(context))),
                  if (!bloc.isPolilyne)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35 / 2),
                      child: CustomWidget.iconGPS(),
                    ),
                  const BottomSheetDraggable(),
                ],
              ),
            ),
            BlocBuilder<HistoryOrdersBloc, HistoryOrdersState>(
              buildWhen: (previous, current) {
                if (current is HistoryOpenBtmSheetState) {
                  panelController.animatePanelToPosition(1,
                      curve: Curves.easeInOutQuint,
                      duration: Duration(milliseconds: 1000));
                }
                if (current is HistoryCloseBtmSheetState) {
                  panelController.animatePanelToPosition(0,
                      curve: Curves.easeInOutQuint,
                      duration: Duration(milliseconds: 1000));
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
          ],
        );
      },
    );
  }

  void markerPlace(BuildContext context) =>
      Navigator.of(context).pushNamed(AppRoute.marketplaces);
}
