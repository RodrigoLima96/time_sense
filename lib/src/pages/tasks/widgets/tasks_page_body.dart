import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_sense/src/pages/settings/widgets/widgets.dart';
import 'package:time_sense/src/pages/tasks/widgets/widgets.dart';
import '/src/shared/utils/utils.dart';

import '../../../controllers/controllers.dart';

class TasksPageBody extends StatelessWidget {
  const TasksPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final tasksController = context.watch<TasksController>();

    final tasksListLength = tasksController.isPendingTasksPage
        ? tasksController.pendingTaskList.length
        : tasksController.completeTaskList.length;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          const TasksStatusWidget(),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 30),
            child: Text(
              tasksListLength.toString(),
              style: textBold.copyWith(color: primaryColor, fontSize: 16),
            ),
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: TasksList(),
            ),
          )
        ],
      ),
    );
  }
}