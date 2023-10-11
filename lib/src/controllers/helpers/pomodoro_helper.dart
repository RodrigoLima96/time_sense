import '../../models/models.dart';
import '../controllers.dart';

class PomodoroHelper {
  static int getElapsedPomodoroTimeFromDate({required Pomodoro pomodoro}) {
    if (pomodoro.initDate != null) {
      DateTime currentDate = DateTime.now();
      int elapsedTime = currentDate.difference(pomodoro.initDate!).inSeconds;

      // if (pomodoro.remainingPomodoroTime != null) {
      // pomodoro.remainingPomodoroTime =
      //     pomodoro.remainingPomodoroTime! + elapsedTime;
      // } else {
      // pomodoro.remainingPomodoroTime = elapsedTime;
      // }
      print(elapsedTime);
      return elapsedTime;
    } else {
      return 0;
    }
    // int remainingPomodoroTime = DateTime(
    //   dataAtual.year,
    //   dataAtual.month,
    //   dataAtual.day,
    //   pomodoro.termino.hour,
    //   pomodoro.termino.minute,
    // ).difference(pomodoro.inicio).inSeconds;
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

  static int getPomodoroTime({required Pomodoro pomodoro}) {
    if (pomodoro.remainingPomodoroTime == 0) {
      return pomodoro.remainingPomodoroTime;
    } else if (pomodoro.shortBreak) {
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
        if (!pomodoro.shortBreak && !pomodoro.longBreak) {
          return {
            'first_button': {
              'text': 'Começar Foco',
              'function': () {
                initPomodoro();
              },
            }
          };
        } else if (pomodoro.shortBreak) {
          return {
            'first_button': {
              'text': 'Começar pausa',
              'function': () {
                initPomodoro();
              },
            }
          };
        } else {
          return {
            'first_button': {
              'text': 'Começar pausa longa',
              'function': () {
                initPomodoro();
              },
            }
          };
        }
      case PomodoroState.running:
        if (!pomodoro.shortBreak && !pomodoro.longBreak) {
          return {
            'first_button': {
              'text': 'Pausar',
              'function': () {
                pausePomodoro();
              },
            },
            'second_button': {
              'text': 'Reiniciar',
              'function': () {
                restartPomodoro();
              },
            }
          };
        } else {
          return {
            'first_button': {
              'text': 'Pausar',
              'function': () {
                pausePomodoro();
              },
            },
            'second_button': {
              'text': 'Pular',
              'function': () {
                cancelPomodoro(isBreak: true);
              },
            }
          };
        }
      case PomodoroState.paused:
        if (!pomodoro.shortBreak && !pomodoro.longBreak) {
          return {
            'first_button': {
              'text': 'Retomar',
              'function': () {
                resumePomodoro();
              },
            },
            'second_button': {
              'text': 'Cancelar',
              'function': () {
                cancelPomodoro(isBreak: false);
              },
            }
          };
        } else {
          return {
            'first_button': {
              'text': 'Retomar',
              'function': () {
                resumePomodoro();
              },
            },
            'second_button': {
              'text': 'Pular',
              'function': () {
                cancelPomodoro(isBreak: true);
              },
            }
          };
        }
      case PomodoroState.pausedTest:
        return {
          'first_button': {
            'text': 'Retomar',
            'function': () {
              resumePomodoro();
            },
          },
          'second_button': {
            'text': 'Cancelar',
            'function': () {
              cancelPomodoro(isBreak: false);
            },
          }
        };
    }
  }

  static Pomodoro getCompletePomodoroStatus({required Pomodoro pomodoro}) {
    if (!pomodoro.shortBreak && !pomodoro.longBreak) {
      pomodoro.pomodoroSession++;
      pomodoro.creationDate = DateTime.now();

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
    pomodoro.remainingPomodoroTime = pomodoro.settings!.pomodoroTime;

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
    } else {
      elapsedTime = 0;
    }
    return elapsedTime;
  }
}
