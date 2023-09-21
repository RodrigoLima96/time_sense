import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:time_sense/src/controllers/controllers.dart';
import 'package:time_sense/src/shared/utils/constants.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = context.watch<PomodoroController>();

    final int pomodoroDuration = controller.pomodoro.remainingPomodoroTime!;
    final pomodoroDurationInMinutes =
        controller.convertSecondsToMinutes(pomodoroDuration: pomodoroDuration);

    return CircularCountDownTimer(
      duration: pomodoroDuration,
      initialDuration: 0,
      controller: controller.countDownController,
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
        await controller.completePomodoro();
      },
      timeFormatterFunction: (defaultFormatterFunction, duration) {
        if (controller.pomodoroState == PomodoroState.notStarted) {
          return pomodoroDurationInMinutes;
        } else {
          return Function.apply(defaultFormatterFunction, [duration]);
        }
      },
    );
  }
}
