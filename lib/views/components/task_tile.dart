import 'package:flutter/material.dart';
import 'package:todo/views/task_details_page.dart';

import '../../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final Function(bool?)? onCheck;

  const TaskTile({super.key, required this.task, this.onCheck});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskDetailPage(task: task)),
        );
      },
      contentPadding: EdgeInsets.all(10),
      title: Text(task.title),
      subtitle: Text(task.description),
      leading: Checkbox(value: task.completed, onChanged: onCheck),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
    );
  }
}
