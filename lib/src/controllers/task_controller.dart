import 'package:flutter/material.dart';
import 'package:time_sense/src/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';

class TaskController extends ChangeNotifier {
  String textFieldlHintText = "Criar tarefa...";
  final TaskRepository taskRepository;

  TaskController(this.taskRepository);

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

  changeTextFieldlHintText({required String text}) {
    textFieldlHintText = text;
    notifyListeners();
  }

  addNewTask({required String text}) async {
    if (text == "") {
      textFieldlHintText = 'Digite o nome da tarefa...';
      notifyListeners();
    } else {
      const uuid = Uuid();

      final Task newTask = Task(
        id: uuid.v1(),
        text: text,
        status: 'pending',
        totalFocusingTime: 0,
        creationDate: DateTime.now(),
        completionDate: null,
      );
      await taskRepository.saveNewTask(task: newTask);
      await taskRepository.getTasks();
    }
  }
}
