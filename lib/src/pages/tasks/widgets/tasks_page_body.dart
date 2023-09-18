import 'package:flutter/material.dart';
import 'package:time_sense/src/pages/settings/widgets/widgets.dart';
import 'package:time_sense/src/shared/utils/utils.dart';

import 'widgets.dart';

class TasksPageBody extends StatelessWidget {
  const TasksPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final List<int> mockData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          SettingsOptionWidget(
            text: 'Tarefas Concluídas',
            setting: '',
            funtion: () {},
            height: 40,
            width: 220,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 30),
            child: Text(
              '33',
              style: textBold.copyWith(color: primaryColor),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  mockData.length,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: TaskWidget(
                        frontIcon: 'assets/icons/start.svg',
                        backIcon: index == 2 ? 'assets/icons/delete-icon.svg' : 'assets/icons/pending-icon.svg',
                        backIconColor: index == 2 ? Colors.red.shade300 : primaryColor,
                        showFrontIcon: index == 2 ? true : false,
                        text: 'Estudar flutter',
                        widgetColor: index == 2 ? primaryColor : secondaryColor,
                        showTaskDetails: index == 2 ? true : false,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
