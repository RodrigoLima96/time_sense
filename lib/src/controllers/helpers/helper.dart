import 'package:time_sense/src/models/models.dart';

class Helper {
  static dynamic convertSecondsToMinutes(
      {required int durationInSeconds, bool settings = false}) {
    if (settings) {
      return durationInSeconds ~/ 60;
    } else {
      String minutes = (durationInSeconds ~/ 60).toString().padLeft(2, '0');
      String seconds = (durationInSeconds % 60).toString().padLeft(2, '0');

      return '$minutes:$seconds';
    }
  }

  static int convertMinutesToSeconds(
      {required int durationInMinutes, bool settings = false}) {
    return durationInMinutes * 60;
  }

  static Map<String, int> convertTaskTime({required int totalSeconds}) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    final convertedTime = {
      'hour': hours,
      'minutes': minutes,
      'totalSeconds': totalSeconds,
      'seconds': seconds,
    };

    return convertedTime;
  }

  static bool checkIfTaskPomodoroStartTime({required Pomodoro pomodoro}) {
    return pomodoro.task != null && !pomodoro.shortBreak && !pomodoro.longBreak;
  }
}
