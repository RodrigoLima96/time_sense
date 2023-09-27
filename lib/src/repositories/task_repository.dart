import 'package:time_sense/src/models/task.dart';

import '../services/services.dart';

class TaskRepository {
  final DatabaseService _databaseService;
  TaskRepository(this._databaseService);

  Future<List<Task>> getTasks({required String tasksStatus}) async {
    List<Task> tasksList = [];
    final tasksResult =
        await _databaseService.getTasks(tasksStatus: tasksStatus);
    for (var taskResult in tasksResult) {
      tasksList.add(Task.fromMap(taskResult));
    }
    return tasksList;
  }

  Future<void> saveNewTask({required Task task}) async {
    await _databaseService.saveNewTask(taskMap: task.toMap());
  }
}
