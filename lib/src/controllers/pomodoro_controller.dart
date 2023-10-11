import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'helpers/helpers.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

enum PomodoroState { notStarted, running, paused, pausedTest }

enum PomodoroPageState { loading, loaded }

class PomodoroController extends ChangeNotifier {
  CountDownController countDownController = CountDownController();
  final PomodoroRepository _pomodoroRepository;
  late Pomodoro pomodoro;
  int elapsedPomodoroTime = 0;

  PomodoroState pomodoroState = PomodoroState.notStarted;
  PomodoroPageState pomodoroPageState = PomodoroPageState.loading;
  List<String> pomodoroSessions = [];
  bool showSecondButton = false;
  Map<String, int>? taskFocusTime;
  bool appStarted = true;
  String remainingPomodoroTimeInMinutes = '';

  PomodoroController(
    this._pomodoroRepository,
  ) {
    getPomodoroStatus();
  }

  Future<void> getPomodoroStatus() async {
    pomodoroPageState = PomodoroPageState.loading;
    pomodoro = await _pomodoroRepository.getPomodoro();

    if (pomodoro.status == PomodoroState.running.name) {
      elapsedPomodoroTime =
          PomodoroHelper.getElapsedPomodoroTimeFromDate(pomodoro: pomodoro);
    }

    remainingPomodoroTimeInMinutes =
        convertSecondsToMinutes(pomodoroDuration: pomodoro.pomodoroTime);

    elapsedPomodoroTime += pomodoro.elapsedPomodoroTime;

    setPomodoroStatus(pomodoroStatus: pomodoro.status);
    setPomodoroSessionsState();
    pomodoroPageState = PomodoroPageState.loaded;
    appStarted = false;
    notifyListeners();
  }

  setPomodoroStatus({required String pomodoroStatus}) {
    switch (pomodoro.status) {
      case 'running':
        countDownController.start();
        pomodoroState = PomodoroState.running;
        showSecondButton = true;

      case 'paused':
        pomodoroState = PomodoroState.pausedTest;
        remainingPomodoroTimeInMinutes = convertSecondsToMinutes(
            pomodoroDuration:
                pomodoro.pomodoroTime - pomodoro.elapsedPomodoroTime);
        showSecondButton = true;
        break;
      default:
    }
  }

  initPomodoro() async {
    countDownController.start();
    pomodoroState = PomodoroState.running;
    showSecondButton = true;

    if (!appStarted) {
      pomodoro.initDate = pomodoro.initDate ?? DateTime.now();
      pomodoro.status = PomodoroState.running.name;

      setPomodoroSessionsState();
      await savePomodoroStatus(saveCurrentPomodoroTime: false);
      Helper.checkIfTaskPomodoroStartTime(pomodoro: pomodoro)
          ? pomodoro.taskPomodoroStartTime = pomodoro.remainingPomodoroTime
          : null;
      notifyListeners();
    }
  }

  pausePomodoro() async {
    if (appStarted) {
      pomodoroState = PomodoroState.pausedTest;
    }

    showSecondButton = true;

    if (!appStarted) {
      countDownController.pause();
      pomodoroState = PomodoroState.paused;
      pomodoro.status = PomodoroState.paused.name;

      elapsedPomodoroTime = 0;
      elapsedPomodoroTime = PomodoroHelper.getElapsedPomodoroTime(
        pomodoroTime: pomodoro.pomodoroTime,
        remainingPomodoroTime: countDownController.getTime(),
      );

      pomodoro.elapsedPomodoroTime = elapsedPomodoroTime;
      pomodoro.initDate = null;
      await savePomodoroStatus(saveCurrentPomodoroTime: true);
      setPomodoroSessionsState();
    }
    notifyListeners();
  }

  resumePomodoro() async {
    if (pomodoroState == PomodoroState.pausedTest) {
      countDownController.start();
    } else {
      countDownController.resume();
    }
    pomodoro.initDate = DateTime.now();
    pomodoroState = PomodoroState.running;
    pomodoro.status = PomodoroState.running.name;
    elapsedPomodoroTime = pomodoro.elapsedPomodoroTime;
    showSecondButton = true;
    setPomodoroSessionsState();
    Helper.checkIfTaskPomodoroStartTime(pomodoro: pomodoro)
        ? pomodoro.taskPomodoroStartTime = pomodoro.remainingPomodoroTime
        : null;

    await savePomodoroStatus(saveCurrentPomodoroTime: true);
    notifyListeners();
  }

  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //

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

  restartPomodoro() {
    countDownController.restart(duration: pomodoro.settings!.pomodoroTime);
    pomodoroState = PomodoroState.running;
    showSecondButton = true;
    if (pomodoro.task != null) {
      pomodoro.taskPomodoroStartTime = pomodoro.settings!.pomodoroTime;
    }
    pomodoro.initDate = DateTime.now();
    notifyListeners();
  }

  cancelPomodoro({required bool isBreak}) async {
    countDownController.restart(duration: pomodoro.settings!.pomodoroTime);
    countDownController.pause();

    pomodoro = PomodoroHelper.getCancelPomodoroStatus(
        pomodoro: pomodoro, isBreak: isBreak);
    pomodoro.taskPomodoroStartTime = null;
    await savePomodoroStatus(saveCurrentPomodoroTime: false);

    pomodoroState = PomodoroState.notStarted;
    showSecondButton = false;
    setPomodoroSessionsState();
    notifyListeners();
  }

  completePomodoro() async {
    pomodoroPageState = PomodoroPageState.loading;

    pomodoro = PomodoroHelper.getCompletePomodoroStatus(pomodoro: pomodoro);
    pomodoro.taskPomodoroStartTime = null;
    showSecondButton = false;
    pomodoroState = PomodoroState.notStarted;

    await savePomodoroStatus(saveCurrentPomodoroTime: false);
    await getPomodoroStatus2();

    pomodoroPageState = PomodoroPageState.loaded;
    notifyListeners();
  }

  String convertSecondsToMinutes({required int pomodoroDuration}) {
    return Helper.convertSecondsToMinutes(durationInSeconds: pomodoroDuration);
  }

  setPomodoroSessionsState() {
    pomodoroSessions = PomodoroHelper.getPomodoroSessionsState(
      pomodoro: pomodoro,
      pomodoroState: pomodoroState,
      pomodoroSessions: pomodoroSessions,
    );
  }

  Future<void> getPomodoroStatus2() async {
    pomodoroPageState = PomodoroPageState.loading;
    pomodoro = await _pomodoroRepository.getPomodoro();
    pomodoro.remainingPomodoroTime =
        PomodoroHelper.getPomodoroTime(pomodoro: pomodoro);
    setPomodoroSessionsState();
    pomodoroPageState = PomodoroPageState.loaded;
    notifyListeners();
  }

  // savePomodoroStatusPeriodic() async {
  //   Timer.periodic(const Duration(seconds: 30), (timer) {
  //     if (pomodoroState == PomodoroState.running) {
  //       savePomodoroStatus(saveCurrentPomodoroTime: true);
  //     }
  //   });
  // }

  savePomodoroStatus({required bool saveCurrentPomodoroTime}) async {
    // saveCurrentPomodoroTime
    //     ? pomodoro.remainingPomodoroTime =
    //         PomodoroHelper.getRemainingPomodoroTime(
    //         remainingPomodoroTime: pomodoro.remainingPomodoroTime,
    //         controllerRemainingPomodoroTime: countDownController.getTime(),
    //       )!
    //     : pomodoro.remainingPomodoroTime = pomodoro.remainingPomodoroTime;

    await _pomodoroRepository.savePomodoroStatus(pomodoro: pomodoro);
    print(pomodoro.elapsedPomodoroTime);
  }

  setPomodoroTask({required String taskId}) async {
    final Task task = await _pomodoroRepository.getTaskById(taskId: taskId);
    pomodoro.taskId = task.id;
    pomodoro.task = task;
    await savePomodoroStatus(saveCurrentPomodoroTime: false);
    notifyListeners();
  }

  removePomodoroTask() async {
    pomodoro.taskPomodoroStartTime = null;
    pomodoro.taskId = null;
    pomodoro.task = null;

    if (pomodoroState == PomodoroState.running) {
      pausePomodoro();
    }
    await savePomodoroStatus(saveCurrentPomodoroTime: false);
    notifyListeners();
  }

  int getCurrentPomodoroTaskTime({required bool pomodoroComplete}) {
    int currentPomodoroTaskTime = 0;

    if (pomodoro.taskPomodoroStartTime != null &&
        !pomodoro.shortBreak &&
        !pomodoro.longBreak) {
      String? currentPomodoroTime = countDownController.getTime();
      int? currentTaskFocusTime;

      if (currentPomodoroTime == "00:00") {
        currentTaskFocusTime = pomodoro.remainingPomodoroTime;
      } else {
        currentTaskFocusTime = PomodoroHelper.getElapsedPomodoroTime(
          pomodoroTime: pomodoro.taskPomodoroStartTime!,
          remainingPomodoroTime: currentPomodoroTime,
        );
      }
      if (pomodoroComplete) {
        currentPomodoroTaskTime = pomodoro.taskPomodoroStartTime!;
      } else {
        currentPomodoroTaskTime +=
            pomodoro.taskPomodoroStartTime! - currentTaskFocusTime;
      }

      return currentPomodoroTaskTime;
    } else {
      return 0;
    }
  }

  showPomodoroTaskDetails() {
    if (pomodoro.task!.showDetails == false) {
      int totalTaskTime = pomodoro.task!.totalFocusingTime;
      totalTaskTime += getCurrentPomodoroTaskTime(pomodoroComplete: false);

      taskFocusTime = Helper.convertTaskTime(totalSeconds: totalTaskTime);
      pomodoro.task!.showDetails = true;
    } else {
      pomodoro.task!.showDetails = false;
    }
    notifyListeners();
  }

  updatePomodoroAfterSettingsChanges() async {
    pomodoro = await _pomodoroRepository.getPomodoro();

    if (pomodoroState != PomodoroState.running &&
        pomodoroState != PomodoroState.paused) {
      pomodoro.taskPomodoroStartTime = null;
      pomodoro.remainingPomodoroTime = 0;
      pomodoro.remainingPomodoroTime =
          PomodoroHelper.getPomodoroTime(pomodoro: pomodoro);
    }
    setPomodoroSessionsState();

    await savePomodoroStatus(saveCurrentPomodoroTime: false);
    notifyListeners();
  }
}
