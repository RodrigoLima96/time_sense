import 'package:time_sense/src/models/task.dart';

import '../services/services.dart';

class TaskRepository {
  final DatabaseService _databaseService;
  TaskRepository(this._databaseService);

  Future<List<Task>> getTasks({required String tasksStatus}) async {
    List<Task> tasksList = [];
    int status = tasksStatus == 'pending' ? 1 : 0;

    final tasksResult = await _databaseService.getTasks(tasksStatus: status);
    for (var taskResult in tasksResult) {
      tasksList.add(Task.fromMap(taskResult));
    }
    return tasksList;
  }

  Future<void> saveNewTask({required Task task}) async {
    await _databaseService.saveNewTask(taskMap: task.toMap());
  }

  Future<void> updateTask({required Task task}) async {
    await _databaseService.updateTask(taskMap: task.toMap());
  }

  Future<void> deleteTask({required String taskId}) async {
    await _databaseService.deleteTask(taskId: taskId);
  }
}
