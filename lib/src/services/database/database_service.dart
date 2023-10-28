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

    final task = await db.query('tasks', where: 'id = ?', whereArgs: [taskId]);
    return task[0];
  }

  savePomodoroStatus({required Map<String, dynamic> pomodoroMap}) async {
    Database db = await _databaseService.database;
    await db.update('pomodoro', pomodoroMap);
  }

  getStatistic({required String date}) async {
    Database db = await _databaseService.database;

    final statistic = await db.query(
      'statistics',
      where: 'date = ?',
      whereArgs: [date],
    );

    return statistic;
  }

  createStatistic({required Map<String, dynamic> statisticMap}) async {
    Database db = await _databaseService.database;
    await db.insert('statistics', statisticMap);
  }

  updateStatistic({required Map<String, dynamic> statisticMap}) async {
    Database db = await _databaseService.database;
    await db.update(
      'statistics',
      statisticMap,
      where: 'date = ?',
      whereArgs: [statisticMap['date']],
    );
  }

  saveSettings({required Map<String, dynamic> settingsMap}) async {
    Database db = await _databaseService.database;
    await db.update('settings', settingsMap);
  }

  getTasks({required int tasksStatus}) async {
    Database db = await _databaseService.database;
    final tasks = await db.query(
      'tasks',
      where: 'pending = ?',
      whereArgs: [tasksStatus],
    );
    return tasks;
  }

  saveNewTask({required Map<String, dynamic> taskMap}) async {
    Database db = await _databaseService.database;
    await db.insert('tasks', taskMap);
  }

  updateTask({required Map<String, dynamic> taskMap}) async {
    Database db = await _databaseService.database;
    await db.update(
      'tasks',
      taskMap,
      where: 'id = ?',
      whereArgs: [taskMap['id']],
    );
  }

  deleteTask({required String taskId}) async {
    Database db = await _databaseService.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  getUser() async {
    Database db = await _databaseService.database;
    final user = await db.query('user');
    return user[0];
  }

  updateUser({required Map<String, dynamic> user}) async {
    Database db = await _databaseService.database;
    await db.update('user', user);
  }
}
