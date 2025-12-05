import 'dart:async';

import 'package:flutter/material.dart';
import '../core/firebase_service.dart';
import '../models/task_model.dart';

class TaskListViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService;
  bool _isLoading = true;
  StreamSubscription<List<TaskModel>>? _tasksSubscription;
  String? _currentEmail;

  TaskListViewModel(this._firebaseService);

  List<TaskModel> tasks = [];
  
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }

  void listenToTasks(String email) {
    if (_currentEmail != email) {
      _tasksSubscription?.cancel();
      _currentEmail = email;
      _isLoading = true;
      tasks = [];
      notifyListeners();
      
      _tasksSubscription = _firebaseService.streamTasks(email).listen(
        (data) {
          tasks = data;
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _isLoading = false;
          notifyListeners();
          debugPrint('Error loading tasks: $error');
        },
      );
    }
  }

  Future<void> addTask(String title, String desc, String email) async {
    final task = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: desc,
      completed: false,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      sharedWith: [email],
    );

    await _firebaseService.addTask(task);
  }

  Future<void> updateTask(TaskModel updated) async {
    await _firebaseService.updateTask(updated);
  }

  Future<void> deleteTask(TaskModel task) async {
    await _firebaseService.deleteTask(task.id);
  }

}
