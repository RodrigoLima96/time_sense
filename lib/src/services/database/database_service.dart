import 'package:sqflite/sqflite.dart';

import '../../models/models.dart';
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

  savePomodoroStatus({required Pomodoro pomodoro}) async {
    Database db = await _databaseService.database;
    print(pomodoro);

    await db.update('pomodoro', {
      'pomodoroSession': pomodoro.pomodoroSession,
      'shortBreak': pomodoro.shortBreak ? 1 : 0,
      'longBreak': pomodoro.longBreak ? 1 : 0,
      'status': pomodoro.status
    });
  }
}
