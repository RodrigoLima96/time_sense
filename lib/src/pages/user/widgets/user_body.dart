import 'package:flutter/material.dart';
import 'package:time_sense/src/pages/user/widgets/widgets.dart';

import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class UserBody extends StatelessWidget {
  const UserBody({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const UserCircleAvatar(
              urlImage:
                  'https://lh3.googleusercontent.com/a/ACg8ocLaTq8NZFKl6beN5lRJwu5wUK7oumdHghVdQBwVEuZMayw=s288-c-no',
              width: 80,
              height: 80,
              borderWidth: 4,
            ),
    
            Container(
              margin: const EdgeInsets.only(top: 14),
              child: const Text('Rodrigo Lima', style: textBold),
            ),
            
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const TotalFocusingTimeWidget(
                  hours: 89, minutes: 23, text: 'Tempo total de foco'),
            ),
    
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const TasksCompletedWidget(
                  totalTasks: 24, text: 'Total de tarefas concluídas'),
            ),
    
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Text('Total por data', style: textRegular),
            ),
    
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: PrimaryButton(
                text: 'hoje',
                press: () {},
                color: secondaryColor,
                height: 6,
                backIcon: 'assets/icons/arrow-back-icon.svg',
              ),
            ),
    
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const TotalFocusingTimeWidget(
                hours: 1,
                minutes: 11,
                text: 'foco',
              ),
            ),
    
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const TasksCompletedWidget(
                  totalTasks: 3, text: 'Tarefas'),
            ),
          ],
        ),
      ),
    );
  }
}
