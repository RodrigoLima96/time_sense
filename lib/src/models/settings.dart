// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  int pomodoroTime;
  int shortBreakDuration;
  int longBreakDuration;
  int shortBreakCount;
  int dailySessions;

  Settings({
    required this.pomodoroTime,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.shortBreakCount,
    required this.dailySessions,
  });

  Map<String, dynamic> toMap() {
    return {
      'pomodoroTime': pomodoroTime,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'shortBreakCount': shortBreakCount,
      'dailySessions': dailySessions
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      pomodoroTime: map['pomodoroTime'],
      shortBreakDuration: map['shortBreakDuration'],
      longBreakDuration: map['longBreakDuration'],
      shortBreakCount: map['shortBreakCount'],
      dailySessions: map['dailySessions'],
    );
  }

  @override
  List<Object?> get props =>
      [pomodoroTime, shortBreakDuration, longBreakDuration, shortBreakCount, dailySessions];
}
