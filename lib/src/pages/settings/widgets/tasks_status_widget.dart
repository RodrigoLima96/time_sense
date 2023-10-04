// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/utils/utils.dart';

class TasksStatusWidget extends StatelessWidget {
  const TasksStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksController = context.watch<TasksController>();

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        tasksController.changeIsPendingTasksPage();
        tasksController.setTaskShowDetails();
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
    );
  }
}
