// ignore_for_file: non_constant_identifier_names

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:time_sense/src/controllers/helpers/helpers.dart';
import 'package:time_sense/src/models/models.dart';
import 'package:time_sense/src/repositories/repositories.dart';

enum PomodoroState { notStarted, running, paused }

enum PomodoroPageState { loading, loaded }

class PomodoroController extends ChangeNotifier {
  final CountDownController countDownController = CountDownController();
  final PomodoroRepository _pomodoroRepository;
  // late Pomodoro pomodoro;

  PomodoroState pomodoroState = PomodoroState.notStarted;
  PomodoroPageState pomodoroPageState = PomodoroPageState.loading;
  List<String> pomodoroSessions = [];
  bool showSecondButton = false;

  PomodoroController(
    this._pomodoroRepository,
  ) {
    getPomodoroStatus();
  }

  final Pomodoro pomodoro = Pomodoro(
    status: 'notStarted',
    remainingPomodoroTime: 10,
    date: DateTime.now(),
    totalFocusingTime: 3,
    task: null,
    pomodoroSession: 2,
    shortBreak: true,
    longBreak: false,
    lastBreak: 1,
    settings: Settings(
      pomodoroTime: 10,
      shortBreakDuration: 3,
      longBreakDuration: 5,
      dailySessions: 4,
    ),
    taskId: null,
  );

  // gerencia os estados atuais dos botões
  Map<String, Map<String, dynamic>> getButtonsInfo() {

    final buttonsInfo =
        PomodoroHelper.extractButtonsInfo(
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
    countDownController.start();
    pomodoroState = PomodoroState.running;
    showSecondButton = true;
    setPomodoroSessionsState();
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
    if (isBreak) {
      pomodoro.shortBreak = false;
      pomodoro.longBreak = false;
    }
    pomodoroState = PomodoroState.notStarted;
    showSecondButton = false;
    setPomodoroSessionsState();
    notifyListeners();
  }

  String convertSecondsToMinutes({required int pomodoroDuration}) {
    String minutes = (pomodoroDuration ~/ 60).toString().padLeft(2, '0');
    String seconds = (pomodoroDuration % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  // gerencia os estados atuais dos botões
  // String get firstButtonText {
  //   switch (pomodoroState) {
  //     case PomodoroState.notStarted:
  //       if (pomodoro.shortBreak) {
  //         return 'Começar pausa';
  //       } else if (pomodoro.longBreak) {
  //         return 'Começar pausa longa';
  //       } else {
  //         return 'Começar foco';
  //       }
  //     case PomodoroState.paused:
  //       return 'Retomar';
  //     case PomodoroState.running:
  //       return 'Pausar';
  //     default:
  //       return 'Começar foco';
  //   }
  // }

  // void changePomodoroStatus2({required secondButton}) {
  //   switch (countDownController) {
  //     case PomodoroState.notStarted:
  //       initPomodoro();
  //     case PomodoroState.paused:
  //       if (secondButton) {
  //         cancelPomodoro();
  //       } else {
  //         resumePomodoro();
  //       }
  //     case PomodoroState.running:
  //       if (secondButton && !pomodoro.shortBreak && !pomodoro.longBreak) {
  //         cancelPomodoro();
  //         initPomodoro();
  //       } else if (pomodoro.shortBreak || pomodoro.longBreak) {
  //         cancelPomodoro();
  //       } else if (secondButton!) {
  //         pausePomodoro();
  //       }
  //     default:
  //       initPomodoro();
  //   }
  // }

  // void changePomodoroStatus({required secondButton}) {
  // switch (_pomodoroState) {
  //   case PomodoroState.notStarted:
  //     initPomodoro();
  //   case PomodoroState.paused:
  //     if (secondButton) {
  //       cancelPomodoro();
  //     } else {
  //       resumePomodoro();
  //     }
  //   case PomodoroState.running:
  //     if (secondButton && !pomodoro.shortBreak && !pomodoro.longBreak) {
  //       cancelPomodoro();
  //       initPomodoro();
  //     } else if (pomodoro.shortBreak || pomodoro.longBreak) {
  //       cancelPomodoro();
  //     } else if (secondButton!) {
  //       pausePomodoro();
  //     }
  //   default:
  //     initPomodoro();
  // }

  //   if (countDownController.isPaused) {
  //     print(countDownController);
  //   }
  //   if (countDownController.isRestarted) {
  //     print(countDownController);
  //   }
  //   if (countDownController.isResumed) {
  //     print(countDownController);
  //   }
  //   if (countDownController.isStarted) {
  //     print(countDownController);
  //   }
  // }

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

  // completePomodoro() async {
  //   if (pomodoroState != PomodoroState.canceled) {
  //     if (pomodoro.status == 'focus') {
  //       if (pomodoro.lastBreak == 0 || pomodoro.lastBreak == 1) {
  //         pomodoro.shortBreak = true;
  //       } else {
  //         pomodoro.longBreak = true;
  //       }
  //     } else if (pomodoro.status == 'break') {
  //       if (pomodoro.lastBreak == 0 || pomodoro.lastBreak == 1) {
  //         pomodoro.lastBreak++;
  //         pomodoro.shortBreak = false;
  //         pomodoro.longBreak = false;
  //       } else {
  //         pomodoro.lastBreak = 0;
  //         pomodoro.shortBreak = false;
  //         pomodoro.longBreak = false;
  //       }
  //     }

  //     if (pomodoro.status != 'break') {
  //       pomodoro.pomodoroSession++;

  //       setPomodoroSessionsState();
  //       await savePomodoroStatus();
  //       pomodoroState = PomodoroState.notStarted;

  //       countDownController.reset();
  //       await getPomodoroStatus();

  //       pomodoro.status = 'break';
  //     } else {
  //       pomodoro.status = 'focus';
  //     }
  //     pomodoroState = PomodoroState.notStarted;
  //   }
  //   notifyListeners();
  // }

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
    // pomodoro = await _pomodoroRepository.getPomodoroStatus();
    // getPomodoroDuration();
    // setPomodoroSessionsState();
    pomodoroPageState = PomodoroPageState.loaded;
    notifyListeners();
  }

  // savePomodoroStatus() async {
  //   await _pomodoroRepository.savePomodoroStatus(pomodoro: pomodoro);
  // }
}
