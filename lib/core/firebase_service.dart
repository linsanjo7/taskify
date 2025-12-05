import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirebaseService {
  final _tasks = FirebaseFirestore.instance.collection("tasks");

  Stream<List<TaskModel>> streamTasks(String userEmail) {
    return _tasks.where("sharedWith", arrayContains: userEmail).snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => TaskModel.fromMap(doc.data()))
          .toList(),
    );
  }

  Future<void> addTask(TaskModel task) async {
    await _tasks.doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    await _tasks.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasks.doc(taskId).delete();
  }
}
