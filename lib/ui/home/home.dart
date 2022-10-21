import 'package:egorka/core/bloc/search/search_bloc.dart';
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
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const MapView(),
            ),
            CustomWidget.appBar(),
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
}
