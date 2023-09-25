import 'package:flutter/material.dart';
import 'package:time_sense/src/controllers/helpers/helpers.dart';
import 'package:time_sense/src/models/models.dart';

class SettingsController extends ChangeNotifier {
  int selectedSettingOptionValue = 0;

  Settings settings = Settings(
    pomodoroTime: 3600,
    shortBreakDuration: 600,
    longBreakDuration: 1200,
    dailySessions: 4,
  );

  SettingsController() {
    convertSettings();
  }

  convertSettings() {
    settings = SettingsHelper.getSettingsTimeInMinutes(settings: settings);
  }

  changeSettingValue({required String settingType, required String action}) {
    if (action == 'increment') {
      selectedSettingOptionValue++;
    } else {
      selectedSettingOptionValue--;
    }
    notifyListeners();
  }
}
