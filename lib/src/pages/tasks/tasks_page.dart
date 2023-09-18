import 'package:flutter/material.dart';

import '../../shared/utils/utils.dart';
import '../../shared/widgets/widgets.dart';
import 'widgets/widgets.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        icon: 'assets/icons/arrow-back-icon.svg',
        function: () => Navigator.of(context).pop(),
      ),
      body: const TasksPageBody(),
      bottomSheet: Container(
        color: backgroundColor,
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.1, vertical: size.height * 0.01),
        child: const AddTaskWidget(),
      ),
    );
  }
}
