import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final tasksController = context.watch<TasksController>();
    final pomodoroController = context.read<PomodoroController>();

    if (pomodoroController.pomodoro.task != null) {
      tasksController.updateTaskTime(
          pomodoroTask: pomodoroController.pomodoro.task!);
    }
    bool isPending = tasksController.isPendingTasksPage;

    final tasksList = isPending
        ? tasksController.pendingTaskList
        : tasksController.completeTaskList;

    final String taskListEmptyText =
        isPending ? 'Nenhuma tarefa pendente' : 'Nenhuma tarefa concluída';

    return tasksList.isNotEmpty
        ? SizedBox(
            width: size.width,
            height: size.height * 0.7,
            child: ListView.builder(
              itemCount: tasksList.length,
              itemBuilder: (context, index) {
                final task = tasksList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TaskWidget(
                    frontIcon: isPending
                        ? 'assets/icons/circle-icon.svg'
                        : 'assets/icons/restore-icon.svg',
                    backIcon: isPending
                        ? 'assets/icons/pending-icon.svg'
                        : 'assets/icons/check-icon.svg',
                    task: task,
                    pomodoroTask: false,
                    showFrontIcon: false,
                    frontFunction: () {
                      pomodoroController.pomodoro.taskId == task.id
                          ? pomodoroController.removePomodoroTask()
                          : null;
                      tasksController.setTaskAscompleteOrPending(
                        taskId: task.id,
                      );
                    },
                    backFunction: () {
                      tasksController.deleteTask(taskId: task.id);
                      if (pomodoroController.pomodoro.taskId == task.id) {
                        pomodoroController.removePomodoroTask();
                      }
                    },
                    widgetFunction: () {
                      tasksController.showTaskDetailsFunction(
                        taskId: task.id,
                      );
                    },
                  ),
                );
              },
            ).animate(target: isPending ? 0 : 1).
            shake(rotation: 0.01))
        : Container(
            margin: const EdgeInsets.only(top: 100),
            child: Center(
              child: Text(
                taskListEmptyText,
                style: textBold,
              ),
            ),
          );
  }
}
