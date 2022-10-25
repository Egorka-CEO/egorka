import 'dart:async';

// import 'package:birthdays/services/constants.dart';
// import 'package:birthdays/services/extensions.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:popover/popover.dart';
import 'package:scale_button/scale_button.dart';

class StandartButton extends StatelessWidget {
  const StandartButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.danger = false,
    this.icon,
    this.color,
    this.width,
  }) : super(key: key);

  final String label;
  final Function() onTap;
  final bool danger;
  final IconData? icon;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      duration: const Duration(milliseconds: 150),
      bound: 0.05,
      onTap: onTap,
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: color,
          // boxShadow: shadow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            if (icon != null)
              Positioned(
                left: 15,
                top: 0,
                bottom: 0,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StandartTextButton extends StatelessWidget {
  const StandartTextButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.danger = false,
  }) : super(key: key);

  final String label;
  final Function() onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      duration: const Duration(milliseconds: 150),
      bound: 0.05,
      onTap: onTap,
      child: Center(
        child: Text(
          label,
          // style: GoogleFonts.comfortaa(
          //   fontSize: 17,
          //   fontWeight: FontWeight.bold,
          //   color: danger ? red : Theme.of(context).primaryColor,
          // ),
        ),
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    Key? key,
    this.icon,
    this.image,
    required this.list,
  }) : super(key: key);

  final IconData? icon;
  final String? image;
  final List<ContextItem> list;

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      duration: const Duration(milliseconds: 100),
      bound: 0.1,
      onTap: () => showPopover(
        context: context,
        transitionDuration: const Duration(milliseconds: 150),
        bodyBuilder: (context) => ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return list[index];
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 1,
              color: Colors.grey.withOpacity(0.1),
            );
          },
          itemCount: list.length,
        ),
        backgroundColor: Theme.of(context).cardColor,
        direction: PopoverDirection.bottom,
        width: MediaQuery.of(context).size.width * 0.75,
        height: list.length * 50,
        radius: 15,
        arrowHeight: 15,
        arrowWidth: 0,
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Stack(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 18,
                  color: Colors.white,
                ),
              if (image != null)
                Image.asset(
                  image!,
                  height: 18,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconButtonWithMenu extends StatelessWidget {
  const IconButtonWithMenu({
    Key? key,
    required this.icon,
    required this.list,
  }) : super(key: key);

  final IconData icon;
  final List<ContextItem> list;

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      duration: const Duration(milliseconds: 100),
      bound: 0.1,
      onTap: () => showPopover(
        context: context,
        transitionDuration: const Duration(milliseconds: 150),
        bodyBuilder: (context) => ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return list[index];
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 1,
              color: Colors.grey.withOpacity(0.1),
            );
          },
          itemCount: list.length,
        ),
        backgroundColor: Theme.of(context).cardColor,
        direction: PopoverDirection.bottom,
        width: MediaQuery.of(context).size.width * 0.75,
        height: list.length * 50,
        radius: 15,
        arrowHeight: 0,
        arrowWidth: 0,
      ),
      child: Icon(
        icon,
        // color: green,
        size: 22,
      ),
    );
  }
}

class ContextItem extends StatelessWidget {
  const ContextItem({
    Key? key,
    required this.label,
    required this.onTap,
    this.danger = false,
  }) : super(key: key);

  final String label;
  final Function() onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Timer(
          const Duration(milliseconds: 150),
          () => onTap(),
        );
      },
      child: Container(
        height: 50,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Text(
          label,
          style: TextStyle(
            // color: danger ? red : Theme.of(context).textTheme.bodyText1!.color,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({
    Key? key,
    required this.label,
    required this.count,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final int count;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // borderRadius: radius,
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          // borderRadius: radius,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                // style: GoogleFonts.comfortaa(
                //   fontSize: 14,
                //   fontWeight: FontWeight.bold,
                // ),
              ),
            ),
            if (count > 0)
              Container(
                width: 25,
                height: 25,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.only(top: 2),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}

class ListButton extends StatelessWidget {
  const ListButton({
    Key? key,
    required this.label,
    required this.list,
    // required this.onTap,
  }) : super(key: key);

  final String label;
  final List<String> list;
  // final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // borderRadius: radius,
      // onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          // borderRadius: radius,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // color: green,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  for (var item in list)
                    if (item != "")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              "•",
                              // style: GoogleFonts.comfortaa(
                              //   fontSize: 20,
                              // ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // Text(
                            // item.removeDecoration().capitalLetter(),
                            // style: GoogleFonts.comfortaa(
                            //   fontSize: 15,
                            // ),
                            // ),
                          ],
                        ),
                      ),
                  if (list.length == 1 && list[0] == "")
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Список пока пуст",
                        // style: GoogleFonts.comfortaa(
                        //   fontSize: 15,
                        // ),
                      ),
                    ),
                ],
              ),
            ),
            // Icon(
            //   Icons.arrow_forward_ios,
            //   size: 18,
            //   color: Colors.grey.withOpacity(0.8),
            // ),
          ],
        ),
      ),
    );
  }
}

class AccentTextButton extends StatelessWidget {
  const AccentTextButton({
    Key? key,
    required this.text,
    required this.description,
  }) : super(key: key);

  final String text;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      duration: const Duration(milliseconds: 100),
      bound: 0.1,
      onTap: () => showPopover(
        context: context,
        transitionDuration: const Duration(milliseconds: 150),
        bodyBuilder: (context) => Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.centerLeft,
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        direction: PopoverDirection.bottom,
        width: MediaQuery.of(context).size.width * 0.75,
        height: 80,
        radius: 15,
        arrowHeight: 15,
        arrowWidth: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          // color: green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
