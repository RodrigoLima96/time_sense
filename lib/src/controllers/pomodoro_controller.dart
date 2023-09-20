// ignore_for_file: non_constant_identifier_names

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:time_sense/src/models/models.dart';

enum PomodoroState { notStarted, paused, running }

class PomodoroController extends ChangeNotifier {
  final CountDownController countDownController = CountDownController();

  PomodoroState _state = PomodoroState.notStarted;
  PomodoroState get state => _state;

  List<String> pomodoroSessions = [];

  final Pomodoro pomodoro = Pomodoro(
    remainingPomodoroTime: null,
    status: PomodoroState.notStarted.name,
    pomodoroSession: 3,
    longBreak: false,
    shortBreak: false,
    date: DateTime.now(),
    totalFocusingTime: 1234,
    settings: Settings(
      pomodoroTime: 3600,
      shortBreakDuration: 5,
      longBreakDuration: 10,
      dailySessions: 4,
    ),
    task: null,
  );

  int getPomodoroDuration() {
    switch (pomodoro.remainingPomodoroTime != null) {
      case true:
        return pomodoro.remainingPomodoroTime!;
      case false:
        if (pomodoro.shortBreak) {
          return pomodoro.settings.shortBreakDuration;
        } else if (pomodoro.longBreak) {
          return pomodoro.settings.longBreakDuration;
        } else {
          return pomodoro.settings.pomodoroTime;
        }
    }
  }

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
    setPomodoroSessionsState();
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

  completeOrCancelPomodoro({required bool complete}) {
    countDownController.reset();
    _state = PomodoroState.notStarted;
    pomodoro.shortBreak = false;
    pomodoro.longBreak = false;
    complete ? setPomodoroSessionsState() : null;
    notifyListeners();
  }

  String convertSecondsToMinutes({required int pomodoroDuration}) {
    String minutes = (pomodoroDuration ~/ 60).toString().padLeft(2, '0');
    String seconds = (pomodoroDuration % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  setPomodoroSessionsState() {
    pomodoroSessions = [];
    final bool isBreak = pomodoro.shortBreak || pomodoro.longBreak;

    final int pomodoroAmount =
        pomodoro.pomodoroSession > pomodoro.settings.dailySessions
            ? pomodoro.pomodoroSession
            : pomodoro.settings.dailySessions;

    for (int index = 1; index <= pomodoroAmount; index++) {
      String sessionState;

      if (index <= pomodoro.pomodoroSession) {
        sessionState = 'complete';
      } else {
        if (_state == PomodoroState.running &&
            !pomodoroSessions.contains('running') &&
            !isBreak) {
          sessionState = 'running';
        } else {
          sessionState = 'incomplete';
        }
      }
      pomodoroSessions.add(sessionState);

      if (index == pomodoroAmount &&
          _state == PomodoroState.running &&
          !pomodoroSessions.contains('running') &&
          !isBreak) {
        pomodoroSessions.add('running');
      }
    }
    pomodoro.settings.dailySessions;
  }
}
