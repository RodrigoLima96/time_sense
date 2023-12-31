// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/utils/utils.dart';

class TasksStatusWidget extends StatefulWidget {
  const TasksStatusWidget({super.key});

  @override
  State<TasksStatusWidget> createState() => _TasksStatusWidgetState();
}

class _TasksStatusWidgetState extends State<TasksStatusWidget> {
  @override
  Widget build(BuildContext context) {
    final tasksController = context.watch<TasksController>();

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        setState(() {
          tasksController.setTaskShowDetails();
          tasksController.changeIsPendingTasksPage();
          tasksController.resetTaskListAnimation();
        });
      },
      child: Container(
        height: 40,
        width: 250,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: secondaryColor,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tasksController.pageTitleText, style: textBold),
              const Spacer(),
              SvgPicture.asset(
                'assets/icons/swap-icon.svg',
                width: 25,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ),
    ).animate(target: tasksController.pageTitleText == 'Pending tasks' ? 1 : 0).flip(end: 1).flip(end: 1);
  }
}
