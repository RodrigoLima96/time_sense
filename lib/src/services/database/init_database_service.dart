// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InitDatabaseService {
  InitDatabaseService._();

  static final InitDatabaseService instance = InitDatabaseService._();

  static Database? _dataBase;

  get database async {
    if (_dataBase != null) return _dataBase;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'time_sense.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_pomodoro);
    await db.execute(_settings);
    await db.execute(_tasks);

    await db.execute(_initialPomodoroData);
    await db.execute(_initialSettingsData);
  }

  String get _pomodoro => '''
    CREATE TABLE pomodoro (
      status TEXT,
      remainingPomodoroTime INTEGER,
      pomodoroSession INTEGER,
      shortBreak INTEGER,
      longBreak INTEGER,
      lastBreak TEXT,
      date TEXT,
      totalFocusingTime INTEGER,
      taskId TEXT
    );
  ''';

  String get _settings => '''
    CREATE TABLE settings (
      pomodoroTime INTEGER,
      shortBreakDuration INTEGER,
      longBreakDuration INTEGER,
      dailySessions INTEGER
    );
  ''';

  String get _tasks => '''
    CREATE TABLE tasks (
      id TEXT,
      text TEXT,
      status TEXT,
      totalFocusingTime INTEGER,
      creationDate creationDate,
      completionDate creationDate
    );
  ''';

String get _initialPomodoroData => '''
  INSERT INTO pomodoro (
    status,
    remainingPomodoroTime,
    pomodoroSession,
    shortBreak,
    longBreak,
    lastBreak,
    date,
    totalFocusingTime,
    taskId
  )
  VALUES (
    'focus',
    null,
    0,
    0,
    0,
    'longBreak',
    null,
    0,
    'null'
  );
''';

  String get _initialSettingsData => '''
  INSERT INTO settings (
    pomodoroTime, 
    shortBreakDuration, 
    longBreakDuration, 
    dailySessions
  )

  VALUES (
    120, 
    5, 
    8, 
    4
  );
''';
}
