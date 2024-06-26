// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/controllers/controllers.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';
import 'widgets.dart';

class HomeBody extends StatefulWidget {
   const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool taped = false;

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
                AnimatedPadding(
                  duration: Duration(milliseconds: 500),
                  padding: EdgeInsets.only(
                    top: pomodoroController.pomodoroState ==
                            PomodoroState.notStarted
                        ? 40
                        : 1,
                  ),
                  child: pomodoroController.pomodoro.task == null
                      ? Container(
                        alignment: Alignment.topCenter,
                        child: PrimaryButton(
                            color: primaryColor,
                            press: () {
                              if (pomodoroController.pomodoroState ==
                                      PomodoroState.running &&
                                  !pomodoroController.pomodoro.shortBreak &&
                                  !pomodoroController.pomodoro.longBreak) {
                                pomodoroController.pausePomodoro();
                              }
                              showHomeBottomSheet(context);
                            },
                            text: 'Select a task',
                            height: 15,
                          ),
                      )
                      : TaskWidget(
                          frontIcon: 'assets/icons/circle-icon.svg',
                          backIcon: 'assets/icons/exit-icon.svg',
                          task: pomodoroController.pomodoro.task!,
                          showFrontIcon: true,
                          pomodoroTask: true,
                          frontFunction: () async {
                            int pomodoroTaskTime = pomodoroController
                                .getCompletePomodoroTaskTime();
                            final bool pomodoroNotStarted =
                                pomodoroController.pomodoroState ==
                                    PomodoroState.notStarted;

                            await taskController.savePomodoroTaskTime(
                              taskId: pomodoroController.pomodoro.task!.id,
                              taskTime: pomodoroTaskTime,
                              isCompleted: true,
                              pomodoroNotStarted: pomodoroNotStarted,
                            );
                            pomodoroController.removePomodoroTask();
                          },
                          backFunction: () async {
                            final bool pomodoroNotStarted =
                                pomodoroController.pomodoroState ==
                                    PomodoroState.notStarted;
                            int currentPomodoroTaskTime = pomodoroController
                                .getCompletePomodoroTaskTime();
                            if (currentPomodoroTaskTime > 0) {
                              await taskController.savePomodoroTaskTime(
                                taskId: pomodoroController.pomodoro.task!.id,
                                taskTime: currentPomodoroTaskTime,
                                isCompleted: false,
                                pomodoroNotStarted: pomodoroNotStarted,
                              );
                            }
                            pomodoroController.removePomodoroTask();
                          },
                          widgetFunction: () {
                            pomodoroController.showPomodoroTaskDetails();
                          },
                          pausePomodoro: () async {
                            if (pomodoroController.pomodoroState ==
                                    PomodoroState.running &&
                                !pomodoroController.pomodoro.shortBreak &&
                                !pomodoroController.pomodoro.longBreak) {
                              await pomodoroController.pausePomodoro();
                            }
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

  PersistentBottomSheetController showHomeBottomSheet(
      BuildContext context) {
    return showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return HomeBottomSheet();
      },
    );
  }
}
