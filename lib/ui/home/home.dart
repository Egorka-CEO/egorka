import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/router.dart';
import 'package:egorka/widget/custom_widget.dart';
import 'package:egorka/widget/map.dart';
import 'package:egorka/ui/sidebar/side_menu.dart';
import 'package:egorka/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchAddressBloc, SearchAddressState>(
        builder: (context, snapshot) {
      var bloc = BlocProvider.of<SearchAddressBloc>(context);
      return Scaffold(
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
      );
    });
  }

  void markerPlace(BuildContext context) =>
      Navigator.of(context).pushNamed(AppRoute.marketplaces);
}
