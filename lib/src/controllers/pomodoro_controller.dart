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
  var countDownController = CountDownController();
  final PomodoroRepository _pomodoroRepository;
  final NotificationService _notificationService;

  late Pomodoro pomodoro;
  int elapsedPomodoroTime = 0;
  bool showSecondButton = false;
  bool showMenuButton = false;
  bool appHidden = false;
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
      await setPomodoroStatus(pomodoroStatus: pomodoro.status);
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

      await scheduledOrCancelNotification(duration: null);
      await scheduledOrCancelNotification(duration: pomodoro.pomodoroTime);

      pomodoro.initDate = DateTime.now();
      countDownController.restart(duration: pomodoro.pomodoroTime);

      Helper.checkIfTaskPomodoroStartTime(pomodoro: pomodoro)
          ? pomodoro.taskPomodoroStartTime = 0
          : null;

      pomodoroState = PomodoroState.running;
      pomodoro.status = PomodoroState.running.name;
      showSecondButton = true;
      showMenuButton = false;

      await savePomodoroStatus();
    }
    setPomodoroSessionsState();
    notifyListeners();
  }

  pausePomodoro() async {
    countDownController.pause();

    Helper.checkIfTaskPomodoroStartTime(pomodoro: pomodoro) &&
            pomodoro.taskPomodoroStartTime != null
        ? pomodoro.elapsedTaskTime =
            getCurrentPomodoroTaskTime()
        : null;

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

    Helper.checkIfTaskPomodoroStartTime(pomodoro: pomodoro) &&
            pomodoro.taskPomodoroStartTime == null
        ? pomodoro.taskPomodoroStartTime = pomodoro.elapsedPomodoroTime
        : null;

    await scheduledOrCancelNotification(duration: remainingTime);

    pomodoroState = PomodoroState.running;
    pomodoro.status = PomodoroState.running.name;
    elapsedPomodoroTime = pomodoro.elapsedPomodoroTime;
    showSecondButton = true;
    setPomodoroSessionsState();
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
    pomodoro.elapsedTaskTime = null;
    countDownController.restart(duration: pomodoro.settings!.pomodoroTime);
    pomodoroState = PomodoroState.running;
    pomodoro.shortBreak = false;
    showSecondButton = true;

    Helper.checkIfTaskPomodoroStartTime(pomodoro: pomodoro)
        ? pomodoro.taskPomodoroStartTime = 0
        : null;

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

  completePomodoro({int? elapsedTaskTime}) async {
    pomodoroPageState = PomodoroPageState.loading;

    if (!pomodoro.shortBreak && !pomodoro.longBreak) {
      final String formattedDate = dateFormat.format(pomodoro.creationDate!);

      await _pomodoroRepository.savePomodoroTime(
        statistic: Statistic(
          date: formattedDate,
          totalFocusingTime: pomodoro.pomodoroTime,
        ),
      );
    }
    pomodoro.task!.totalFocusingTime += elapsedTaskTime ?? 0;
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
          statistic: Statistic(
            date: formattedDate,
            totalFocusingTime: pomodoro.elapsedPomodoroTime,
          ),
        );
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
    pomodoro.elapsedTaskTime = null;
    pomodoro.taskId = null;
    pomodoro.task = null;

    if (pomodoroState == PomodoroState.running &&
        !pomodoro.shortBreak &&
        !pomodoro.longBreak) {
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

  showPomodoroTaskDetails() {
    if (pomodoro.task!.showDetails == false) {
      int totalTaskTime = pomodoro.task!.totalFocusingTime;
      totalTaskTime += getCurrentPomodoroTaskTime();

      taskFocusTime = Helper.convertTaskTime(totalSeconds: totalTaskTime);
      pomodoro.task!.showDetails = true;
    } else {
      pomodoro.task!.showDetails = false;
    }
    notifyListeners();
  }

  int getCurrentPomodoroTaskTime() {
    if (Helper.checkIfTaskPomodoroStartTime(pomodoro: pomodoro) &&
        pomodoro.status == PomodoroState.running.name) {
      String? currentPomodoroTime = countDownController.getTime();

      int currentTaskFocusTime = PomodoroHelper.getElapsedTaskTime(
        pomodoroTime: pomodoro.pomodoroTime,
        taskPomodoroStartTime: pomodoro.taskPomodoroStartTime!,
        remainingPomodoroTime: currentPomodoroTime,
      );

      return currentTaskFocusTime;
    } else if (Helper.checkIfTaskPomodoroStartTime(pomodoro: pomodoro) &&
        pomodoro.status == PomodoroState.paused.name) {
      return pomodoro.elapsedTaskTime ?? 0;
    } else {
      return 0;
    }
  }

  convertTaskTime({required int elapsedTaskTime}) {
    return taskFocusTime =
        Helper.convertTaskTime(totalSeconds: elapsedTaskTime);
  }
}
