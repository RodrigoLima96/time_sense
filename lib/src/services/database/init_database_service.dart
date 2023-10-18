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
    await db.execute(_statistics);

    await db.execute(_initialPomodoroData);
    await db.execute(_initialSettingsData);
  }

  String get _pomodoro => '''
    CREATE TABLE pomodoro (
      id TEXT,
      status TEXT,
      pomodoroTime INTEGER,
      elapsedPomodoroTime INTEGER,
      remainingPomodoroTime INTEGER,
      pomodoroSession INTEGER,
      shortBreak INTEGER,
      longBreak INTEGER,
      shortBreakCount INTEGER,
      creationDate TEXT,
      initDate TEXT,
      completeDate TEXT,
      taskId TEXT,
      taskPomodoroStartTime INTEGER
    );
  ''';

  String get _settings => '''
    CREATE TABLE settings (
      pomodoroTime INTEGER,
      shortBreakDuration INTEGER,
      longBreakDuration INTEGER,
      shortBreakCount INTEGER,
      dailySessions INTEGER
    );
  ''';

  String get _tasks => '''
    CREATE TABLE tasks (
      id TEXT,
      text TEXT,
      pending INTEGER,
      totalFocusingTime INTEGER,
      creationDate TEXT,
      completionDate TEXT,
      showDetails INTEGER
    );
  ''';

  String get _statistics => '''
    CREATE TABLE statistics (
      date TEXT,
      totalFocusingTime INTEGER
    )
  ''';

  String get _initialPomodoroData => '''
  INSERT INTO pomodoro (
    id,
    status,
    pomodoroTime,
    elapsedPomodoroTime,
    remainingPomodoroTime,
    pomodoroSession,
    shortBreak,
    longBreak,
    shortBreakCount,
    creationDate,
    initDate,
    completeDate,
    taskId,
    taskPomodoroStartTime
  )

  VALUES (
    '1',
    'notStarted',
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    null,
    null,
    null,
    null,
    null
  );
''';

  String get _initialSettingsData => '''
  INSERT INTO settings (
    pomodoroTime,
    shortBreakDuration,
    longBreakDuration,
    shortBreakCount,
    dailySessions
  )

  VALUES (
    10,
    5,
    7,
    2,
    4
  );
''';
}
