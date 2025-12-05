import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/firebase_options.dart';

import 'views/login_screen.dart';
import 'views/task_list_page.dart';

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/tasks',
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return TaskListPage(userEmail: email);
      },
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialiseFirebase();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initialiseFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
