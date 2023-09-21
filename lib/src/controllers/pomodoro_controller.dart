// ignore_for_file: non_constant_identifier_names

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:time_sense/src/models/models.dart';
import 'package:time_sense/src/repositories/repositories.dart';

enum PomodoroState { notStarted, paused, running, canceled }

enum PomodoroPageState { loading, loaded }

class PomodoroController extends ChangeNotifier {
  final CountDownController countDownController = CountDownController();
  final PomodoroRepository _pomodoroRepository;
  late Pomodoro pomodoro;

  PomodoroState _pomodoroState = PomodoroState.notStarted;
  PomodoroState get pomodoroState => _pomodoroState;

  PomodoroPageState pomodoroPageState = PomodoroPageState.loading;

  List<String> pomodoroSessions = [];

  PomodoroController(
    this._pomodoroRepository,
  ) {
    getPomodoroStatus();
  }

  getPomodoroDuration() {
    int pomodoroDuration;
    switch (pomodoro.remainingPomodoroTime != null) {
      case true:
        pomodoroDuration = pomodoro.remainingPomodoroTime!;
      case false:
        if (pomodoro.shortBreak) {
          pomodoroDuration = pomodoro.settings!.shortBreakDuration;
        } else if (pomodoro.longBreak) {
          pomodoroDuration = pomodoro.settings!.longBreakDuration;
        } else {
          pomodoroDuration = pomodoro.settings!.pomodoroTime;
        }
    }

    pomodoro.remainingPomodoroTime = pomodoroDuration;
    notifyListeners();
  }

  String get firstButtonText {
    switch (_pomodoroState) {
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
      case PomodoroState.canceled:
        return '';
    }
  }

  String get secondButtonText {
    if (pomodoro.shortBreak || pomodoro.longBreak) {
      return 'Pular';
    }
    if (_pomodoroState == PomodoroState.paused) {
      return 'Cancelar';
    } else {
      return 'Reiniciar';
    }
  }

  initPomodoro() {
    countDownController.start();
    _pomodoroState = PomodoroState.running;
    setPomodoroSessionsState();
    notifyListeners();
  }

  pausePomodoro() {
    countDownController.pause();
    _pomodoroState = PomodoroState.paused;
    notifyListeners();
  }

  resumePomodoro() {
    countDownController.resume();
    _pomodoroState = PomodoroState.running;
    notifyListeners();
  }

  completePomodoro() async {
    if (_pomodoroState != PomodoroState.canceled) {
      if (pomodoro.status == 'focus') {
        if (pomodoro.lastBreak == 0 || pomodoro.lastBreak == 1) {
          pomodoro.shortBreak = true;
        } else {
          pomodoro.longBreak = true;
        }
      } else if (pomodoro.status == 'break') {
        if (pomodoro.lastBreak == 0 || pomodoro.lastBreak == 1) {
          pomodoro.lastBreak++;
          pomodoro.shortBreak = false;
          pomodoro.longBreak = false;
        } else {
          pomodoro.lastBreak = 0;
          pomodoro.shortBreak = false;
          pomodoro.longBreak = false;
        }
      }

      if (pomodoro.status != 'break') {
        pomodoro.pomodoroSession++;

        setPomodoroSessionsState();
        await savePomodoroStatus();
        _pomodoroState = PomodoroState.notStarted;

        countDownController.reset();
        await getPomodoroStatus();

        pomodoro.status = 'break';
      } else {
        pomodoro.status = 'focus';
      }
      _pomodoroState = PomodoroState.notStarted;
    }
    notifyListeners();
  }

  cancelPomodoro() async {
    _pomodoroState = PomodoroState.canceled;
    countDownController.reset();
    await getPomodoroStatus();
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
        pomodoro.pomodoroSession > pomodoro.settings!.dailySessions
            ? pomodoro.pomodoroSession
            : pomodoro.settings!.dailySessions;

    for (int index = 1; index <= pomodoroAmount; index++) {
      String sessionState;

      if (index <= pomodoro.pomodoroSession) {
        sessionState = 'complete';
      } else {
        if (_pomodoroState == PomodoroState.running &&
            !pomodoroSessions.contains('running') &&
            !isBreak) {
          sessionState = 'running';
        } else {
          sessionState = 'incomplete';
        }
      }
      pomodoroSessions.add(sessionState);

      if (index == pomodoroAmount &&
          _pomodoroState == PomodoroState.running &&
          !pomodoroSessions.contains('running') &&
          !isBreak) {
        pomodoroSessions.add('running');
      }
    }
    pomodoro.settings!.dailySessions;
  }

  Future<void> getPomodoroStatus() async {
    pomodoro = await _pomodoroRepository.getPomodoroStatus();
    getPomodoroDuration();
    setPomodoroSessionsState();
    pomodoroPageState = PomodoroPageState.loaded;
    notifyListeners();
  }

  savePomodoroStatus() async {
    await _pomodoroRepository.savePomodoroStatus(pomodoro: pomodoro);
  }
}
