import 'models.dart';

class Pomodoro {
  String id;
  String status;
  int pomodoroTime;
  int elapsedPomodoroTime;
  int remainingPomodoroTime;
  DateTime? creationDate;
  DateTime? initDate;
  DateTime? completeDate;
  final int? totalFocusingTime;
  int pomodoroSession;
  bool shortBreak;
  bool longBreak;
  int shortBreakCount;
  Settings? settings;
  String? taskId;
  Task? task;
  int? taskPomodoroStartTime;

  Pomodoro({
    required this.id,
    required this.status,
    required this.pomodoroTime,
    required this.elapsedPomodoroTime,
    required this.remainingPomodoroTime,
    required this.creationDate,
    required this.initDate,
    required this.completeDate,
    required this.totalFocusingTime,
    required this.task,
    required this.pomodoroSession,
    required this.shortBreak,
    required this.longBreak,
    required this.shortBreakCount,
    required this.settings,
    required this.taskId,
    required this.taskPomodoroStartTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'pomodoroTime': pomodoroTime,
      'elapsedPomodoroTime': elapsedPomodoroTime,
      'remainingPomodoroTime': remainingPomodoroTime,
      'creationDate': creationDate?.toString(),
      'initDate': initDate?.toString(),
      'completeDate': completeDate?.toString(),
      'totalFocusingTime': totalFocusingTime,
      'task': task,
      'taskId': taskId,
      'pomodoroSession': pomodoroSession,
      'shortBreak': shortBreak ? 1 : 0,
      'shortBreakCount': shortBreakCount,
      'longBreak': longBreak ? 1 : 0,
      'settings': settings,
      'taskPomodoroStartTime': taskPomodoroStartTime,
    };
  }

  factory Pomodoro.fromMap(Map<String, dynamic> map) {
    return Pomodoro(
      id: map['id'],
      status: map['status'],
      pomodoroTime: map['pomodoroTime'],
      elapsedPomodoroTime: map['elapsedPomodoroTime'],
      remainingPomodoroTime: map['remainingPomodoroTime'],
      creationDate: map['creationDate'] != null
          ? DateTime.parse(map['creationDate'])
          : DateTime.now(),
      initDate:
          map['initDate'] != null ? DateTime.parse(map['initDate']) : null,
      completeDate: map['completeDate'] != null
          ? DateTime.parse(map['completeDate'])
          : null,
      totalFocusingTime: map['totalFocusingTime'],
      task: map['task'],
      taskId: map['taskId'],
      pomodoroSession: map['pomodoroSession'],
      shortBreak: map['shortBreak'] == 1,
      longBreak: map['longBreak'] == 1,
      shortBreakCount: map['shortBreakCount'],
      settings: map['settings'],
      taskPomodoroStartTime: map['taskPomodoroStartTime'],
    );
  }
}
