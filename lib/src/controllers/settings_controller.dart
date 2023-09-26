import 'package:flutter/material.dart';
import 'package:time_sense/src/controllers/helpers/helpers.dart';
import 'package:time_sense/src/models/models.dart';

enum SettingsPageState { loading, loaded }

class SettingsController extends ChangeNotifier {
  int selectedSettingOptionValue = 1;
  String selectedSettingOptionName = '';
  late Settings settings;
  SettingsPageState settingsPageState = SettingsPageState.loading;

  bool showSettingsDetails = false;

  SettingsController() {
    getCurrentSettings();
  }

  getCurrentSettings() {
    settings = Settings(
      pomodoroTime: 3600,
      shortBreakDuration: 600,
      longBreakDuration: 1200,
      dailySessions: 4,
    );

    settings = SettingsHelper.getSettingsTimeInMinutes(settings: settings);
    settingsPageState = SettingsPageState.loaded;
  }

  selectSettingOption({required String settingType}) {
    if (showSettingsDetails) {
      if (settingType != "" && selectedSettingOptionName == settingType) {
        selectedSettingOptionName = "";
        showSettingsDetails = false;
        notifyListeners();
        return;
      }
      else {

      }
    }

    switch (settingType) {
      case 'pomodoroTime':
        selectedSettingOptionValue = settings.pomodoroTime;
        break;
      case 'shortBreakDuration':
        selectedSettingOptionValue = settings.shortBreakDuration;
        break;
      case 'longBreakDuration':
        selectedSettingOptionValue = settings.longBreakDuration;
        break;
      case 'dailySessions':
        selectedSettingOptionValue = settings.dailySessions;
        break;
      default:
        selectedSettingOptionValue = 1;
        break;
    }
    
    selectedSettingOptionName = settingType;
    showSettingsDetails = true;

    notifyListeners();
  }

  changeSettingValue({required String settingType, required String action}) {
    if (action == 'increment') {
      if (selectedSettingOptionValue > 0) {
        selectedSettingOptionValue++;
      }
    } else {
      if (selectedSettingOptionValue > 1) {
        selectedSettingOptionValue--;
      }
    }
    notifyListeners();
  }
}
