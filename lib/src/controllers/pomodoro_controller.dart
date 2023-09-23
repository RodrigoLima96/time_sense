// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:time_sense/src/controllers/helpers/helpers.dart';
import 'package:time_sense/src/models/models.dart';
import 'package:time_sense/src/repositories/repositories.dart';

enum PomodoroState { notStarted, running, paused }

enum PomodoroPageState { loading, loaded }

class PomodoroController extends ChangeNotifier {
  CountDownController countDownController = CountDownController();
  final PomodoroRepository _pomodoroRepository;
  late Pomodoro pomodoro;

  PomodoroState pomodoroState = PomodoroState.notStarted;
  PomodoroPageState pomodoroPageState = PomodoroPageState.loading;
  List<String> pomodoroSessions = [];
  bool showSecondButton = false;

  PomodoroController(
    this._pomodoroRepository,
  ) {
    getPomodoroStatus();
    savePomodoroStatusPeriodic();
  }

  // gerencia os estados atuais dos botões
  Map<String, Map<String, dynamic>> getButtonsInfo() {
    final buttonsInfo = PomodoroHelper.extractButtonsInfo(
      pomodoroState: pomodoroState,
      pomodoro: pomodoro,
      initPomodoro: initPomodoro,
      pausePomodoro: pausePomodoro,
      resumePomodoro: resumePomodoro,
      restartPomodoro: restartPomodoro,
      cancelPomodoro: cancelPomodoro,
    );
    return buttonsInfo;
  }

  initPomodoro() {
    countDownController.restart(duration: pomodoro.remainingPomodoroTime);
    pomodoroState = PomodoroState.running;
    setPomodoroSessionsState();
    showSecondButton = true;
    notifyListeners();
  }

  pausePomodoro() {
    countDownController.pause();
    pomodoroState = PomodoroState.paused;
    showSecondButton = true;
    setPomodoroSessionsState();
    notifyListeners();
  }

  resumePomodoro() {
    countDownController.resume();
    pomodoroState = PomodoroState.running;
    showSecondButton = true;
    setPomodoroSessionsState();
    notifyListeners();
  }

  restartPomodoro() {
    countDownController.restart(duration: pomodoro.settings!.pomodoroTime);
    pomodoroState = PomodoroState.running;
    showSecondButton = true;
    notifyListeners();
  }

  cancelPomodoro({required bool isBreak}) async {
    countDownController.restart(duration: pomodoro.settings!.pomodoroTime);
    countDownController.pause();

    pomodoro.remainingPomodoroTime = pomodoro.settings!.pomodoroTime;

    if (isBreak) {
      if (pomodoro.shortBreak) {
        pomodoro.shortBreak = false;
        pomodoro.lastBreak = 'shortBreak';
      } else {
        pomodoro.longBreak = false;
        pomodoro.lastBreak = 'longBreak';
      }
      await savePomodoroStatus(periodic: false);
    }

    pomodoroState = PomodoroState.notStarted;
    showSecondButton = false;
    setPomodoroSessionsState();
    notifyListeners();
  }

  completePomodoro() async {
    pomodoroPageState = PomodoroPageState.loading;

    if (!pomodoro.shortBreak && !pomodoro.longBreak) {
      pomodoro.pomodoroSession++;
      pomodoro.date = DateTime.now();
      if (pomodoro.lastBreak == 'longBreak') {
        pomodoro.shortBreak = true;
      } else {
        pomodoro.longBreak = true;
      }
    } else if (pomodoro.shortBreak) {
      pomodoro.shortBreak = false;
      pomodoro.lastBreak = 'shortBreak';
    } else {
      pomodoro.longBreak = false;
      pomodoro.lastBreak = 'longBreak';
    }
    pomodoro.remainingPomodoroTime = null;
    showSecondButton = false;
    pomodoroState = PomodoroState.notStarted;

    await savePomodoroStatus(periodic: false);
    await getPomodoroStatus();
    setPomodoroSessionsState();

    pomodoroPageState = PomodoroPageState.loaded;
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
        if (pomodoroState == PomodoroState.running &&
            !pomodoroSessions.contains('running') &&
            !isBreak) {
          sessionState = 'running';
        } else {
          sessionState = 'incomplete';
        }
      }
      pomodoroSessions.add(sessionState);

      if (index == pomodoroAmount &&
          pomodoroState == PomodoroState.running &&
          !pomodoroSessions.contains('running') &&
          !isBreak) {
        pomodoroSessions.add('running');
      }
    }
    pomodoro.settings!.dailySessions;
  }

  Future<void> getPomodoroStatus() async {
    pomodoroPageState = PomodoroPageState.loading;
    pomodoro = await _pomodoroRepository.getPomodoroStatus();
    setPomodoroSessionsState();
    pomodoroPageState = PomodoroPageState.loaded;
    notifyListeners();
  }

  int? getRemainingPomodoroTime() {
    int remainingTime = pomodoro.remainingPomodoroTime!;
    var formattedTime = countDownController.getTime();

    if (formattedTime == "") {
      return null;
    }

    List<String> timeParts = formattedTime!.split(':');

    if (timeParts.length == 2) {
      int minutes = int.parse(timeParts[0]);
      int seconds = int.parse(timeParts[1]);

      remainingTime = minutes * 60 + seconds;
    } else {
      return null;
    }
    return remainingTime;
  }

  savePomodoroStatusPeriodic() async {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (pomodoroState != PomodoroState.notStarted) {
        savePomodoroStatus(periodic: true);
      }
    });
  }

  savePomodoroStatus({required bool periodic}) async {
    periodic
        ? pomodoro.remainingPomodoroTime = getRemainingPomodoroTime()
        : pomodoro.remainingPomodoroTime = pomodoro.remainingPomodoroTime;

    await _pomodoroRepository.savePomodoroStatus(pomodoro: pomodoro);
  }
}
