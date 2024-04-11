import '../models/models.dart';
import '../services/services.dart';

class PomodoroRepository {
  final DatabaseService _databaseService;

  PomodoroRepository(this._databaseService);

  Future<Pomodoro> getPomodoro() async {
    final pomodoroResult = await _databaseService.getPomodoro();
    Pomodoro pomodoro = Pomodoro.fromMap(pomodoroResult);

    final settingsResult = await _databaseService.getSettings();
    final Settings settings = Settings.fromMap(settingsResult);

    pomodoro.settings = settings;

    if (pomodoro.taskId != null) {
      final taskResult =
          await _databaseService.getTaskById(taskId: pomodoro.taskId!);
      final Task task = Task.fromMap(taskResult);
      task.showDetails = false;
      pomodoro.task = task;
    }
    return pomodoro;
  }

  Future<Task> getTaskById({required String taskId}) async {
    final taskResult = await _databaseService.getTaskById(taskId: taskId);
    final Task task = Task.fromMap(taskResult);
    task.showDetails = false;
    return task;
  }

  Future<void> savePomodoroStatus({required Pomodoro pomodoro}) async {
    Map<String, dynamic> pomodoroMap = pomodoro.toMap();
    pomodoroMap.remove('task');
    pomodoroMap.remove('settings');
    await _databaseService.savePomodoroStatus(pomodoroMap: pomodoroMap);
  }

  Future<void> savePomodoroTime({required Statistic statistic}) async {
    final statisticResult =
        await _databaseService.getStatistics(initDate: statistic.date);

    if (statisticResult.isEmpty) {
      _databaseService.createStatistic(statisticMap: statistic.toMap());
    } else {
      int currentTotalTime = statisticResult[0]['totalFocusingTime'];

      statistic.totalFocusingTime += currentTotalTime;
      _databaseService.updateStatistic(statisticMap: statistic.toMap());
    }
  }

  getLastCallTimeSaveFunction() async {
    final result = await _databaseService.getUser();
    if (result['lastCallTimeSaveFunction'] != null) {
      return DateTime.parse(result['lastCallTimeSaveFunction']);
    }
    return null;
  }

  setLastCallTimeSaveFunction({required String data}) async {
    await _databaseService.updateLastCallTimeSaveFunction(data: data);
  }
}
