import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/views/components/task_details_input_field.dart';
import 'package:todo/views/components/task_share_button.dart';

import '../../../di/providers.dart';
import '../../../models/task_model.dart';

class TaskDetailCard extends StatelessWidget {
  final TaskModel task;
  final Function(String title, String desc)? onUpdate;
  final VoidCallback? onDelete;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  TaskDetailCard({super.key, required this.task, this.onUpdate, this.onDelete});

  void _showShareDialog(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Share Task (via Email)',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email to share with',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  prefixIcon: const Icon(Icons.email_outlined),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[^@]+@[^\s]+\.[^\s]+$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Consumer(
                builder: (context, ref, _) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final email = _emailController.text.trim();
                        final vm = ref.read(taskListViewModelProvider);

                        final updatedTask = TaskModel(
                          id: task.id,
                          title: task.title,
                          description: task.description,
                          completed: task.completed,
                          createdAt: task.createdAt,
                          sharedWith: [...task.sharedWith, email],
                        );

                        try {
                          await vm.updateTask(updatedTask);
                          if (context.mounted) {
                            Navigator.pop(context);
                            _emailController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Task shared successfully!',
                                ),
                                backgroundColor: theme.colorScheme.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to share: ${e.toString()}',
                                ),
                                backgroundColor: theme.colorScheme.error,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'SHARE TASK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outline.withAlpha((255 * 0.1).toInt()),
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Task Details",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withAlpha(
                        (255 * 0.2).toInt(),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.errorContainer,
                      ),
                    ),
                    child: IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: theme.colorScheme.error,
                        size: 22,
                      ),
                      tooltip: 'Delete Task',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Task Title',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(
                    (255 * 0.8).toInt(),
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TaskDetailInputField(
                label: "Enter task title",
                controller: titleController,
              ),
              const SizedBox(height: 20),
              Text(
                'Description',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(
                    (255 * 0.8).toInt(),
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TaskDetailInputField(
                label: "Add a detailed description",
                controller: descController,
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        if (onUpdate != null) {
                          onUpdate!(
                            titleController.text.trim(),
                            descController.text.trim(),
                          );
                        }
                      },
                      icon: const Icon(Icons.save_rounded, size: 20),
                      label: const Text("Save Changes"),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TaskShareButton(task: task),
                  const SizedBox(width: 12),
                  Container(
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
                      onPressed: () => _showShareDialog(context),
                      icon: const Icon(Icons.person_add_rounded),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
