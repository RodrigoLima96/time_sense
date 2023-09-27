import 'package:time_sense/src/models/task.dart';

import '../services/services.dart';

class TaskRepository {
  final DatabaseService _databaseService;
  TaskRepository(this._databaseService);

  getTasks() async {
    final tasksResult = await _databaseService.getTasks();
    print(tasksResult);
  }

  saveNewTask({required Task task}) async {
    await _databaseService.saveNewTask(taskMap: task.toMap());
  }
}
