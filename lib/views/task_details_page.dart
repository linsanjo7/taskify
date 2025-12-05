import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/views/components/task_details_card.dart';
import '../di/providers.dart';
import '../models/task_model.dart';

class TaskDetailPage extends ConsumerWidget {
  final TaskModel task;
  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(taskListViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Task Detail")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TaskDetailCard(
              task: task,
              onUpdate: (title, desc) {
                final updatedTask = TaskModel(
                  id: task.id,
                  title: title,
                  description: desc,
                  completed: task.completed,
                  createdAt: task.createdAt,
                  sharedWith: task.sharedWith,
                );
            
                vm.updateTask(updatedTask);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Task updated!")),
                );
              },
              onDelete: () {
                vm.deleteTask(task);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Task deleted!")),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
