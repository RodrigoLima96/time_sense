// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/controllers/controllers.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';
import 'widgets.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final pomodoroController = context.watch<PomodoroController>();
    final taskController = context.read<TaskController>();

    return pomodoroController.pomodoroPageState == PomodoroPageState.loaded
        ? SizedBox(
            height: size.height,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: pomodoroController.pomodoro.task == null
                      ? PrimaryButton(
                          color: primaryColor,
                          press: () {
                            showHomeBottomSheet(context);
                          },
                          text: 'Selecionar uma tarefa',
                          height: 15,
                        )
                      : TaskWidget(
                          frontIcon: 'assets/icons/circle.svg',
                          backIcon: 'assets/icons/exit-icon.svg',
                          text: 'Desenvolver time sense app',
                          showFrontIcon: true,
                          backIconColor: primaryColor,
                          widgetColor: secondaryColor,
                          showTaskDetails: false,
                          frontFunction: () {},
                          backFunction: () {
                            pomodoroController.removePomodoroTask();
                            taskController.textFieldlHintText =
                                'Criar tarefa...';
                          },
                          widgetFunction: () {},
                          // !taskDetailsFuncion:
                          // calcular na hora o tempo do pomodoro atual
                          // para mostrar o tempo total de foco da task
                        ),
                ),
                Positioned(
                  top: size.height * 0.2,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: const [
                      TimerWidget(),
                      SizedBox(height: 50),
                      SessionsWidget(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: HomeButtons(),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  PersistentBottomSheetController<dynamic> showHomeBottomSheet(
      BuildContext context) {
    return showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return HomeBottomSheet();
      },
    );
  }
}
