import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_sense/src/controllers/helpers/helpers.dart';
import 'package:time_sense/src/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';

enum TaskskBottomSheetState { loading, loaded }

enum TasksPageState { loading, loaded }

class TasksController extends ChangeNotifier {
  TaskskBottomSheetState taskskBottomSheetState =
      TaskskBottomSheetState.loading;
  TasksPageState tasksPageState = TasksPageState.loading;
  Key animateTaskListKey = UniqueKey();

  bool isPendingTasksPage = true;
  String pageTitleText = "Pending tasks";
  String textFieldlHintText = "Create task...";

  final TaskRepository _taskRepository;
  final UserRepository _userRepository;

  List<Task> pendingTaskList = [];
  List<Task> completeTaskList = [];
  Map<String, int>? taskFocusTime;
  int? lastPendingTaskSelectedIndex;
  int? lastCompleteTaskSelectedIndex;
  final dateFormat = DateFormat('yyyy-MM-dd');

  TasksController(this._taskRepository, this._userRepository) {
    getTasksByStatus(status: 'pending');
  }

  getTasksByStatus({required String status}) async {
    switch (status) {
      case 'pending':
        pendingTaskList =
            await _taskRepository.getTasks(tasksStatus: 'pending');
      case 'complete':
        completeTaskList =
            await _taskRepository.getTasks(tasksStatus: 'complete');
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
      textFieldlHintText = 'Enter the task name...';
      notifyListeners();
    } else {
      textFieldlHintText = "Create task...";

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
      resetPageInfo();
      await _taskRepository.saveNewTask(task: newTask);
      pendingTaskList.add(newTask);
      notifyListeners();
    }
  }

  changeIsPendingTasksPage() async {
    isPendingTasksPage = !isPendingTasksPage;
    if (!isPendingTasksPage) {
      pageTitleText = 'Completed tasks';
      await getTasksByStatus(status: 'complete');
    } else {
      pageTitleText = 'Pending tasks';
    }
    notifyListeners();
  }

  setTaskAscompleteOrPending({
    required String taskId,
  }) async {
    final sourceList = isPendingTasksPage ? pendingTaskList : completeTaskList;
    final targetList = isPendingTasksPage ? completeTaskList : pendingTaskList;

    final taskIndex = sourceList.indexWhere((task) => task.id == taskId);

    if (taskIndex != -1) {
      sourceList[taskIndex].pending = !sourceList[taskIndex].pending;
      sourceList[taskIndex].showDetails = false;
      sourceList[taskIndex].completionDate = !sourceList[taskIndex].pending
          ? dateFormat.format(DateTime.now())
          : null;
      await _userRepository.updateUserStatistics(
        tasksDone: !sourceList[taskIndex].pending ? 1 : -1,
      );

      targetList.add(sourceList[taskIndex]);
      await _taskRepository.updateTask(task: sourceList[taskIndex]);
      sourceList.removeAt(taskIndex);
      lastPendingTaskSelectedIndex = null;
      lastCompleteTaskSelectedIndex = null;
      notifyListeners();
    }
  }

  deleteTask({required String taskId}) async {
    if (isPendingTasksPage) {
      pendingTaskList.removeWhere((task) => task.id == taskId);
    } else {
      completeTaskList.removeWhere((task) => task.id == taskId);
      await _userRepository.updateUserStatistics(
        tasksDone: -1,
      );
    }

    await _taskRepository.deleteTask(taskId: taskId);
    lastPendingTaskSelectedIndex = null;
    lastCompleteTaskSelectedIndex = null;
    notifyListeners();
  }

  showTaskDetailsFunction({
    required String taskId,
  }) {
    final targetList = isPendingTasksPage ? pendingTaskList : completeTaskList;
    final taskIndex = targetList.indexWhere((task) => task.id == taskId);

    if (taskIndex != -1) {
      taskFocusTime = Helper.convertTaskTime(
          totalSeconds: targetList[taskIndex].totalFocusingTime);
      targetList[taskIndex].showDetails = !targetList[taskIndex].showDetails;

      if (isPendingTasksPage) {
        if (lastPendingTaskSelectedIndex != null &&
            lastPendingTaskSelectedIndex != taskIndex) {
          targetList[lastPendingTaskSelectedIndex!].showDetails = false;
        }
        lastPendingTaskSelectedIndex = taskIndex;
      } else {
        if (lastCompleteTaskSelectedIndex != null &&
            lastCompleteTaskSelectedIndex != taskIndex) {
          targetList[lastCompleteTaskSelectedIndex!].showDetails = false;
        }
        lastCompleteTaskSelectedIndex = taskIndex;
      }
    }
    notifyListeners();
  }

  savePomodoroTaskTime({
    required String taskId,
    required int taskTime,
    required bool isCompleted,
    required bool pomodoroNotStarted,
  }) async {
    final taskIndex = pendingTaskList.indexWhere((task) => task.id == taskId);

    pendingTaskList[taskIndex].pending = isCompleted ? false : true;
    pendingTaskList[taskIndex].totalFocusingTime = !pomodoroNotStarted
        ? taskTime += pendingTaskList[taskIndex].totalFocusingTime
        : taskTime;

    pendingTaskList[taskIndex].showDetails = false;
    pendingTaskList[taskIndex].completionDate =
        isCompleted ? dateFormat.format(DateTime.now()) : null;

    await _taskRepository.updateTask(task: pendingTaskList[taskIndex]);
    if (isCompleted) {
      completeTaskList.add(pendingTaskList[taskIndex]);
      pendingTaskList.removeAt(taskIndex);
      await _userRepository.updateUserStatistics(
        tasksDone: 1,
      );
    }

    isCompleted ? notifyListeners() : null;
  }

  updateTaskTime({required Task pomodoroTask}) {
    final taskIndex =
        pendingTaskList.indexWhere((task) => task.id == pomodoroTask.id);
    pendingTaskList[taskIndex].totalFocusingTime !=
            pomodoroTask.totalFocusingTime
        ? pendingTaskList[taskIndex].totalFocusingTime =
            pomodoroTask.totalFocusingTime
        : null;
  }

  setTaskShowDetails() {
    final targetList = isPendingTasksPage ? pendingTaskList : completeTaskList;

    for (var task in targetList) {
      task.showDetails = false;
    }
  }

  resetPageInfo() {
    setTaskShowDetails();
    isPendingTasksPage = true;
    pageTitleText = 'Pending tasks';
  }

  resetTaskListAnimation() {
    animateTaskListKey = UniqueKey();
  }
}
