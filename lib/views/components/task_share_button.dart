import 'package:flutter/material.dart';
import '../../../models/task_model.dart';
import '../../../core/share_service.dart';

class TaskShareButton extends StatelessWidget {
  final TaskModel task;

  TaskShareButton({super.key, required this.task});

  final shareService = ShareService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha(
            (255 * 0.2).toInt(),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () {
          shareService.shareTask(task.title, task.description);
        },
        icon: Icon(Icons.share),
      ),
    );
  }
}
