// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/controllers/controllers.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';
import 'widgets.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final pomodoroController = context.watch<PomodoroController>();
    final taskController = context.read<TasksController>();

    return pomodoroController.pomodoroPageState == PomodoroPageState.loaded
        ? SizedBox(
            height: size.height,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: pomodoroController.pomodoro.task == null
                      ? PrimaryButton(
                          color: primaryColor,
                          press: () {
                            if (pomodoroController.pomodoroState ==
                                PomodoroState.running) {
                              pomodoroController.pausePomodoro();
                            }
                            showHomeBottomSheet(context);
                          },
                          text: 'Selecionar uma tarefa',
                          height: 15,
                        )
                      : TaskWidget(
                          frontIcon: 'assets/icons/circle-icon.svg',
                          backIcon: 'assets/icons/exit-icon.svg',
                          task: pomodoroController.pomodoro.task!,
                          showFrontIcon: true,
                          pomodoroTask: true,
                          frontFunction: () async {
                            int currentPomodoroTaskTime =
                                pomodoroController.getCurrentPomodoroTaskTime(pomodoroComplete: false);
                            await taskController.savePomodoroTaskTime(
                              taskId: pomodoroController.pomodoro.task!.id,
                              taskTime: currentPomodoroTaskTime,
                              isCompleted: true,
                            );

                            pomodoroController.removePomodoroTask();
                          },
                          backFunction: () async {
                            int currentPomodoroTaskTime =
                                pomodoroController.getCurrentPomodoroTaskTime(pomodoroComplete: false);
                            if (currentPomodoroTaskTime > 0) {
                             await taskController.savePomodoroTaskTime(
                                taskId: pomodoroController.pomodoro.task!.id,
                                taskTime: currentPomodoroTaskTime,
                                isCompleted: false,
                              );
                            }

                            pomodoroController.removePomodoroTask();
                          },
                          widgetFunction: () {
                            pomodoroController.showPomodoroTaskDetails();
                          },
                        ),
                ),
                Positioned(
                  top: size.height * 0.2,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: const [
                      TimerWidget(),
                      SizedBox(height: 50),
                      SessionsWidget(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: HomeButtons(),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  PersistentBottomSheetController<dynamic> showHomeBottomSheet(
      BuildContext context) {
    return showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return HomeBottomSheet();
      },
    );
  }
}
