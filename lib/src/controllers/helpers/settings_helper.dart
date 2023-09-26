import 'package:time_sense/src/controllers/helpers/helpers.dart';

import '../../models/models.dart';

class SettingsHelper {
  static Settings getSettingsTimeInMinutes({required Settings settings}) {
    settings.pomodoroTime = Helper.convertSecondsToMinutes(
        durationInSeconds: settings.pomodoroTime, settings: true);

    settings.shortBreakDuration = Helper.convertSecondsToMinutes(
        durationInSeconds: settings.shortBreakDuration, settings: true);

    settings.longBreakDuration = Helper.convertSecondsToMinutes(
        durationInSeconds: settings.longBreakDuration, settings: true);
    return settings;
  }

  static Settings getSettingsTimeInSeconds({required Settings settings}) {
    settings.pomodoroTime = Helper.convertMinutesToSeconds(
        durationInMinutes: settings.pomodoroTime, settings: true);

    settings.shortBreakDuration = Helper.convertMinutesToSeconds(
        durationInMinutes: settings.shortBreakDuration, settings: true);

    settings.longBreakDuration = Helper.convertMinutesToSeconds(
        durationInMinutes: settings.longBreakDuration, settings: true);
    return settings;
  }
}
