import 'package:time_sense/src/models/task.dart';

import '../services/services.dart';

class TaskRepository {
  final DatabaseService _databaseService;
  TaskRepository(this._databaseService);

  saveNewTask({required Task task}) async {
    await _databaseService.saveNewTask(taskMap: task.toMap());
  }
}
