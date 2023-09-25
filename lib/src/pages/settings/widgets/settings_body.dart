// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_sense/src/controllers/settings_controller.dart';
import 'package:time_sense/src/pages/settings/widgets/widgets.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final double settignWidth = size.width * 0.9;
    final double settignHeight = size.height * 0.06;

    final settingsController = context.watch<SettingsController>();

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SettingsOptionWidget(
            text: 'Tempo de foco',
            setting: '${settingsController.settings.pomodoroTime} min',
            funtion: () {},
            height: settignHeight,
            width: settignWidth,
            showDetails: true,
          ),
          SettingsOptionWidget(
            text: 'Pausa curta',
            setting: '${settingsController.settings.shortBreakDuration} min',
            funtion: () {},
            height: settignHeight,
            width: settignWidth,
            showDetails: false,
          ),
          SettingsOptionWidget(
            text: 'Pausa longa',
            setting: '${settingsController.settings.longBreakDuration} min',
            funtion: () {},
            height: settignHeight,
            width: settignWidth,
            showDetails: false,
          ),
          SettingsOptionWidget(
            text: 'Sessões diárias',
            setting: '${settingsController.settings.dailySessions}',
            funtion: () {},
            height: settignHeight,
            width: settignWidth,
            showDetails: false,
          ),
          const Spacer(),
          const SettingsOptionsButtons()
        ],
      ),
    );
  }
}
