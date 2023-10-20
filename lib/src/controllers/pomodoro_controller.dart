import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/src/services/services.dart';
import 'helpers/helpers.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

enum PomodoroState { notStarted, running, paused, rebootpaused }

enum PomodoroPageState { loading, loaded }

class PomodoroController extends ChangeNotifier {
  CountDownController countDownController = CountDownController();
  final PomodoroRepository _pomodoroRepository;
  final NotificationService _notificationService;

  late Pomodoro pomodoro;
  int elapsedPomodoroTime = 0;
  bool showSecondButton = false;
  bool showMenuButton = false;
  final dateFormat = DateFormat('dd/MM/yyyy');

  PomodoroState pomodoroState = PomodoroState.notStarted;
  PomodoroPageState pomodoroPageState = PomodoroPageState.loading;
  List<String> pomodoroSessions = [];
  Map<String, int>? taskFocusTime;
  String remainingPomodoroTimeInMinutes = '';

  PomodoroController(
    this._pomodoroRepository,
    this._notificationService,
  ) {
    getPomodoroStatus();
  }

  Future<void> getPomodoroStatus() async {
    pomodoroPageState = PomodoroPageState.loading;
    pomodoro = await _pomodoroRepository.getPomodoro();

    pomodoro.pomodoroTime = PomodoroHelper.getPomodoroTime(pomodoro: pomodoro);

    if (pomodoro.status == PomodoroState.running.name) {
      elapsedPomodoroTime =
          PomodoroHelper.getPomodoroElapsedTime(pomodoro: pomodoro);
    }

    remainingPomodoroTimeInMinutes =
        convertSecondsToMinutes(pomodoroDuration: pomodoro.pomodoroTime);

    elapsedPomodoroTime += pomodoro.elapsedPomodoroTime;

    if (elapsedPomodoroTime >= pomodoro.pomodoroTime) {
      completePomodoro();
    } else {
      setPomodoroStatus(pomodoroStatus: pomodoro.status);
      setPomodoroSessionsState();
      pomodoroPageState = PomodoroPageState.loaded;
      notifyListeners();
    }
  }

  setPomodoroStatus({required String pomodoroStatus}) async {
    switch (pomodoro.status) {
      case 'running':
        countDownController.start();
        pomodoroState = PomodoroState.running;
        showSecondButton = true;

      case 'paused':
        pomodoroState = PomodoroState.rebootpaused;
        int remainingTime =
            pomodoro.pomodoroTime - pomodoro.elapsedPomodoroTime;
        remainingPomodoroTimeInMinutes =
            convertSecondsToMinutes(pomodoroDuration: remainingTime);
        showSecondButton = true;
        await resetDailyPomodoroCycle();
      case 'notStarted':
        showMenuButton = true;
        await resetDailyPomodoroCycle();
        break;
      default:
    }
  }

  initPomodoro() async {
    final resetPomodoro = PomodoroHelper.checkResetDailyPomodoroCycle(
        creationDate: pomodoro.creationDate!);
    if (resetPomodoro && (pomodoro.shortBreak || pomodoro.longBreak)) {
      await resetDailyPomodoroCycle();
    } else {
      await resetDailyPomodoroCycle();

      await scheduledOrCancelNotification(duration: pomodoro.pomodoroTime);

      pomodoro.initDate = DateTime.now();
      countDownController.restart(duration: pomodoro.pomodoroTime);
      pomodoroState = PomodoroState.running;
      pomodoro.status = PomodoroState.running.name;
      showSecondButton = true;
      showMenuButton = false;

      await savePomodoroStatus();
      // Helper.checkIfTaskPomodoroStartTime(pomodoro: pomodoro)
      //     ? pomodoro.taskPomodoroStartTime = pomodoro.remainingPomodoroTime
      //     : null;
    }
    setPomodoroSessionsState();
    notifyListeners();
  }

  pausePomodoro() async {
    countDownController.pause();
    await scheduledOrCancelNotification(duration: null);
    pomodoroState = PomodoroState.paused;
    pomodoro.status = PomodoroState.paused.name;
    showSecondButton = true;

    elapsedPomodoroTime = 0;
    elapsedPomodoroTime = PomodoroHelper.getElapsedPomodoroTime(
      pomodoroTime: pomodoro.pomodoroTime,
      remainingPomodoroTime: countDownController.getTime(),
    );

    pomodoro.elapsedPomodoroTime = elapsedPomodoroTime;
    pomodoro.initDate = null;
    await savePomodoroStatus();
    setPomodoroSessionsState();
    notifyListeners();
  }

  resumePomodoro() async {
    if (pomodoroState == PomodoroState.rebootpaused) {
      countDownController.start();
    } else {
      countDownController.resume();
    }
    pomodoro.initDate = DateTime.now();
    int remainingTime = pomodoro.pomodoroTime - pomodoro.elapsedPomodoroTime;
    await scheduledOrCancelNotification(duration: remainingTime);

    pomodoroState = PomodoroState.running;
    pomodoro.status = PomodoroState.running.name;
    elapsedPomodoroTime = pomodoro.elapsedPomodoroTime;
    showSecondButton = true;
    setPomodoroSessionsState();
    // Helper.checkIfTaskPomodoroStartTime(pomodoro: pomodoro)
    //     ? pomodoro.taskPomodoroStartTime = pomodoro.remainingPomodoroTime
    //     : null;

    await savePomodoroStatus();
    notifyListeners();
  }

  restartPomodoro() async {
    await resetDailyPomodoroCycle();
    pomodoro.initDate = DateTime.now();
    await scheduledOrCancelNotification(
        duration: pomodoro.settings!.pomodoroTime);
    elapsedPomodoroTime = 0;
    pomodoro.elapsedPomodoroTime = 0;
    countDownController.restart(duration: pomodoro.settings!.pomodoroTime);
    pomodoroState = PomodoroState.running;
    pomodoro.shortBreak = false;
    showSecondButton = true;
    if (pomodoro.task != null) {
      pomodoro.taskPomodoroStartTime = pomodoro.settings!.pomodoroTime;
    }
    setPomodoroSessionsState();
    await savePomodoroStatus();
    notifyListeners();
  }

  cancelPomodoro({required bool isBreak}) async {
    countDownController.restart(duration: pomodoro.settings!.pomodoroTime);
    countDownController.pause();
    await scheduledOrCancelNotification(duration: null);
    pomodoro = PomodoroHelper.getCancelPomodoroStatus(
        pomodoro: pomodoro, isBreak: isBreak);
    elapsedPomodoroTime = 0;
    remainingPomodoroTimeInMinutes =
        convertSecondsToMinutes(pomodoroDuration: pomodoro.pomodoroTime);

    pomodoroState = PomodoroState.notStarted;
    showSecondButton = false;
    showMenuButton = true;

    await resetDailyPomodoroCycle();
    setPomodoroSessionsState();
    await savePomodoroStatus();
    notifyListeners();
  }

  completePomodoro() async {
    pomodoroPageState = PomodoroPageState.loading;

    if (!pomodoro.shortBreak && !pomodoro.longBreak) {
      final String formattedDate = dateFormat.format(pomodoro.creationDate!);

      await _pomodoroRepository.savePomodoroTime(
          date: formattedDate, totalFocusingTime: pomodoro.pomodoroTime);
    }
    pomodoro = PomodoroHelper.getCompletePomodoroStatus(pomodoro: pomodoro);
    pomodoro.pomodoroTime = PomodoroHelper.getPomodoroTime(pomodoro: pomodoro);

    remainingPomodoroTimeInMinutes =
        convertSecondsToMinutes(pomodoroDuration: pomodoro.pomodoroTime);
    elapsedPomodoroTime = 0;
    pomodoroState = PomodoroState.notStarted;
    showSecondButton = false;
    showMenuButton = true;

    await resetDailyPomodoroCycle();
    setPomodoroSessionsState();
    await savePomodoroStatus();

    pomodoroPageState = PomodoroPageState.loaded;
    notifyListeners();
  }

  setPomodoroSessionsState() {
    pomodoroSessions = PomodoroHelper.getPomodoroSessionsState(
      pomodoro: pomodoro,
      pomodoroState: pomodoroState,
      pomodoroSessions: pomodoroSessions,
    );
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

  resetDailyPomodoroCycle() async {
    final resetPomodoro = PomodoroHelper.checkResetDailyPomodoroCycle(
        creationDate: pomodoro.creationDate!);

    if (resetPomodoro) {
      if (!pomodoro.shortBreak &&
          !pomodoro.longBreak &&
          pomodoro.status == PomodoroState.paused.name) {
        final String formattedDate = dateFormat.format(pomodoro.creationDate!);

        await _pomodoroRepository.savePomodoroTime(
            date: formattedDate,
            totalFocusingTime: pomodoro.elapsedPomodoroTime);
      }
      pomodoro = PomodoroHelper.getResetDailyPomodoroStatus(pomodoro: pomodoro);
      elapsedPomodoroTime = 0;
      remainingPomodoroTimeInMinutes =
          convertSecondsToMinutes(pomodoroDuration: pomodoro.pomodoroTime);
      showSecondButton = false;
      showMenuButton = true;
      pomodoroState = PomodoroState.notStarted;
      await savePomodoroStatus();
    }
  }

  updatePomodoroAfterSettingsChanges() async {
    pomodoro = await _pomodoroRepository.getPomodoro();

    if (pomodoroState != PomodoroState.running &&
        pomodoroState != PomodoroState.paused) {
      pomodoro.taskPomodoroStartTime = null;
      pomodoro.pomodoroTime =
          PomodoroHelper.getPomodoroTime(pomodoro: pomodoro);
      remainingPomodoroTimeInMinutes =
          convertSecondsToMinutes(pomodoroDuration: pomodoro.pomodoroTime);

      countDownController.restart(duration: pomodoro.pomodoroTime);
      countDownController.pause();
    }

    setPomodoroSessionsState();
    await savePomodoroStatus();
    notifyListeners();
  }

  String convertSecondsToMinutes({required int pomodoroDuration}) {
    return Helper.convertSecondsToMinutes(durationInSeconds: pomodoroDuration);
  }

  savePomodoroStatus() async {
    await _pomodoroRepository.savePomodoroStatus(pomodoro: pomodoro);
  }

  setPomodoroTask({required String taskId}) async {
    final Task task = await _pomodoroRepository.getTaskById(taskId: taskId);
    pomodoro.taskId = task.id;
    pomodoro.task = task;
    await savePomodoroStatus();
    notifyListeners();
  }

  removePomodoroTask() async {
    pomodoro.taskPomodoroStartTime = null;
    pomodoro.taskId = null;
    pomodoro.task = null;

    if (pomodoroState == PomodoroState.running) {
      pausePomodoro();
    }
    await savePomodoroStatus();
    notifyListeners();
  }

  scheduledOrCancelNotification({required int? duration}) async {
    if (duration != null) {
      final NotificationModel notification =
          PomodoroHelper.getPomodoroNotification(pomodoro: pomodoro);

      await _notificationService.scheduledNotification(
        notification: notification,
        duration: Duration(seconds: duration),
      );
    } else {
      await _notificationService.cancelNotification();
    }
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
}
