import 'package:egorka/core/bloc/market_place/market_place_bloc.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/marketplaces.dart' as mrkt;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomMarketPlacesMap extends StatefulWidget {
  TextEditingController fromController;
  PanelController panelController;
  BottomMarketPlacesMap({
    Key? key,
    required this.fromController,
    required this.panelController,
  });

  @override
  State<BottomMarketPlacesMap> createState() => _BottomMarketPlacesMaptate();
}

class _BottomMarketPlacesMaptate extends State<BottomMarketPlacesMap> {
  FocusNode focusFrom = FocusNode();

  mrkt.Points? points;

  @override
  Widget build(BuildContext context) {
    return _floatingPanel(context);
  }

  Widget _floatingPanel(BuildContext context) {
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
        color: Colors.white,
      ),
      child: BlocBuilder<MarketPlacePageBloc, MarketPlaceState>(
        buildWhen: (previous, current) {
          if (current is MarketPlacesSelectPointState) {
            points = current.points;
          }
          return true;
        },
        builder: ((context, state) {
          return Column(
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
              points == null
                  ? const Text(
                      'Выберите адрес',
                      style: CustomTextStyle.black15w700,
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.w,
                      ),
                      child: Column(
                        children: [
                          Text(points!.name[0].name,
                              style: CustomTextStyle.black15w700),
                          Text(
                            points!.address[0].address,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.h),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(points),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Center(
                                child: Text(
                                  'Выбрать',
                                  style: CustomTextStyle.white15w600
                                      .copyWith(letterSpacing: 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          );
        }),
      ),
    );
  }
}
