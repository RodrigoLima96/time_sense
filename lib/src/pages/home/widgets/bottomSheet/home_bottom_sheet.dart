import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_sense/src/controllers/controllers.dart';
import 'package:time_sense/src/models/models.dart';
import '../../../../controllers/task_controller.dart';
import './task_container_bottom_sheet.dart';

import '../../../../shared/utils/utils.dart';
import '../../../../shared/widgets/widgets.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final taskcontroller = context.watch<TaskController>();
    final pomodoroController = context.watch<PomodoroController>();

    Size size = MediaQuery.of(context).size;

    return Container(
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
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    taskcontroller.pendingTaskList.length,
                    (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: TaskContainerBottomSheet(
                          backIcon: 'assets/icons/right-arrow.svg',
                          press: () {
                            pomodoroController.setPomodoroTask(
                              taskId: taskcontroller.pendingTaskList[index].id,
                            );
                            Navigator.pop(context);
                          },
                          text: taskcontroller.pendingTaskList[index].text,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20, top: 20),
              child: PrimaryButton(
                text: 'Fechar',
                press: () => Navigator.pop(context),
                color: primaryColor,
                height: 10,
                width: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
