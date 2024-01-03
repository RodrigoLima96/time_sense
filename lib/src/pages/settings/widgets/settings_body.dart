// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:time_sense/src/controllers/settings_controller.dart';
import 'package:time_sense/src/pages/settings/widgets/widgets.dart';

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  @override
  void initState() {
    _loadSettingsState();
    super.initState();
  }

  _loadSettingsState() async {
    await context.read<SettingsController>().getCurrentSettings();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final settingsController = context.watch<SettingsController>();

    return settingsController.settingsPageState == SettingsPageState.loaded
        ? SingleChildScrollView(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SettingsOptionWidget(
                        text: 'Focus time',
                        setting:
                            '${settingsController.settings.pomodoroTime} min',
                        settingType: 'pomodoroTime',
                      ),
                      SettingsOptionWidget(
                        text: 'Short break',
                        setting:
                            '${settingsController.settings.shortBreakDuration} min',
                        settingType: 'shortBreakDuration',
                      ),
                      SettingsOptionWidget(
                        text: 'Long break',
                        setting:
                            '${settingsController.settings.longBreakDuration} min',
                        settingType: 'longBreakDuration',
                      ),
                      SettingsOptionWidget(
                        text: 'pomodoros until long break',
                        setting:
                            '${settingsController.settings.shortBreakCount}',
                        settingType: 'shortBreakCount',
                      ),
                      SettingsOptionWidget(
                        text: 'Daily sessions',
                        setting: '${settingsController.settings.dailySessions}',
                        settingType: 'dailySessions',
                      ),
                      SettingsOptionWidget(
                        text: 'Allow Notifications',
                        setting: settingsController.notificationsAllowed
                            ? 'Yes'
                            : 'No',
                        settingType: 'notification',
                        notification: true,
                      ),
                    ].animate(interval: 200.ms).fade().slideX(),
                  ),
                  const SizedBox(height: 100),
                  const SettingsOptionsButtons()
                      .animate()
                      .fade(duration: 700.ms)
                      .scale(duration: 400.ms),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
