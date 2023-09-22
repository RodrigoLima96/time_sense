import '../../models/models.dart';
import '../controllers.dart';

class PomodoroHelper {
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
              'text': 'retomar',
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
    }
  }
}
