import 'package:flutter/material.dart';

import '../../../shared/utils/utils.dart';

class TasksCompletedWidget extends StatelessWidget {
  final int totalTasks;
  final String text;

  const TasksCompletedWidget({
    super.key,
    required this.totalTasks,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(text, style: textRegular),
        ),
        Text('$totalTasks', style: textBold.copyWith(color: primaryColor)),
      ],
    );
  }
}
