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

    final settingsController = context.read<SettingsController>();

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SettingsOptionWidget(
            text: 'Tempo de foco',
            setting: '${settingsController.settings.pomodoroTime} min',
            settingType: 'pomodoroTime',
          ),
          SettingsOptionWidget(
            text: 'Pausa curta',
            setting: '${settingsController.settings.shortBreakDuration} min',
            settingType: 'shortBreakDuration',
          ),
          SettingsOptionWidget(
            text: 'Pausa longa',
            setting: '${settingsController.settings.longBreakDuration} min',
            settingType: 'longBreakDuration',
          ),
          SettingsOptionWidget(
            text: 'Sessões diárias',
            setting: '${settingsController.settings.dailySessions}',
            settingType: 'dailySessions',
          ),
          const Spacer(),
          const SettingsOptionsButtons(),
        ],
      ),
    );
  }
}
