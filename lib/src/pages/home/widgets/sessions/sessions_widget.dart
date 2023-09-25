import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/controllers.dart';
import '../widgets.dart';

class SessionsWidget extends StatelessWidget {
  const SessionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PomodoroController>();

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.pomodoroSessions.length,
                (index) {
                  final isLast =
                      index == controller.pomodoroSessions.length - 1;
                  return Session(
                      status: controller.pomodoroSessions[index],
                      lastSession: isLast);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
