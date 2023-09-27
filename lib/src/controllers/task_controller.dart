import 'package:flutter/material.dart';
import 'package:time_sense/src/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';

enum TaskskBottomSheetState { loading, loaded }

class TaskController extends ChangeNotifier {
  String textFieldlHintText = "Criar tarefa...";
  TaskskBottomSheetState taskskBottomSheetState =
      TaskskBottomSheetState.loading;

  final TaskRepository taskRepository;

  List<Task> pendingTaskList = [];
  List<Task> completeTaskList = [];

  TaskController(this.taskRepository) {
    getTasksByStatus(status: 'pending');
  }

  getTasksByStatus({required String status}) async {
    switch (status) {
      case 'pending':
        pendingTaskList = await taskRepository.getTasks(tasksStatus: 'pending');
      case 'complete':
        completeTaskList =
            await taskRepository.getTasks(tasksStatus: 'complete');
    }
    taskskBottomSheetState = TaskskBottomSheetState.loaded;
    notifyListeners();
  }

  changeTextFieldlHintText({required String text}) {
    textFieldlHintText = text;
    notifyListeners();
  }

  addNewTask({required String text}) async {
    if (text == "") {
      textFieldlHintText = 'Digite o nome da tarefa...';
      notifyListeners();
    } else {
      textFieldlHintText = "Criar tarefa...";

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
      pendingTaskList.add(newTask);
      notifyListeners();
    }
  }
}
