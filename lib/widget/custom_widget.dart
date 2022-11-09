import 'package:egorka/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomWidget {
  static Widget appBar(VoidCallback marletPlace) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      child: SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 28,
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 1.5),
                  child: Hero(
                    tag: 'logo',
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
                onTap: marletPlace,
                child: Container(
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
                ),
              )
            ],
          ),
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

  static Widget iconGPSSmall({Color? color}) => Center(
        child: Icon(
          Icons.location_pin,
          color: color ?? Colors.red,
          size: 25,
        ),
      );
}
