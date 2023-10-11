import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
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
    pomodoroController = context.read<PomodoroController>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {

    if (state == AppLifecycleState.resumed) {
      if (pomodoroController.pomodoroState == PomodoroState.running) {
        Phoenix.rebirth(context);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final taskController = context.read<TasksController>();
    final pomodoroController = context.watch<PomodoroController>();

    final Pomodoro pomodoro = pomodoroController.pomodoro;
    final pomodoroTime = pomodoro.pomodoroTime;
    final elapsedPomodoroTime = pomodoroController.elapsedPomodoroTime;

    return CircularCountDownTimer(
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
      textFormat: CountdownTextFormat.MM_SS,
      isReverse: true,
      autoStart: pomodoro.status == PomodoroState.running.name ? true : false,
      onComplete: () async {
        if (!pomodoro.shortBreak && !pomodoro.longBreak) {
          int currentPomodoroTaskTime = pomodoroController
              .getCurrentPomodoroTaskTime(pomodoroComplete: true);
          await taskController.savePomodoroTaskTime(
            taskId: pomodoroController.pomodoro.task!.id,
            taskTime: currentPomodoroTaskTime,
            isCompleted: false,
          );
        }

        await pomodoroController.completePomodoro();
      },
      timeFormatterFunction: (defaultFormatterFunction, duration) {
        if (pomodoroController.pomodoroState == PomodoroState.notStarted ||
            pomodoroController.pomodoroState == PomodoroState.pausedTest) {
          return pomodoroController.remainingPomodoroTimeInMinutes;
        } else {
          return Function.apply(defaultFormatterFunction, [duration]);
        }
      },
    );
  }
}
