import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskController extends ChangeNotifier {
  List<Task> pendingTaskList = [
    Task(
      id: '1',
      text: 'Criar um site de compras',
      status: 'pending',
      totalFocusingTime: 2456,
      creationDate: DateTime.now(),
      completionDate: DateTime.now(),
    ),
    Task(
      id: '2',
      text: 'Estudar flutter',
      status: 'pending',
      totalFocusingTime: 1456,
      creationDate: DateTime.now(),
      completionDate: DateTime.now(),
    ),
    Task(
      id: '3',
      text: 'Desenvolver time sense app',
      status: 'pending',
      totalFocusingTime: 2316,
      creationDate: DateTime.now(),
      completionDate: DateTime.now(),
    ),
  ];
}
