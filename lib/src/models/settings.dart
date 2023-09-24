class Settings {
  final int pomodoroTime;
  final int shortBreakDuration;
  final int longBreakDuration;
  final int dailySessions;

  Settings({
    required this.pomodoroTime,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.dailySessions,
  });

  Map<String, dynamic> toMap() {
    return {
      'pomodoroTime': pomodoroTime,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'dailySessions': dailySessions,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      pomodoroTime: map['pomodoroTime'],
      shortBreakDuration: map['shortBreakDuration'],
      longBreakDuration: map['longBreakDuration'],
      dailySessions: map['dailySessions'],
    );
  }
}
