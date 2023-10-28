import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '/src/controllers/helpers/helpers.dart';
import '/src/models/models.dart';
import '/src/repositories/settings_repository.dart';

enum SettingsPageState { loading, loaded }

class SettingsController extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  int selectedSettingOptionValue = 0;
  String selectedSettingOptionName = '';
  String lastSettingOptionName = '';

  bool notificationsAllowed = false;
  bool changeNotificationsPermission = false;

  late Settings settings;
  late Settings oldSettings;

  bool enableButtons = false;
  bool showSettingsDetails = false;
  SettingsPageState settingsPageState = SettingsPageState.loading;

  SettingsController(this._settingsRepository) {
    getCurrentSettings();
  }

  getCurrentSettings() async {
    settings = await _settingsRepository.getSettings();
    settings =
        SettingsHelper.convertSettingsTime(settings: settings, toMinutes: true);

    oldSettings = SettingsHelper.getSettingsCopy(settings: settings);

    await checkNotificationPermission();

    settingsPageState = SettingsPageState.loaded;
    notifyListeners();
  }

  bool showSettinsDetails({required String settingType}) {
    return showSettingsDetails && selectedSettingOptionName == settingType;
  }

  selectSettingOption({required String settingType, bool? exit}) {
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
      settingType: settingType,
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

      await _settingsRepository.saveSettings(settings: settings);
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

  checkNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    notificationsAllowed = status.isGranted ? true : false;
    changeNotificationsPermission = false;
    resetPageOptions();
    notifyListeners();
  }

  chageNotificationPermission() {
    openAppSettings();
  }
}
