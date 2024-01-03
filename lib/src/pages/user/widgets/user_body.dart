import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '/src/controllers/controllers.dart';
import '/src/pages/user/widgets/widgets.dart';

import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class UserBody extends StatefulWidget {
  const UserBody({super.key});

  @override
  State<UserBody> createState() => _UserBodyState();
}

class _UserBodyState extends State<UserBody> {
  @override
  void initState() {
    context.read<UserController>().getUser();
    super.initState();
  }

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
                    image: userController.image,
                    width: 110,
                    height: 110,
                    borderWidth: 4,
                    function: userController.updateImage,
                  ).animate(delay: 1000.ms).scale(duration: 500.ms).fade(duration: 900.ms),
                  const UsernameWidget().animate(delay: 1200.ms).scale(duration: 500.ms).fade(duration: 900.ms),
                  userController.totalFocusTime!['totalSeconds']! > 0
                      ? Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: TotalFocusingTimeWidget(
                            hours: userController.totalFocusTime!['hour']!,
                            minutes: userController.totalFocusTime!['minutes']!,
                            totalSeconds:
                                userController.totalFocusTime!['totalSeconds']!,
                            seconds: userController.totalFocusTime!['seconds']!,
                            text: 'Total focus time',
                            taskPending: true,
                          ),
                        ).animate(delay: 500.ms).slideX().fade(duration: 900.ms)
                      : const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'No focus time yet',
                            style: textRegular,
                          ),
                        ).animate(delay: 500.ms).slideX().fade(duration: 900.ms),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: TasksCompletedWidget(
                      totalTasks: userController.user.totalTasksDone,
                      text: 'Total Completed Tasks',
                    ),
                  ).animate(delay: 500.ms).slideX().fade(duration: 900.ms),
                  if (userController.totalFocusTime!['totalSeconds']! > 0)
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          child:
                              const Text('Total by date', style: textRegular),
                        ),
                        const StatisticsByDateWidget(),
                      ],
                    ).animate(delay: 500.ms).slideX().fade(duration: 900.ms),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
