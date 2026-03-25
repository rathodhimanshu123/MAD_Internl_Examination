import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import '../models/task_model.dart';
import '../services/local_db_service.dart';
import 'package:uuid/uuid.dart';

final taskListProvider = StateNotifierProvider<TaskListNotifier, List<TaskModel>>((ref) {
  return TaskListNotifier();
});

class TaskListNotifier extends StateNotifier<List<TaskModel>> {
  TaskListNotifier() : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await LocalDatabaseService.instance.getAllTasks();
    state = tasks;
  }

  Future<void> addTask(String title) async {
    final newTask = TaskModel(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await LocalDatabaseService.instance.insertTask(newTask);
    state = [newTask, ...state];
  }

  Future<void> toggleTask(String id) async {
    final index = state.indexWhere((task) => task.id == id);
    if (index != -1) {
      final updatedTask = state[index].copyWith(
        isCompleted: !state[index].isCompleted,
        updatedAt: DateTime.now(),
      );
      await LocalDatabaseService.instance.insertTask(updatedTask);
      state = [
        for (final task in state)
          if (task.id == id) updatedTask else task,
      ];
    }
  }

  Future<void> updateTaskTitle(String id, String newTitle) async {
    final index = state.indexWhere((task) => task.id == id);
    if (index != -1) {
      final updatedTask = state[index].copyWith(
        title: newTitle,
        updatedAt: DateTime.now(),
      );
      await LocalDatabaseService.instance.insertTask(updatedTask);
      state = [
        for (final task in state)
          if (task.id == id) updatedTask else task,
      ];
    }
  }

  Future<void> deleteTask(String id) async {
    await LocalDatabaseService.instance.deleteTask(id);
    state = state.where((task) => task.id != id).toList();
  }

  Future<void> deleteTaskByTitle(String title) async {
    final task = state.firstWhere(
      (t) => t.title.toLowerCase().contains(title.toLowerCase()),
      orElse: () => TaskModel(id: '', title: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    );
    if (task.id.isNotEmpty) {
      await deleteTask(task.id);
    }
  }

  Future<void> toggleTaskByTitle(String title) async {
    final task = state.firstWhere(
      (t) => t.title.toLowerCase().contains(title.toLowerCase()),
      orElse: () => TaskModel(id: '', title: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    );
    if (task.id.isNotEmpty) {
      await toggleTask(task.id);
    }
  }
}
