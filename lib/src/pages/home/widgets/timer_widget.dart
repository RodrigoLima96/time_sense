import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/utils/constants.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pomodoroController = context.watch<PomodoroController>();
    final taskController = context.read<TasksController>();

    int pomodoroDuration = pomodoroController.pomodoro.remainingPomodoroTime!;

    final pomodoroDurationInMinutes = pomodoroController
        .convertSecondsToMinutes(pomodoroDuration: pomodoroDuration);

    return CircularCountDownTimer(
      duration: pomodoroDuration,
      initialDuration: 0,
      controller: pomodoroController.countDownController,
      width: size.width * 0.8,
      height: size.height * 0.35,
      ringColor: secondaryColor,
      fillColor: primaryColor,
      backgroundColor: backgroundColor,
      strokeWidth: 10,
      strokeCap: StrokeCap.round,
      textStyle: textBold.copyWith(
        fontSize: 45.0,
      ),
      textFormat: CountdownTextFormat.MM_SS,
      isReverse: true,
      autoStart: false,
      onComplete: () async {
        if (!pomodoroController.pomodoro.shortBreak &&
            !pomodoroController.pomodoro.longBreak) {
          int currentPomodoroTaskTime =
              pomodoroController.getCurrentPomodoroTaskTime(pomodoroComplete: true);
          await taskController.savePomodoroTaskTime(
            taskId: pomodoroController.pomodoro.task!.id,
            taskTime: currentPomodoroTaskTime,
            isCompleted: false,
          );
        }

        await pomodoroController.completePomodoro();
      },
      timeFormatterFunction: (defaultFormatterFunction, duration) {
        if (pomodoroController.pomodoroState == PomodoroState.notStarted) {
          return pomodoroDurationInMinutes;
        } else {
          return Function.apply(defaultFormatterFunction, [duration]);
        }
      },
    );
  }
}
