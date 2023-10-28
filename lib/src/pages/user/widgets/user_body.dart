import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_sense/src/controllers/controllers.dart';
import 'package:time_sense/src/pages/user/widgets/widgets.dart';

import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class UserBody extends StatelessWidget {
  const UserBody({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final userController = context.watch<UserController>();

    return userController.userPageState == UserPageState.loaded
        ? SingleChildScrollView(
            child: Container(
              height: size.height,
              width: size.width,
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserCircleAvatar(
                    image: userController.user.image,
                    width: 80,
                    height: 80,
                    borderWidth: 4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    child: Text(userController.user.name!, style: textBold),
                  ),
                  userController.totalFocusTime!['totalSeconds']! > 0
                      ? Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: TotalFocusingTimeWidget(
                            hours: userController.totalFocusTime!['hour']!,
                            minutes: userController.totalFocusTime!['minutes']!,
                            totalSeconds:
                                userController.totalFocusTime!['totalSeconds']!,
                            seconds: userController.totalFocusTime!['seconds']!,
                            text: 'Tempo total de foco',
                            taskPending: true,
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Sem tempo de foco ainda',
                            style: textRegular,
                          ),
                        ),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: TasksCompletedWidget(
                      totalTasks: userController.user.totalTasksDone!,
                      text: 'Total de tarefas concluídas',
                    ),
                  ),
                  if (userController.totalFocusTime!['totalSeconds']! > 0)
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          child:
                              const Text('Total por data', style: textRegular),
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
                          child: TotalFocusingTimeWidget(
                            hours: 1,
                            minutes: 11,
                            seconds: 23,
                            totalSeconds: 4372,
                            text: 'foco',
                            taskPending: true,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: const TasksCompletedWidget(
                              totalTasks: 3, text: 'Tarefas'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
