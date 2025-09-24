import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/problem_viewer_screen.dart';
import 'services/problem_service.dart';

void main() {
  runApp(const PythagonApp());
}

class PythagonApp extends StatelessWidget {
  const PythagonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProblemService()),
      ],
      child: MaterialApp.router(
        title: 'Pythagon - Math Homework Solver',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) => const CameraScreen(),
    ),
    GoRoute(
      path: '/problem-viewer',
      builder: (context, state) {
        final problemId = state.uri.queryParameters['problemId'];
        return ProblemViewerScreen(problemId: problemId);
      },
    ),
  ],
);