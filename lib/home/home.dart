import 'package:egorka/home/map.dart';
import 'package:egorka/home/side_menu.dart';
import 'package:egorka/widget/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const NavBar(),
      body: Stack(
        children: [
          const MapView(),
          appBar(),
          iconGPS(),
          const BottomSheetDraggable()
        ],
      ),
    );
  }

  Widget appBar() {
    TextStyle style = const TextStyle(
        fontSize: 35, fontWeight: FontWeight.w900, color: Colors.black);

    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Builder(builder: (context) {
              return GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(Icons.menu, size: 35, color: Colors.white));
            }),
            const SizedBox(width: 10),
            SvgPicture.asset(
              'assets/images/logo3.svg',
              width: 100,
              height: 30,
            ),
            const Spacer(),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text(
                  'Маркетплейсы',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iconGPS() => const Center(
          child: Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 35,
      ));
}
