import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/controllers.dart';
import '../widgets.dart';

class SessionsWidget extends StatefulWidget {
  const SessionsWidget({super.key});

  @override
  State<SessionsWidget> createState() => _SessionsWidgetState();
}

class _SessionsWidgetState extends State<SessionsWidget> {
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
                      lastSession: isLast,
                    );
                  },
                ).animate(interval: 100.ms).fade(duration: 200.ms)),
          ],
        ),
      ),
    );
  }
}
