import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:time_sense/src/controllers/controllers.dart';

import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PomodoroController>();
    Map<String, Map<String, dynamic>> buttonsInfos =
        controller.getButtonsInfo();

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Animate(
        child: Container(
          margin: controller.showSecondButton
              ? const EdgeInsets.only(right: 40)
              : const EdgeInsets.only(right: 0),
          child: PrimaryButton(
            color: primaryColor,
            press: () {
              buttonsInfos['first_button']!['function']();
            },
            text: buttonsInfos['first_button']!['text'],
            height: 13,
            width: 25,
          ),
        ),
      ),
      controller.showSecondButton
          ? Animate(
            effects: [SlideEffect(duration: 500.milliseconds)],
            child: Container(
              margin: const EdgeInsets.only(left: 40),
              child: PrimaryButton(
                color: primaryColor,
                press: () async {
                  buttonsInfos['second_button']!['function']();
                },
                text: buttonsInfos['second_button']!['text'],
                height: 13,
              ),
            ),
          )
          : const SizedBox(),
    ]);
  }
}
