import '../models/models.dart';
import '../services/services.dart';

class PomodoroRepository {
  final DatabaseService _databaseService;

  PomodoroRepository(this._databaseService);

  Future<Pomodoro> getPomodoroStatus() async {
    final pomodoroResult = await _databaseService.getPomodoro();

    Pomodoro pomodoro = Pomodoro(
      status: pomodoroResult['status'],
      remainingPomodoroTime: pomodoroResult['remainingPomodoroTime'],
      date: DateTime.parse(pomodoroResult['date']),
      totalFocusingTime: pomodoroResult['totalFocusingTime'],
      task: null,
      taskId: pomodoroResult['taskId'],
      pomodoroSession: pomodoroResult['pomodoroSession'],
      shortBreak: pomodoroResult['shortBreak'] == 1,
      lastBreak: pomodoroResult['lastBreak'],
      longBreak: pomodoroResult['longBreak'] == 1,
      settings: null,
    );

    final settingsResult = await _databaseService.getSettings();

    final Settings settings = Settings(
      pomodoroTime: settingsResult['pomodoroTime'],
      shortBreakDuration: settingsResult['shortBreakDuration'],
      longBreakDuration: settingsResult['longBreakDuration'],
      dailySessions: settingsResult['dailySessions'],
    );

    pomodoro.settings = settings;

    if (pomodoro.task != null) {
      final taskResult =
          await _databaseService.getTaskById(taskId: pomodoro.taskId!);

      final Task task = Task(
        id: taskResult['id'],
        text: taskResult['text'],
        status: taskResult['status'],
        totalFocusingTime: taskResult['totalFocusingTime'],
        creationDate: taskResult['creationDate'],
        completionDate: taskResult['completionDate'],
      );

      pomodoro.task = task;
    }

    return pomodoro;
  }

  Future<void> savePomodoroStatus({required Pomodoro pomodoro}) async {
    await _databaseService.savePomodoroStatus(pomodoro: pomodoro);
  }
}
