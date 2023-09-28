import 'package:time_sense/src/controllers/helpers/helpers.dart';

import '../../models/models.dart';

class SettingsHelper {
  static Settings convertSettingsTime({
    required Settings settings,
    required bool toMinutes,
  }) {
    if (toMinutes) {
      settings.pomodoroTime = Helper.convertSecondsToMinutes(
          durationInSeconds: settings.pomodoroTime, settings: true);

      settings.shortBreakDuration = Helper.convertSecondsToMinutes(
          durationInSeconds: settings.shortBreakDuration, settings: true);

      settings.longBreakDuration = Helper.convertSecondsToMinutes(
          durationInSeconds: settings.longBreakDuration, settings: true);
    } else {
      settings.pomodoroTime = Helper.convertMinutesToSeconds(
          durationInMinutes: settings.pomodoroTime, settings: true);

      settings.shortBreakDuration = Helper.convertMinutesToSeconds(
          durationInMinutes: settings.shortBreakDuration, settings: true);

      settings.longBreakDuration = Helper.convertMinutesToSeconds(
          durationInMinutes: settings.longBreakDuration, settings: true);
    }

    return settings;
  }

  static Settings getLastSettingsValues({
    required Settings settings,
    required String lastSettingOptionName,
    required int settingValue,
  }) {
    switch (lastSettingOptionName) {
      case 'pomodoroTime':
        settings.pomodoroTime = settingValue;
        break;
      case 'shortBreakDuration':
        settings.shortBreakDuration = settingValue;
        break;
      case 'longBreakDuration':
        settings.longBreakDuration = settingValue;
      case 'shortBreakCount':
        settings.shortBreakCount = settingValue;
        break;
      case 'dailySessions':
        settings.dailySessions = settingValue;
    }
    return settings;
  }

  static int getSelectedSettingOptionValue({
    required Settings settings,
    required String settingType,
  }) {
    int selectedSettingOptionValue = 0;
    switch (settingType) {
      case 'pomodoroTime':
        selectedSettingOptionValue = settings.pomodoroTime;
        break;
      case 'shortBreakDuration':
        selectedSettingOptionValue = settings.shortBreakDuration;
        break;
      case 'longBreakDuration':
        selectedSettingOptionValue = settings.longBreakDuration;
      case 'shortBreakCount':
        selectedSettingOptionValue = settings.shortBreakCount;
        break;
      case 'dailySessions':
        selectedSettingOptionValue = settings.dailySessions;
    }

    return selectedSettingOptionValue;
  }

  static int getNewSelectedSettingOptionValue({
    required String action,
    required int selectedSettingOptionValue,
    required String settingType,
  }) {
    if (action == 'increment') {
      if (selectedSettingOptionValue > 0) {
        selectedSettingOptionValue++;
      }
    } else {
      if (selectedSettingOptionValue == 2 && settingType == 'shortBreakCount') {
        return selectedSettingOptionValue;
      }
      if (selectedSettingOptionValue > 1) {
        selectedSettingOptionValue--;
      }
    }
    return selectedSettingOptionValue;
  }

  static bool enableButtons(
      {required Settings oldSettings, required Settings settings}) {
    bool enableButtons = false;
    if (oldSettings != settings) {
      enableButtons = true;
    } else {
      enableButtons = false;
    }
    return enableButtons;
  }

  static Settings getSettingsCopy({required Settings settings}) {
    return Settings(
      pomodoroTime: settings.pomodoroTime,
      shortBreakDuration: settings.shortBreakDuration,
      longBreakDuration: settings.longBreakDuration,
      shortBreakCount: settings.shortBreakCount,
      dailySessions: settings.dailySessions,
    );
  }
}
