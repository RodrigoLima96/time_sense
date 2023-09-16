import 'package:flutter/material.dart';

import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

import 'widgets.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final List<String> userSessions = [
      'complete',
      'complete',
      'running',
      'incomplete',
    ];

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Column(
        children: [
          PrimaryButton(
            color: primaryColor,
            press: () {},
            text: 'Selecionar uma tarefa',
          ),
          const SizedBox(height: 50),
          const TimerWidget(
            timer: Duration(minutes: 10),
          ),
          const SizedBox(height: 30),
          SessionsWidget(sessions: userSessions),
          const SizedBox(height: 50),
          PrimaryButton(
            color: primaryColor,
            press: () {},
            text: 'Começar foco',
          ),
        ],
      ),
    );
  }
}
