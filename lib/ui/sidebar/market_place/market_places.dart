import 'package:egorka/core/bloc/market_place/market_place_bloc.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/marketplaces.dart';
import 'package:egorka/model/point.dart';
import 'package:egorka/widget/bottom_sheet_map_marketplaces.dart';
import 'package:egorka/widget/map_marketplaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MarketPlacesMap extends StatelessWidget {
  MarketPlaces marketPlaces;
  MarketPlacesMap(this.marketPlaces, {super.key});
  PanelController panelController = PanelController();

  Point? points;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocProvider(
        create: (context) => MarketPlacePageBloc(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.5),
            elevation: 0.5,
            leading: const SizedBox(),
            flexibleSpace: Column(
              children: [
                const Spacer(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      size: 25.h,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      'Назад',
                                      style: CustomTextStyle.red15
                                          .copyWith(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              const Align(
                                child: Text(
                                  'Маркетплейсы',
                                  style: CustomTextStyle.black15w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              MapMarketPlaces(points: marketPlaces.result.points),
              BlocBuilder<MarketPlacePageBloc, MarketPlaceState>(
                buildWhen: (previous, current) {
                  if (current is MarketPlacesSelectPointState) {
                    panelController.animatePanelToPosition(1,
                        curve: Curves.easeInOutQuint,
                        duration: const Duration(milliseconds: 1000));
                  }
    
                  return true;
                },
                builder: (context, snapshot) {
                  return SlidingUpPanel(
                    controller: panelController,
                    renderPanelSheet: false,
                    isDraggable: true,
                    collapsed: Container(),
                    panel: BottomMarketPlacesMap(
                      fromController: TextEditingController(),
                      panelController: panelController,
                    ),
                    onPanelClosed: () {
                      // if (typeAdd == TypeAdd.sender) {
                      //   fromController.text = controller.text;
                      // } else if (typeAdd == TypeAdd.receiver) {
                      //   toController.text = controller.text;
                      // }
                      // controller.text = '';
                      // focusFrom.unfocus();
                      // focusTo.unfocus();
                      // _visible = false;
                    },
                    onPanelOpened: () {
                      // _visible = true;
                      // if (!focusFrom.hasFocus && !focusTo.hasFocus) {
                      //   panelController.close();
                      // }
                    },
                    onPanelSlide: (size) {
                      // if (size.toStringAsFixed(1) == (0.5).toString()) {
                      //   focusFrom.unfocus();
                      //   focusTo.unfocus();
                      // }
                    },
                    maxHeight: 200.h,
                    minHeight: 100.h,
                    defaultPanelState: PanelState.CLOSED,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
