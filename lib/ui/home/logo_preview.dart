import 'package:egorka/ui/home/home.dart';
import 'package:flutter/material.dart';

class LogoPreview extends StatelessWidget {
  Widget build(BuildContext context) {
    goHomePage(context);
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/images/logo.png',
              height: 70,
            ),
          ),
        ],
      ),
    );
  }

  void goHomePage(BuildContext context) async {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(context, CustomPageRoute(HomePage()),
          ((route) {
        return false;
      }));
    });
  }
}

class CustomPageRoute<T> extends PageRoute<T> {
  final Widget child;

  CustomPageRoute(this.child);

  @override
  Color get barrierColor => Colors.white;

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(seconds: 3);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
