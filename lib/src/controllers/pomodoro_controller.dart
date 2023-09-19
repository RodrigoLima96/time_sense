// ignore_for_file: non_constant_identifier_names

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:time_sense/src/models/pomodoro.dart';

enum PomodoroState { notStarted, paused, running }

class PomodoroController extends ChangeNotifier {
  final CountDownController countDownController = CountDownController();

  final Pomodoro pomodoro = Pomodoro(
    pomodoroTime: 3600,
    remainingPomodoroTime: null,
    status: PomodoroState.notStarted.name,
    dailySessions: 4,
    pomodoroSession: 3,
    longBreak: false,
    shortBreak: false,
    shortBreakDuration: 5,
    longBreakDuration: 10,
    date: DateTime.now(),
    totalFocusingTime: 1234,
    task: null,
  );

  int getPomodoroDuration() {
    if (pomodoro.remainingPomodoroTime != null) {
      return pomodoro.remainingPomodoroTime!;
    } else if (pomodoro.shortBreak) {
      return pomodoro.shortBreakDuration;
    } else if (pomodoro.longBreak) {
      return pomodoro.longBreakDuration;
    } else {
      return pomodoro.pomodoroTime;
    }
  }

  PomodoroState _state = PomodoroState.notStarted;

  PomodoroState get state => _state;

  String get firstButtonText {
    switch (_state) {
      case PomodoroState.notStarted:
        if (pomodoro.shortBreak) {
          return 'Começar pausa';
        } else if (pomodoro.longBreak) {
          return 'Começar pausa longa';
        } else {
          return 'Começar foco';
        }
      case PomodoroState.paused:
        return 'Retomar';
      case PomodoroState.running:
        return 'Pausar';
    }
  }

  String get secondButtonText {
    if (pomodoro.shortBreak || pomodoro.longBreak) {
      return 'Pular';
    }
    if (_state == PomodoroState.paused) {
      return 'Cancelar';
    } else {
      return 'Reiniciar';
    }
  }

  initPomodoro() {
    countDownController.start();
    _state = PomodoroState.running;
    notifyListeners();
  }

  pausePomodoro() {
    countDownController.pause();
    _state = PomodoroState.paused;
    notifyListeners();
  }

  resumePomodoro() {
    countDownController.resume();
    _state = PomodoroState.running;
    notifyListeners();
  }

  cancelPomodoro() {
    countDownController.reset();
    _state = PomodoroState.notStarted;
    pomodoro.shortBreak = false;
    pomodoro.longBreak = false;
    notifyListeners();
  }

  String convertSecondsToMinutes({required int pomodoroDuration}) {
    String minutes = (pomodoroDuration ~/ 60).toString().padLeft(2, '0');
    String seconds = (pomodoroDuration % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }
}
