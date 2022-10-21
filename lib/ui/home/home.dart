import 'package:egorka/widget/custom_widget.dart';
import 'package:egorka/widget/map.dart';
import 'package:egorka/ui/sidebar/side_menu.dart';
import 'package:egorka/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: CustomWidget.iconGPS(),
          ),
          const BottomSheetDraggable(),
        ],
      ),
    );
  }
}
