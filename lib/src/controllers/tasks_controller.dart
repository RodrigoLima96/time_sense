import 'package:flutter/material.dart';
import 'package:time_sense/src/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';

enum TaskskBottomSheetState { loading, loaded }

enum TasksPageState { loading, loaded }

class TasksController extends ChangeNotifier {
  TaskskBottomSheetState taskskBottomSheetState =
      TaskskBottomSheetState.loading;
  TasksPageState tasksPageState = TasksPageState.loading;

  bool isPendingTasksPage = true;
  String pageTitleText = 'Tarefas pendentes';
  String textFieldlHintText = "Criar tarefa...";

  final TaskRepository taskRepository;

  List<Task> pendingTaskList = [];
  List<Task> completeTaskList = [];

  TasksController(this.taskRepository) {
    getTasksByStatus(status: 'pending');
  }

  getTasksByStatus({required String status}) async {
    switch (status) {
      case 'pending':
        pendingTaskList = await taskRepository.getTasks(tasksStatus: 'pending');
      case 'complete':
        if (completeTaskList.isEmpty) {
          completeTaskList =
              await taskRepository.getTasks(tasksStatus: 'complete');
        }
    }
    taskskBottomSheetState = TaskskBottomSheetState.loaded;
    tasksPageState = TasksPageState.loaded;
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
        pending: true,
        totalFocusingTime: 0,
        creationDate: DateTime.now(),
        completionDate: null,
        showDetails: false,
      );
      await taskRepository.saveNewTask(task: newTask);
      pendingTaskList.add(newTask);
      notifyListeners();
    }
  }

  changeIsPendingTasksPage() async {
    isPendingTasksPage = !isPendingTasksPage;
    if (!isPendingTasksPage) {
      pageTitleText = 'Tarefas concluídas';
      if (completeTaskList.isEmpty) {
        await getTasksByStatus(status: 'complete');
      }
    } else {
      pageTitleText = 'Tarefas pendentes';
    }
    notifyListeners();
  }

  setTaskAscompleteOrPending({
    required String taskId,
  }) {
    final sourceList = isPendingTasksPage ? pendingTaskList : completeTaskList;
    final targetList = isPendingTasksPage ? completeTaskList : pendingTaskList;

    final taskIndex = sourceList.indexWhere((task) => task.id == taskId);

    if (taskIndex != -1) {
      sourceList[taskIndex].pending = !sourceList[taskIndex].pending;
      sourceList[taskIndex].showDetails = false;

      targetList.add(sourceList[taskIndex]);
      sourceList.removeAt(taskIndex);

      notifyListeners();
    }
  }

  deleteTask({required String taskId}) {
    if (isPendingTasksPage) {
      pendingTaskList.removeWhere((task) => task.id == taskId);
    } else {
      completeTaskList.removeWhere((task) => task.id == taskId);
    }
    notifyListeners();
  }

  showTaskDetailsFunction({
    required String taskId,
  }) {
    final targetList = isPendingTasksPage ? pendingTaskList : completeTaskList;
    final taskIndex = targetList.indexWhere((task) => task.id == taskId);
    
    if (taskIndex != -1) {
      targetList[taskIndex].showDetails = !targetList[taskIndex].showDetails;
      notifyListeners();
    }
    notifyListeners();
  }
}
