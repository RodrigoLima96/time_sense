import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import 'helpers/helpers.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

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
  Map<String, int>? taskFocusTime;

  PomodoroController(
    this._pomodoroRepository,
  ) {
    getPomodoroStatus();
    savePomodoroStatusPeriodic();
  }

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
    if (pomodoro.taskPomodoroStartTime == null && pomodoro.task != null) {
      pomodoro.taskPomodoroStartTime = pomodoro.remainingPomodoroTime;
    }
    notifyListeners();
  }

  pausePomodoro() async {
    countDownController.pause();
    pomodoroState = PomodoroState.paused;
    showSecondButton = true;
    await savePomodoroStatus(saveCurrentPomodoroTime: true);
    setPomodoroSessionsState();
    notifyListeners();
  }

  resumePomodoro() {
    countDownController.resume();
    pomodoroState = PomodoroState.running;
    showSecondButton = true;
    setPomodoroSessionsState();
    if (pomodoro.taskPomodoroStartTime == null && pomodoro.task != null) {
      pomodoro.taskPomodoroStartTime = pomodoro.remainingPomodoroTime;
    }
    notifyListeners();
  }

  restartPomodoro() {
    countDownController.restart(duration: pomodoro.settings!.pomodoroTime);
    pomodoroState = PomodoroState.running;
    showSecondButton = true;
    pomodoro.taskPomodoroStartTime = pomodoro.settings!.pomodoroTime;
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

    showSecondButton = false;
    pomodoroState = PomodoroState.notStarted;

    await savePomodoroStatus(saveCurrentPomodoroTime: false);
    await getPomodoroStatus();

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

  Future<void> getPomodoroStatus() async {
    pomodoroPageState = PomodoroPageState.loading;
    pomodoro = await _pomodoroRepository.getPomodoroStatus();
    pomodoro.remainingPomodoroTime =
        PomodoroHelper.getPomodoroTime(pomodoro: pomodoro);
    setPomodoroSessionsState();
    pomodoroPageState = PomodoroPageState.loaded;
    notifyListeners();
  }

  savePomodoroStatusPeriodic() async {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (pomodoroState == PomodoroState.running) {
        savePomodoroStatus(saveCurrentPomodoroTime: true);
      }
    });
  }

  savePomodoroStatus({required bool saveCurrentPomodoroTime}) async {
    saveCurrentPomodoroTime
        ? pomodoro.remainingPomodoroTime =
            PomodoroHelper.getRemainingPomodoroTime(
            remainingPomodoroTime: pomodoro.remainingPomodoroTime!,
            controllerRemainingPomodoroTime: countDownController.getTime(),
          )
        : pomodoro.remainingPomodoroTime = pomodoro.remainingPomodoroTime;

    await _pomodoroRepository.savePomodoroStatus(pomodoro: pomodoro);
  }

  setPomodoroTask({required String taskId}) async {
    final Task task = await _pomodoroRepository.getTaskById(taskId: taskId);
    pomodoro.taskId = task.id;
    pomodoro.task = task;
    await savePomodoroStatus(saveCurrentPomodoroTime: false);
    notifyListeners();
  }

  removeOrCompletePomodoroTask() async {
    pomodoro.taskPomodoroStartTime = null;
    pomodoro.taskId = null;
    pomodoro.task = null;

    if (pomodoroState == PomodoroState.running) {
      pausePomodoro();
    }
    await savePomodoroStatus(saveCurrentPomodoroTime: false);
    notifyListeners();
  }

  int getCurrentPomodoroTaskTime() {
    int currentPomodoroTaskTime = 0;

    if (pomodoro.taskPomodoroStartTime != null) {
      String? currentPomodoroTimme = countDownController.getTime();
      int? currentTaskFocusTime;

      if (currentPomodoroTimme == "00:00") {
        currentTaskFocusTime = pomodoro.remainingPomodoroTime!;
      } else {
        currentTaskFocusTime = PomodoroHelper.getRemainingPomodoroTime(
          remainingPomodoroTime: pomodoro.taskPomodoroStartTime!,
          controllerRemainingPomodoroTime: currentPomodoroTimme,
        );
      }
      currentPomodoroTaskTime +=
          pomodoro.taskPomodoroStartTime! - currentTaskFocusTime!;
      return currentPomodoroTaskTime;
    } else {
      return 0;
    }
  }

  showPomodoroTaskDetails() {
    if (pomodoro.task!.showDetails == false) {
      int totalTaskTime = pomodoro.task!.totalFocusingTime;
      totalTaskTime += getCurrentPomodoroTaskTime();

      taskFocusTime = Helper.convertTaskTime(seconds: totalTaskTime);
      pomodoro.task!.showDetails = true;
    } else {
      pomodoro.task!.showDetails = false;
    }
    notifyListeners();
  }

  updatePomodoroAfterSettingsChanges() async {
    pomodoro = await _pomodoroRepository.getPomodoroStatus();

    if (pomodoroState != PomodoroState.running &&
        pomodoroState != PomodoroState.paused) {
      pomodoro.remainingPomodoroTime =
          PomodoroHelper.getPomodoroTime(pomodoro: pomodoro);
    }
    setPomodoroSessionsState();
    notifyListeners();
  }
}
