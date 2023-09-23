import 'models.dart';

class Pomodoro {
  String status;
  int? remainingPomodoroTime;
  DateTime? date;
  final int? totalFocusingTime;
  int pomodoroSession;
  bool shortBreak;
  bool longBreak;
  String lastBreak;
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
    required this.lastBreak,
    required this.settings,
    required this.taskId,
  });
}
