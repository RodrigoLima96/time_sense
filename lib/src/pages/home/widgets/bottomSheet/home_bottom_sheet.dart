import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:time_sense/src/controllers/controllers.dart';
import './task_container_bottom_sheet.dart';

import '../../../../shared/utils/utils.dart';
import '../../../../shared/widgets/widgets.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tasksController = context.watch<TasksController>();
    final pomodoroController = context.watch<PomodoroController>();

    Size size = MediaQuery.of(context).size;

    return TapRegion(
      onTapOutside: (event) => Navigator.pop(context),
      child: Container(
        height: size.height * 0.5,
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: const AddTaskWidget(),
              ),
              Expanded(
                child: tasksController.taskskBottomSheetState !=
                        TaskskBottomSheetState.loading
                    ? SingleChildScrollView(
                        child: tasksController.pendingTaskList.isNotEmpty
                            ? Column(
                                children: List.generate(
                                  tasksController.pendingTaskList.length,
                                  (index) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: TaskContainerBottomSheet(
                                        backIcon: 'assets/icons/right-arrow-icon.svg',
                                        press: () {
                                          pomodoroController.setPomodoroTask(
                                            taskId: tasksController
                                                .pendingTaskList[index].id,
                                          );
                                          Navigator.pop(context);
                                        },
                                        text: tasksController
                                            .pendingTaskList[index].text,
                                      ),
                                    );
                                  },
                                ).animate(interval: 200.ms).fade().slideX(),
                              )
                            : Container(
                                margin: const EdgeInsets.only(top: 100),
                                child: const Center(
                                  child: Text(
                                    'No tasks created',
                                    style: textBold,
                                  ),
                                ),
                              ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20, top: 20),
                child: PrimaryButton(
                  text: 'Close',
                  press: () {
                    tasksController.textFieldlHintText = "Create task...";
                    Navigator.pop(context);
                  },
                  color: primaryColor,
                  height: 10,
                  width: 40,
                ).animate().fade().slide(begin: const Offset(0, 1), duration: 350.milliseconds)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
