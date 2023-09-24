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

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'remainingPomodoroTime': remainingPomodoroTime,
      'date': date.toString(),
      'totalFocusingTime': totalFocusingTime,
      'task': task,
      'taskId': taskId,
      'pomodoroSession': pomodoroSession,
      'shortBreak': shortBreak ? 1 : 0,
      'lastBreak': lastBreak,
      'longBreak': longBreak ? 1 : 0,
      'settings': settings,
    };
  }

  factory Pomodoro.fromMap(Map<String, dynamic> map) {
    return Pomodoro(
      status: map['status'],
      remainingPomodoroTime: map['remainingPomodoroTime'],
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      totalFocusingTime: map['totalFocusingTime'],
      task: map['task'],
      taskId: map['taskId'],
      pomodoroSession: map['pomodoroSession'],
      shortBreak: map['shortBreak'] == 1,
      lastBreak: map['lastBreak'],
      longBreak: map['longBreak'] == 1,
      settings: map['settings'],
    );
  }
}
