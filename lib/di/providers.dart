import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/firebase_service.dart';
import '../viewmodels/task_list_viewmodel.dart';

final firebaseServiceProvider = Provider((ref) => FirebaseService());

final taskListViewModelProvider =
ChangeNotifierProvider<TaskListViewModel>((ref) {
  return TaskListViewModel(ref.read(firebaseServiceProvider));
});
