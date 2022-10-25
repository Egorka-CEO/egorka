import 'package:egorka/widget/buttons.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class StandartAlertDialog extends StatelessWidget {
  const StandartAlertDialog({
    Key? key,
    required this.message,
    required this.buttons,
  }) : super(key: key);

  final String message;
  final List<StandartButton> buttons;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 125,
                    alignment: Alignment.center,
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                  ),
                  if (buttons.length != 2)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buttons[index];
                      },
                      separatorBuilder: (context, index) {
                        if ((index + 1) == buttons.length) {
                          return const SizedBox.shrink();
                        }
                        return const SizedBox(
                          height: 15,
                        );
                      },
                      itemCount: buttons.length,
                    ),
                  if (buttons.length == 2)
                    Row(
                      children: [
                        Expanded(child: buttons[0]),
                        const SizedBox(width: 15),
                        Expanded(child: buttons[1]),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
