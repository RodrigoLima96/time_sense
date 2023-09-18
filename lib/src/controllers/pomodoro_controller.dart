// ignore_for_file: non_constant_identifier_names

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

enum PomodoroState { notStarted, paused, running, breakTime }

class PomodoroController extends ChangeNotifier {
  final CountDownController countDownController = CountDownController();
  final int PomodoroDurationInSeconds = 10;
  final String PomodoroDurationInMinutes = '01:00';

  PomodoroState _state = PomodoroState.notStarted;

  PomodoroState get state => _state;

  String get buttonText {
    switch (_state) {
      case PomodoroState.notStarted:
        return 'Começar foco';
      case PomodoroState.paused:
        return 'Retomar';
      case PomodoroState.running:
        return 'Pausar';
      case PomodoroState.breakTime:
        return 'Começar pausa';
    }
  }

  initPomodoro({required bool breakTime}) {
    countDownController.start();
    _state = breakTime ? PomodoroState.breakTime : PomodoroState.running;
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
    notifyListeners();
  }

  setPomodoroBreak() {
    _state = PomodoroState.breakTime;
    notifyListeners();
  }
}
