import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomWidget {
  static Widget appBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(Icons.menu, size: 35, color: Colors.white),
                );
              },
            ),
            const SizedBox(width: 10),
            SvgPicture.asset(
              'assets/icons/logo_egorka.svg',
              width: 100,
              height: 30,
            ),
            const Spacer(),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(255, 0, 96, 1),
                    Color.fromRGBO(216, 0, 255, 1)
                  ])),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text(
                  'Маркетплейсы',
                  style: CustomTextStyle.white15w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget iconGPS() => const Center(
        child: Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 35,
        ),
      );
}
