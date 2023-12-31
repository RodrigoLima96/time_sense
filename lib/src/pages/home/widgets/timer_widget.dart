import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import '../../../controllers/controllers.dart';
import '../../../shared/utils/constants.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> with WidgetsBindingObserver {
  late PomodoroController pomodoroController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.hidden) {
      if (pomodoroController.pomodoroState == PomodoroState.running) {
        pomodoroController.appHidden = true;
      }
    }
    if (state == AppLifecycleState.resumed) {
      if (pomodoroController.pomodoroState == PomodoroState.running &&
          pomodoroController.appHidden) {
        Phoenix.rebirth(context);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final taskController = context.read<TasksController>();
    pomodoroController = context.watch<PomodoroController>();

    final Pomodoro pomodoro = pomodoroController.pomodoro;
    final pomodoroTime = pomodoro.pomodoroTime;
    final elapsedPomodoroTime = pomodoroController.elapsedPomodoroTime;

    return Animate(
      effects: [ScaleEffect(duration: 200.ms), FadeEffect(duration: 500.ms)],
      key: pomodoroController.animatePomodoroKey,
      child: CircularCountDownTimer(
        duration: pomodoroTime,
        initialDuration: elapsedPomodoroTime,
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
        textFormat: pomodoroTime <= 3600
            ? CountdownTextFormat.MM_SS
            : CountdownTextFormat.HH_MM_SS,
        isReverse: true,
        autoStart: pomodoro.status == PomodoroState.running.name ? true : false,
        onComplete: () async {
          await pomodoroController.completePomodoro();
          pomodoroController.pomodoro.task != null
              ? taskController.updateTaskTime(
                  pomodoroTask: pomodoroController.pomodoro.task!)
              : null;
          pomodoroController.resetPomodoroAnimation();
        },
        timeFormatterFunction: (defaultFormatterFunction, duration) {
          if (pomodoroController.pomodoroState == PomodoroState.notStarted ||
              pomodoroController.pomodoroState == PomodoroState.rebootpaused) {
            return pomodoroController.remainingPomodoroTimeInMinutes;
          } else {
            return Function.apply(defaultFormatterFunction, [duration]);
          }
        },
      ),
    );
  }
}
