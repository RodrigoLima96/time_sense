import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:time_sense/src/controllers/controllers.dart';

import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PomodoroController>();
    Map<String, Map<String, dynamic>> buttonsInfos = controller.getButtonsInfo();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PrimaryButton(
          color: primaryColor,
          press: () {
            buttonsInfos['first_button']!['function']();
          },
          text: buttonsInfos['first_button']!['text'],
          height: 13,
          width: 25,
        ),
        controller.showSecondButton
            ? Container(
                margin: const EdgeInsets.only(left: 10),
                child: PrimaryButton(
                  color: primaryColor,
                  press: () async {
                    buttonsInfos['second_button']!['function']();
                  },
                  text: buttonsInfos['second_button']!['text'],
                  height: 13,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
