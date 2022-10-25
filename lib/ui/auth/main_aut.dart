import 'package:egorka/ui/auth/auth_page.dart';
import 'package:egorka/ui/auth/choice_person.dart';
import 'package:flutter/material.dart';

class MainAuthPage extends StatelessWidget {
  MainAuthPage({super.key});

  PageController pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        AuthPage(),
        ChoicePersonPage(next: next, prev: prev),
        AuthPage(),
      ],
    );
  }

  void next() => pageController.jumpToPage(0);

  void prev() => pageController.jumpToPage(2);
}
