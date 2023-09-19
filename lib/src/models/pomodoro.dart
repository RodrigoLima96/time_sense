import 'models.dart';

class Pomodoro {
  final int pomodoroTime;
  final int? remainingPomodoroTime;
  final String status;
  DateTime date;
  final int? totalFocusingTime;
  final int dailySessions;
  final int pomodoroSession;
  bool shortBreak;
  bool longBreak;
  final int shortBreakDuration;
  final int longBreakDuration;
  final Task? task;

  Pomodoro({
    required this.pomodoroTime,
    required this.remainingPomodoroTime,
    required this.status,
    required this.date,
    required this.totalFocusingTime,
    required this.task,
    required this.dailySessions,
    required this.pomodoroSession,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.shortBreak,
    required this.longBreak,
  });
}
