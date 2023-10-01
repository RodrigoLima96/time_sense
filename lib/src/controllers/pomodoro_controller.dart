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

    pomodoro = PomodoroHelper.getCancelPomodoroStatus(
        pomodoro: pomodoro, isBreak: isBreak);

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

  removePomodoroTask() async {
    pomodoro.taskId = null;
    pomodoro.task = null;
    await savePomodoroStatus(saveCurrentPomodoroTime: false);
    notifyListeners();
  }

  showPomodoroTaskDetails() {
    taskFocusTime = Helper.convertTaskTime(seconds: pomodoro.task!.totalFocusingTime);
    pomodoro.task!.showDetails = !pomodoro.task!.showDetails;
    notifyListeners();
  }

  updatePomodoroAfterSettingsChanges() async {
    pomodoro = await _pomodoroRepository.getPomodoroStatus();

    if (pomodoroState != PomodoroState.running &&
        pomodoroState != PomodoroState.paused) {
      pomodoro.remainingPomodoroTime = pomodoro.settings!.pomodoroTime;
      pomodoro.remainingPomodoroTime =
          PomodoroHelper.getPomodoroTime(pomodoro: pomodoro);
    }
    setPomodoroSessionsState();
    notifyListeners();
  }
}
