import 'package:flutter/material.dart';

import '/src/controllers/helpers/helpers.dart';
import '/src/models/models.dart';
import '/src/repositories/settings_repository.dart';

enum SettingsPageState { loading, loaded }

class SettingsController extends ChangeNotifier {
  final SettingsRepository settingsRepository;

  int selectedSettingOptionValue = 0;
  String selectedSettingOptionName = '';
  String lastSettingOptionName = '';

  late Settings settings;
  late Settings oldSettings;

  bool enableButtons = false;
  bool showSettingsDetails = false;
  SettingsPageState settingsPageState = SettingsPageState.loading;

  SettingsController(this.settingsRepository) {
    getCurrentSettings();
  }

  getCurrentSettings() async {
    settings = await settingsRepository.getSettings();
    settings =
        SettingsHelper.convertSettingsTime(settings: settings, toMinutes: true);

    oldSettings = SettingsHelper.getSettingsCopy(settings: settings);

    settingsPageState = SettingsPageState.loaded;
    notifyListeners();
  }

  bool showSettinsDetails({required String settingType}) {
    return showSettingsDetails && selectedSettingOptionName == settingType;
  }

  selectSettingOption({required String settingType}) {
    settings = SettingsHelper.getLastSettingsValues(
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
      }
    }
    selectedSettingOptionValue = SettingsHelper.getSelectedSettingOptionValue(
      settings: settings,
      settingType: settingType,
    );

    selectedSettingOptionName = settingType;
    lastSettingOptionName = settingType;
    showSettingsDetails = true;
    notifyListeners();
  }

  changeSettingValue({required String settingType, required String action}) {
    selectedSettingOptionValue =
        SettingsHelper.getNewSelectedSettingOptionValue(
      action: action,
      selectedSettingOptionValue: selectedSettingOptionValue,
    );

    settings = SettingsHelper.getLastSettingsValues(
      settings: settings,
      lastSettingOptionName: lastSettingOptionName,
      settingValue: selectedSettingOptionValue,
    );

    enableButtons = SettingsHelper.enableButtons(
        oldSettings: oldSettings, settings: settings);
    notifyListeners();
  }

  cancelChanges() {
    if (enableButtons) {
      settings = SettingsHelper.getSettingsCopy(settings: oldSettings);
      resetPageOptions();
      notifyListeners();
    }
  }

  saveSettings() async {
    if (enableButtons) {
      settings = SettingsHelper.convertSettingsTime(
          settings: settings, toMinutes: false);

      await settingsRepository.saveSettings(settings: settings);
      await getCurrentSettings();
      resetPageOptions();
      notifyListeners();
    }
  }

  resetPageOptions() {
    showSettingsDetails = false;
    selectedSettingOptionValue = 0;
    selectedSettingOptionName = "";
    lastSettingOptionName = "";
    enableButtons = false;
  }
}
