import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:time_sense/src/controllers/controllers.dart';

import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PomodoroController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PrimaryButton(
          color: primaryColor,
          press: () {
            if (controller.state == PomodoroState.notStarted ||
                controller.state == PomodoroState.breakTime) {
              if (controller.state == PomodoroState.breakTime) {
                controller.initPomodoro(breakTime: true);
              } else {
                controller.initPomodoro(breakTime: false);
              }
            } else if (controller.state == PomodoroState.paused) {
              controller.resumePomodoro();
            } else if (controller.state == PomodoroState.running) {
              controller.pausePomodoro();
            }
          },
          text: controller.buttonText,
          height: 13,
          width: 25,
        ),
        controller.state == PomodoroState.running ||
                controller.state == PomodoroState.paused
            ? Container(
                margin: const EdgeInsets.only(left: 10),
                child: PrimaryButton(
                  color: primaryColor,
                  press: () {
                    if (controller.state == PomodoroState.paused) {
                      controller.cancelPomodoro();
                    } else {
                      controller.initPomodoro(breakTime: false);
                    }
                  },
                  text: controller.state == PomodoroState.paused
                      ? controller.state == PomodoroState.breakTime
                          ? 'Pular'
                          : 'Cancelar'
                      : controller.state == PomodoroState.breakTime
                          ? 'Pular'
                          : 'Reiniciar',
                  height: 13,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
