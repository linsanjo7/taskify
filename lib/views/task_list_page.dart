import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../di/providers.dart';
import 'components/task_input_field.dart';
import 'components/task_tile.dart';

class TaskListPage extends ConsumerStatefulWidget {
  final String userEmail;

  const TaskListPage({super.key, required this.userEmail});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final _addTaskFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.userEmail;
    _loadTasks();
  }

  @override
  void didUpdateWidget(TaskListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userEmail != oldWidget.userEmail) {
      _loadTasks();
    }
  }

  void _loadTasks() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = ref.read(taskListViewModelProvider);
      vm.listenToTasks(widget.userEmail);
    });
  }

  void _addTask() {
    if (_addTaskFormKey.currentState?.validate() ?? false) {
      ref.read(taskListViewModelProvider).addTask(
            _titleCtrl.text,
            _descCtrl.text,
            widget.userEmail,
          );
      _titleCtrl.clear();
      _descCtrl.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _showChangeEmailDialog() {
    final theme = Theme.of(context);
    final currentEmail = widget.userEmail;
    final newEmailController = TextEditingController(text: currentEmail);

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
        child: Form(
          key: _emailFormKey,
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
                'Change Email',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newEmailController,
                decoration: InputDecoration(
                  labelText: 'New Email',
                  hintText: 'Enter your new email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[^@]+@[^\s]+\.[^\s]+$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  if (value == currentEmail) {
                    return 'This is already your current email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () {
                    if (_emailFormKey.currentState?.validate() ?? false) {
                      final newEmail = newEmailController.text.trim();
                      Navigator.pop(context);
                      GoRouter.of(context).go('/tasks', extra: newEmail);
                    }
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('UPDATE EMAIL'),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = ref.watch(taskListViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Tasks",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Text(
              widget.userEmail,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showChangeEmailDialog,
            tooltip: 'Change Email',
          ),
        ],
      ),
      body: Form(
        key: _addTaskFormKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((255 * 0.05).toInt()),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add New Task',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TaskInputField(
                    controller: _titleCtrl,
                    hint: 'Task title',
                    prefixIcon: Icons.title,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      if (value.trim().length < 3) {
                        return 'Title too small';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TaskInputField(
                    controller: _descCtrl,
                    hint: "Add description",
                    maxLines: 2,
                    prefixIcon: Icons.description,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
                      }
                      if (value.trim().length < 3) {
                        return 'Description too small';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: vm.isLoading ? null : _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: vm.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Add Task",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Your Tasks',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha((255 * 0.1).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${vm.tasks.length} ${vm.tasks.length == 1 ? 'task' : 'tasks'}' ,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (vm.isLoading && vm.tasks.isEmpty)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (vm.tasks.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks yet!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add a task to get started',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: vm.tasks.length,
                  itemBuilder: (context, i) {
                    final task = vm.tasks[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: TaskTile(
                        task: task,
                        onCheck: (value) {
                          if (value != null) {
                            vm.updateTask(
                              task.copyWith(completed: value),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
