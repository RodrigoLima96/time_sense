import 'models.dart';

class Pomodoro {
  final String status;
  int? remainingPomodoroTime;
  DateTime date;
  final int? totalFocusingTime;
  final int pomodoroSession;
  bool shortBreak;
  bool longBreak;
  Settings? settings;
  String? taskId;
  Task? task;

  Pomodoro({
    required this.status,
    required this.remainingPomodoroTime,
    required this.date,
    required this.totalFocusingTime,
    required this.task,
    required this.pomodoroSession,
    required this.shortBreak,
    required this.longBreak,
    required this.settings,
    required this.taskId,
  });
}
