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
            if (controller.pomodoroState == PomodoroState.notStarted) {
              controller.initPomodoro();
            } else if (controller.pomodoroState == PomodoroState.paused) {
              controller.resumePomodoro();
            } else if (controller.pomodoroState == PomodoroState.running) {
              controller.pausePomodoro();
            }
          },
          text: controller.firstButtonText,
          height: 13,
          width: 25,
        ),
        controller.pomodoroState == PomodoroState.running ||
                controller.pomodoroState == PomodoroState.paused
            ? Container(
                margin: const EdgeInsets.only(left: 10),
                child: PrimaryButton(
                  color: primaryColor,
                  press: () async {
                    if (controller.pomodoroState == PomodoroState.paused ||
                        controller.pomodoro.shortBreak ||
                        controller.pomodoro.longBreak)  {
                      await controller.cancelPomodoro();
                    } else {
                      controller.initPomodoro();
                    }
                  },
                  text: controller.secondButtonText,
                  height: 13,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
