import '../models/models.dart';
import '../services/services.dart';

class PomodoroRepository {
  final DatabaseService _databaseService;

  PomodoroRepository(this._databaseService);

  Future<Pomodoro> getPomodoroStatus() async {
    final pomodoroResult = await _databaseService.getPomodoro();
    Pomodoro pomodoro = Pomodoro.fromMap(pomodoroResult);

    final settingsResult = await _databaseService.getSettings();
    final Settings settings = Settings.fromMap(settingsResult);

    pomodoro.settings = settings;

    if (pomodoro.task != null) {
      final taskResult =
          await _databaseService.getTaskById(taskId: pomodoro.taskId!);
      final Task task = Task.fromMap(taskResult);

      pomodoro.task = task;
    }

    return pomodoro;
  }

  Future<void> savePomodoroStatus({required Pomodoro pomodoro}) async {
    Map<String, dynamic> pomodoroMap = pomodoro.toMap();
    pomodoroMap.remove('task');
    pomodoroMap.remove('settings');
    await _databaseService.savePomodoroStatus(pomodoroMap: pomodoroMap);
  }
}
