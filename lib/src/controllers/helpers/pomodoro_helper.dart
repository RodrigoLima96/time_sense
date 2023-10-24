import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/models.dart';
import '../controllers.dart';

class PomodoroHelper {
  static int getPomodoroElapsedTime({required Pomodoro pomodoro}) {
    if (pomodoro.initDate != null) {
      DateTime currentDate = DateTime.now();
      int elapsedTime = currentDate.difference(pomodoro.initDate!).inSeconds;
      return elapsedTime;
    } else {
      return 0;
    }
  }

  static int getPomodoroTime({required Pomodoro pomodoro}) {
    if (pomodoro.shortBreak) {
      return pomodoro.settings!.shortBreakDuration;
    } else if (pomodoro.longBreak) {
      return pomodoro.settings!.longBreakDuration;
    } else {
      return pomodoro.settings!.pomodoroTime;
    }
  }

  static Map<String, Map<String, dynamic>> extractButtonsInfo({
    required PomodoroState pomodoroState,
    required Pomodoro pomodoro,
    required Function initPomodoro,
    required Function pausePomodoro,
    required Function restartPomodoro,
    required Function resumePomodoro,
    required Function cancelPomodoro,
  }) {
    switch (pomodoroState) {
      case PomodoroState.notStarted:
        return {
          'first_button': {
            'text': !pomodoro.shortBreak && !pomodoro.longBreak
                ? 'Começar Foco'
                : pomodoro.shortBreak
                    ? 'Começar pausa'
                    : 'Começar pausa longa',
            'function': () {
              initPomodoro();
            },
          }
        };
      case PomodoroState.running:
        return {
          'first_button': {
            'text': 'Pausar',
            'function': () {
              pausePomodoro();
            },
          },
          'second_button': {
            'text': !pomodoro.shortBreak && !pomodoro.longBreak
                ? 'Reiniciar'
                : 'Pular pausa',
            'function': () {
              !pomodoro.shortBreak && !pomodoro.longBreak
                  ? restartPomodoro()
                  : cancelPomodoro(isBreak: true);
            },
          }
        };
      case PomodoroState.paused:
        return {
          'first_button': {
            'text': 'Retomar',
            'function': () {
              resumePomodoro();
            },
          },
          'second_button': {
            'text': !pomodoro.shortBreak && !pomodoro.longBreak
                ? 'Cancelar'
                : 'Pular pausa',
            'function': () {
              cancelPomodoro(
                isBreak:
                    !pomodoro.shortBreak && !pomodoro.longBreak ? false : true,
              );
            },
          }
        };
      case PomodoroState.rebootpaused:
        return {
          'first_button': {
            'text': 'Retomar',
            'function': () {
              resumePomodoro();
            },
          },
          'second_button': {
            'text': pomodoro.shortBreak || pomodoro.longBreak
                ? 'Pular pausa'
                : 'Cancelar',
            'function': () {
              cancelPomodoro(
                  isBreak:
                      pomodoro.shortBreak || pomodoro.longBreak ? true : false);
            },
          }
        };
    }
  }

  static Pomodoro getCompletePomodoroStatus({required Pomodoro pomodoro}) {
    final resetPomodoro =
        checkResetDailyPomodoroCycle(creationDate: pomodoro.creationDate!);

    pomodoro.creationDate =
        resetPomodoro ? pomodoro.creationDate : DateTime.now();

    pomodoro.elapsedPomodoroTime = 0;
    pomodoro.initDate = null;
    pomodoro.taskPomodoroStartTime = null;
    pomodoro.elapsedTaskTime = null;
    pomodoro.status = PomodoroState.notStarted.name;

    if (!pomodoro.shortBreak && !pomodoro.longBreak) {
      pomodoro.pomodoroSession++;

      if (pomodoro.shortBreakCount < pomodoro.settings!.shortBreakCount) {
        pomodoro.shortBreakCount++;
        pomodoro.shortBreak = true;
      } else {
        pomodoro.shortBreakCount = pomodoro.settings!.shortBreakCount;
        pomodoro.longBreak = true;
      }
    } else if (pomodoro.shortBreak) {
      pomodoro.shortBreak = false;
    } else {
      pomodoro.longBreak = false;
      pomodoro.shortBreakCount = 1;
    }
    pomodoro.remainingPomodoroTime = 0;
    return pomodoro;
  }

  static Pomodoro getCancelPomodoroStatus(
      {required Pomodoro pomodoro, required bool isBreak}) {
    pomodoro.pomodoroTime = pomodoro.settings!.pomodoroTime;
    pomodoro.initDate = null;
    pomodoro.elapsedPomodoroTime = 0;
    pomodoro.taskPomodoroStartTime = null;
    pomodoro.elapsedTaskTime = null;
    pomodoro.status = PomodoroState.notStarted.name;

    if (isBreak) {
      if (pomodoro.shortBreak) {
        pomodoro.shortBreak = false;
      } else {
        pomodoro.longBreak = false;
        pomodoro.shortBreakCount = 1;
      }
    }
    return pomodoro;
  }

  static List<String> getPomodoroSessionsState({
    required Pomodoro pomodoro,
    required PomodoroState pomodoroState,
    required List<String> pomodoroSessions,
  }) {
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
    return pomodoroSessions;
  }

  static int getElapsedPomodoroTime({
    required int pomodoroTime,
    required String? remainingPomodoroTime,
  }) {
    int elapsedTime;

    if (remainingPomodoroTime == "00:00") {
      return 0;
    }
    List<String> timeParts = remainingPomodoroTime!.split(':');

    if (timeParts.length == 2) {
      int minutes = int.parse(timeParts[0]);
      int seconds = int.parse(timeParts[1]);

      int remainingPomodoroTime = minutes * 60 + seconds;
      elapsedTime = pomodoroTime - remainingPomodoroTime;
      if (elapsedTime < 0) {
        elapsedTime = 0;
      }
    } else {
      elapsedTime = 0;
    }

    return elapsedTime;
  }

  static Pomodoro getResetDailyPomodoroStatus({required Pomodoro pomodoro}) {
    const uuid = Uuid();
    pomodoro.creationDate = DateTime.now();
    pomodoro.initDate = null;
    pomodoro.completeDate = null;
    pomodoro.elapsedPomodoroTime = 0;
    pomodoro.id = uuid.v1();
    pomodoro.shortBreak = false;
    pomodoro.longBreak = false;
    pomodoro.remainingPomodoroTime = 0;
    pomodoro.status = PomodoroState.notStarted.name;
    pomodoro.taskPomodoroStartTime = null;
    pomodoro.pomodoroTime = pomodoro.settings!.pomodoroTime;
    pomodoro.shortBreakCount = 1;
    pomodoro.pomodoroSession = 0;
    return pomodoro;
  }

  static bool checkResetDailyPomodoroCycle({required DateTime creationDate}) {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final currentDate = dateFormat.format(now);
    final inputDate = dateFormat.format(creationDate);

    return currentDate != inputDate;
  }

  static NotificationModel getPomodoroNotification(
      {required Pomodoro pomodoro}) {
    final String title = !pomodoro.shortBreak && !pomodoro.longBreak
        ? 'Pomodoro concluído!'
        : 'Pausa concluída!';

    final bool sessionCompleted =
        pomodoro.pomodoroSession + 1 == pomodoro.settings!.dailySessions;

    final String body = !pomodoro.shortBreak && !pomodoro.longBreak
        ? !sessionCompleted
            ? 'Ótimo trabalho! faça uma pausa'
            : 'Parabéns! você concluiu sua meta diária!'
        : 'Hora de voltar ao trabalho!';

    return NotificationModel(id: 1, title: title, body: body);
  }

  static int getElapsedTaskTime({
    required int pomodoroTime,
    required int taskPomodoroStartTime,
    required String? remainingPomodoroTime,
  }) {
    int elapsedTaskTime = 0;

    if (remainingPomodoroTime != null && remainingPomodoroTime.isNotEmpty) {
      final List<String> timeParts = remainingPomodoroTime.split(':');
      if (timeParts.length == 2) {
        final int minutesRemaining = int.parse(timeParts[0]);
        final int secondsRemaining = int.parse(timeParts[1]);

        int remainingTimeInSeconds = (minutesRemaining * 60) + secondsRemaining;

        elapsedTaskTime = pomodoroTime - remainingTimeInSeconds;

        elapsedTaskTime -= taskPomodoroStartTime;
      }
    }

    return elapsedTaskTime;
  }
}
