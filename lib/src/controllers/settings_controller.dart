import 'package:flutter/material.dart';
import 'package:time_sense/src/controllers/controllers.dart';
import 'package:time_sense/src/controllers/helpers/helpers.dart';
import 'package:time_sense/src/models/models.dart';
import 'package:time_sense/src/repositories/settings_repository.dart';

enum SettingsPageState { loading, loaded }

class SettingsController extends ChangeNotifier {
  final SettingsRepository settingsRepository;
  final PomodoroController podomoroController;

  int selectedSettingOptionValue = 0;
  String selectedSettingOptionName = '';
  String lastSettingOptionName = '';

  late Settings settings;
  late Settings oldSettings;

  bool enableButtons = false;
  bool showSettingsDetails = false;
  SettingsPageState settingsPageState = SettingsPageState.loading;

  SettingsController(this.settingsRepository, this.podomoroController) {
    getCurrentSettings();
  }

  getCurrentSettings() async {
    settings = await settingsRepository.getSettings();

    settings = SettingsHelper.getSettingsTimeInMinutes(settings: settings);
    settingsPageState = SettingsPageState.loaded;

    oldSettings = oldSettings = Settings(
      pomodoroTime: settings.pomodoroTime,
      shortBreakDuration: settings.shortBreakDuration,
      longBreakDuration: settings.longBreakDuration,
      dailySessions: settings.dailySessions,
    );

    notifyListeners();
  }

  selectSettingOption({required String settingType}) {
    settings = saveSettingsOnScreen(
      settings: settings,
      lastSettingOptionName: lastSettingOptionName,
      settingValue: selectedSettingOptionValue,
    );

    if (showSettingsDetails) {
      if (settingType != "" && selectedSettingOptionName == settingType) {
        selectedSettingOptionName = "";
        lastSettingOptionName = settingType;
        showSettingsDetails = false;
        notifyListeners();
        return;
      } else {}
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
    }

    selectedSettingOptionName = settingType;
    lastSettingOptionName = settingType;
    showSettingsDetails = true;

    notifyListeners();
  }

  Settings saveSettingsOnScreen({
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
        break;
      case 'dailySessions':
        settings.dailySessions = settingValue;
    }
    return settings;
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
    settings = saveSettingsOnScreen(
      settings: settings,
      lastSettingOptionName: lastSettingOptionName,
      settingValue: selectedSettingOptionValue,
    );
    if (oldSettings != settings) {
      enableButtons = true;
    } else {
      enableButtons = false;
    }
    notifyListeners();
  }

  cancelChanges() {
    if (enableButtons) {
      settings = Settings(
        pomodoroTime: oldSettings.pomodoroTime,
        shortBreakDuration: oldSettings.shortBreakDuration,
        longBreakDuration: oldSettings.longBreakDuration,
        dailySessions: oldSettings.dailySessions,
      );

      resetPageOptions();
    }
  }

  saveSettings() async {
    if (enableButtons) {
      settings = SettingsHelper.getSettingsTimeInSeconds(settings: settings);
      await settingsRepository.saveSettings(settings: settings);
      await getCurrentSettings();
      await podomoroController.updatePomodoroAfterSettingsChanges();
      resetPageOptions();
    }
  }

  resetPageOptions() {
    showSettingsDetails = false;
    selectedSettingOptionValue = 0;
    selectedSettingOptionName = "";
    lastSettingOptionName = "";
    enableButtons = false;
    notifyListeners();
  }
}
