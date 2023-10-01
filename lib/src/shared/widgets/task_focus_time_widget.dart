import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import 'widgets.dart';

class TaskFocusTimeWidget extends StatelessWidget {
  final String taskId;

  const TaskFocusTimeWidget({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    final taskTime = context.read<TasksController>().taskFocusTime;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TotalFocusingTimeWidget(
        hours: taskTime!['hour']!,
        minutes: taskTime['minutes']!,
        seconds: taskTime['seconds']!,
        text: 'Tempo de foco',
      ),
    );
  }
}
