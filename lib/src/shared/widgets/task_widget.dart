// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';
import '/src/models/models.dart';

import '../utils/utils.dart';
import 'widgets.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final String frontIcon;
  final String backIcon;
  final Function frontFunction;
  final Function widgetFunction;
  Function? pausePomodoro;
  final Function backFunction;
  final bool showFrontIcon;
  final bool pomodoroTask;

  TaskWidget({
    super.key,
    required this.frontIcon,
    required this.backIcon,
    required this.frontFunction,
    required this.backFunction,
    required this.widgetFunction,
    this.pausePomodoro,
    required this.task,
    required this.showFrontIcon,
    required this.pomodoroTask,
  });

  @override
  Widget build(BuildContext context) {
    final Color widgetColor = task.showDetails ? primaryColor : secondaryColor;

    Color backIconColor = task.showDetails ? Colors.red.shade300 : primaryColor;

    return Column(
      children: [
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: widgetColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    showFrontIcon || task.showDetails
                        ? GestureDetector(
                            child: Container(
                              height: 30,
                              width: 30,
                              color: Colors.transparent,
                              child: Center(
                                child: SvgPicture.asset(
                                  frontIcon,
                                  color: task.showDetails
                                      ? blackColor
                                      : primaryColor,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                            onTap: () {
                              frontFunction();
                            },
                          )
                        : const SizedBox(),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(left: 15),
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              task.text,
                              style: textBold,
                            ),
                          ),
                        ),
                        onTap: () {
                          widgetFunction();
                        },
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 35,
                  width: 35,
                  color: Colors.transparent,
                  child: Center(
                    child: SvgPicture.asset(
                      task.showDetails && !pomodoroTask
                          ? 'assets/icons/delete-icon.svg'
                          : backIcon,
                      color: pomodoroTask && task.showDetails
                          ? blackColor
                          : backIconColor,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                onTap: () async {
                  int elapsedTaskTime = 0;
                  Map<String, int>? taskTime;
                  dynamic pomodoroController;
                  if (pomodoroTask) {
                    pomodoroController = context.read<PomodoroController>();
                    elapsedTaskTime =
                        pomodoroController.getCurrentPomodoroTaskTime();
                    taskTime = pomodoroController.convertTaskTime(
                        elapsedTaskTime: elapsedTaskTime);
                    pausePomodoro!();
                  }
                  if ((pomodoroTask && elapsedTaskTime > 0) ||
                      (!pomodoroTask && task.showDetails)) {
                    showDeleteConfirmationDialog(
                      context: context,
                      text: pomodoroTask
                          ? 'Save task focus time?'
                          : 'Permanently delete task?',
                      icon:
                          !pomodoroTask ? 'assets/icons/delete-icon.svg' : null,
                      confirmFunction: () {
                        task.showDetails || pomodoroTask
                            ? backFunction()
                            : null;
                      },
                      deniedFunction: () async {
                        pomodoroTask
                            ? await pomodoroController.removePomodoroTask()
                            : null;
                      },
                      taskTime: taskTime,
                    );
                  } else if (pomodoroTask && elapsedTaskTime < 1) {
                    await pomodoroController.removePomodoroTask();
                  }
                },
              ),
            ],
          ),
        ),
        task.showDetails
            ? Animate(
              effects:  [const FadeEffect(), SlideEffect(duration: 200.ms)],
              child: TaskFocusTimeWidget(
                  taskId: task.id,
                  pomodoroTask: pomodoroTask,
                  taskPending: task.pending,
                ),
            )
            : const SizedBox(),
      ],
    );
  }
}
