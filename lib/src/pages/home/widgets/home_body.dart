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
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: PrimaryButton(
              color: primaryColor,
              press: () {},
              text: 'Selecionar uma tarefa',
              height: 15,
            ),
          ),
          Positioned(
            top: size.height * 0.2,
            left: 0,
            right: 0,
            child: const TimerWidget(
              timer: Duration(minutes: 10),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: SessionsWidget(sessions: userSessions),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: PrimaryButton(
              color: primaryColor,
              press: () {},
              text: 'Começar foco',
              height: 13,
            ),
          ),
        ],
      ),
    );
  }
}
