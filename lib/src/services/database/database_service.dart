import 'package:sqflite/sqflite.dart';

import '../services.dart';

class DatabaseService {
  final InitDatabaseService _databaseService;

  DatabaseService(
    this._databaseService,
  );

  getPomodoro() async {
    Database db = await _databaseService.database;

    final pomodoro = await db.query('pomodoro');
    return pomodoro[0];
  }

  getSettings() async {
    Database db = await _databaseService.database;

    final settings = await db.query('settings');
    return settings[0];
  }

  getTaskById({required String taskId}) async {
    Database db = await _databaseService.database;

    final task = await db.query('task', where: 'id = ?', whereArgs: [taskId]);
    return task[0];
  }

  savePomodoroStatus({required Map<String, dynamic> pomodoroMap}) async {
    Database db = await _databaseService.database;
    await db.update('pomodoro', pomodoroMap);
  }
}
