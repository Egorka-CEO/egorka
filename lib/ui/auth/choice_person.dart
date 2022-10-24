import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChoicePersonPage extends StatelessWidget {
  ChoicePersonPage({super.key, required this.next, required this.prev});

  VoidCallback next;
  VoidCallback prev;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/logo_egorka.svg',
                height: 60,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => next(),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                child: const Text(
                  'Я пользователь',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => prev(),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                child: const Text(
                  'Я это Я',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
