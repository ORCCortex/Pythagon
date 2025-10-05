import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/problem_viewer_screen.dart';
import 'screens/problem_detail_screen.dart';
import 'services/problem_service.dart';
import 'services/api_service.dart';

void main() {
  runApp(const ORCCortexApp());
}

class ORCCortexApp extends StatelessWidget {
  const ORCCortexApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    
    return MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        ChangeNotifierProvider(create: (_) => ProblemService(apiService)),
      ],
      child: MaterialApp.router(
        title: 'ORCCortex - PDF Math Solver',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
    GoRoute(
      path: '/problem-detail',
      builder: (context, state) {
        final problemId = state.uri.queryParameters['problemId'];
        if (problemId == null) {
          return const Scaffold(
            body: Center(child: Text('Problem ID required')),
          );
        }
        return ProblemDetailScreen(problemId: problemId);
      },
    ),
  ],
);