import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import 'widgets.dart';

class TaskFocusTimeWidget extends StatelessWidget {
  final String taskId;
  final bool pomodoroTask;
  final bool taskPending;

  const TaskFocusTimeWidget({
    super.key,
    required this.taskId,
    required this.pomodoroTask,
    required this.taskPending,
  });

  @override
  Widget build(BuildContext context) {
    final taskTime = !pomodoroTask
        ? context.read<TasksController>().taskFocusTime
        : context.read<PomodoroController>().taskFocusTime;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TotalFocusingTimeWidget(
        hours: taskTime!['hour']!,
        minutes: taskTime['minutes']!,
        totalSeconds: taskTime['totalSeconds']!,
        seconds: taskTime['seconds']!,
        text: 'Tempo de foco',
        taskPending: taskPending,
      ),
    );
  }
}
