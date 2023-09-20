import 'models.dart';

class Pomodoro {
  final int? remainingPomodoroTime;
  final String status;
  DateTime date;
  final int? totalFocusingTime;
  final int pomodoroSession;
  bool shortBreak;
  bool longBreak;
  final Settings settings;
  final Task? task;

  Pomodoro({
    required this.remainingPomodoroTime,
    required this.status,
    required this.date,
    required this.totalFocusingTime,
    required this.task,
    required this.pomodoroSession,
    required this.shortBreak,
    required this.longBreak,
    required this.settings,
  });
}
