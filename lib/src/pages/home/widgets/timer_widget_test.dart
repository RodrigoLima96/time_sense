import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:time_sense/src/controllers/controllers.dart';
import 'package:time_sense/src/shared/utils/constants.dart';

class TimerWidgetTest extends StatefulWidget {
  final Duration timer;

  const TimerWidgetTest({super.key, required this.timer});

  @override
  State<TimerWidgetTest> createState() => _TimerWidgetTestState();
}

class _TimerWidgetTestState extends State<TimerWidgetTest> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = context.watch<PomodoroController>();

    return CircularCountDownTimer(
      duration: controller.PomodoroDurationInSeconds,
      initialDuration: 0,
      controller: controller.countDownController,
      width: size.width * 0.8,
      height: size.height * 0.35,
      ringColor: secondaryColor,
      fillColor: primaryColor,
      backgroundColor: backgroundColor,
      strokeWidth: 13,
      strokeCap: StrokeCap.round,
      textStyle: textBold.copyWith(
        fontSize: 45.0,
      ),
      textFormat: CountdownTextFormat.MM_SS,
      isReverse: true,
      autoStart: false,
      onStart: () {
        debugPrint('Countdown Started');
      },
      onComplete: () {
        debugPrint('Countdown Ended');
        controller.setPomodoroBreak();
      },
      onChange: (String timeStamp) {
        debugPrint('Countdown Changed $timeStamp');
      },
      timeFormatterFunction: (defaultFormatterFunction, duration) {
        if (duration.inSeconds == 0) {
          return controller.PomodoroDurationInMinutes;
        } else {
          return Function.apply(defaultFormatterFunction, [duration]);
        }
      },
    );
  }
}
