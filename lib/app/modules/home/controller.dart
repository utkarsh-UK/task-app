import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:todo/app/data/models/task.dart';
import 'package:todo/app/data/services/storage/repository.dart';

class HomeController extends GetxController {
  final TaskRepository taskRepository;

  HomeController({required this.taskRepository});

  final formKey = GlobalKey<FormState>();
  final editController = TextEditingController();

  final tabIndex = 0.obs;
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final task = Rx<Task?>(null);
  final tasks = <Task>[].obs;
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();

    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    super.onClose();

    editController.dispose();
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? value) {
    task.value = value;
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void changeTodos(List<dynamic> select) {
    doingTodos.clear();
    doneTodos.clear();

    for (int i = 0; i < select.length; i++) {
      final todo = select[i];
      final status = todo['done'];
      if (status) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }

    tasks.add(task);
    return true;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  bool updateTask(Task task, String title) {
    final todos = task.todos ?? [];

    if (containsTodo(todos, title)) {
      return false;
    }

    final todo = {'title': title, 'done': false};
    todos.add(todo);
    final newTask = task.copyWith(todos: todos);
    int oldIndex = tasks.indexOf(task);
    tasks[oldIndex] = newTask;
    tasks.refresh();

    return true;
  }

  bool containsTodo(List todos, String title) => todos.any((element) => element['title'] == title);

  bool addTodo(String title) {
    final todo = {'title': title, 'done': false};

    if (doingTodos.any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }

    final doneTodo = {'title': title, 'done': true};
    if (doingTodos.any((element) => mapEquals<String, dynamic>(doneTodo, element))) {
      return false;
    }

    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    final newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([...doingTodos, ...doneTodos]);

    final newTask = task.value!.copyWith(todos: newTodos);
    int oldIndex = tasks.indexOf(task.value);

    tasks[oldIndex] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    final doingTodo = {'title': title, 'done': false};
    final index = doingTodos.indexWhere((element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);

    final doneTodo = {'title': title, 'done': true};
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    int index = doneTodos.indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doneTodos.removeAt(index);

    doneTodos.refresh();
  }

  bool isTodoEmpty(Task task) => task.todos == null || task.todos!.isEmpty;

  int getDoneTodo(Task task) {
    int res = 0;

    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done']) {
        res += 1;
      }
    }

    return res;
  }

  int getTotalTask() {
    int res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }

    return res;
  }

  int getTotalDoneTask() {
    int res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          if (tasks[i].todos![j]['done']) {
            res += 1;
          }
        }
      }
    }

    return res;
  }
}
